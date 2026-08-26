`timescale 1ns/1ps
// ============================================================
// tb_apb_uart.v — Testbench for apb_uart (16550-compatible)
// Tests: register read/write, TX loopback (SOUT->SIN), IER/IIR,
//        baud divisor, LSR status
// ============================================================
module tb_apb_uart;
    reg clk, rst_n;
    always #5 clk = ~clk;   // 100 MHz

    // APB
    reg        psel, penable, pwrite;
    reg  [2:0] paddr;
    reg [31:0] pwdata;
    wire[31:0] prdata;
    wire       pready, pslverr;
    // Interrupt & serial
    wire       INT;
    wire       SOUT;
    reg        SIN;
    // Modem (tie inactive)
    wire       OUT1N, OUT2N, RTSN, DTRN;

    apb_uart dut (
        .CLK(clk), .RSTN(rst_n),
        .PSEL(psel), .PENABLE(penable), .PWRITE(pwrite),
        .PADDR(paddr), .PWDATA(pwdata), .PRDATA(prdata),
        .PREADY(pready), .PSLVERR(pslverr),
        .INT(INT),
        .OUT1N(OUT1N), .OUT2N(OUT2N), .RTSN(RTSN), .DTRN(DTRN),
        .CTSN(1'b1), .DSRN(1'b1), .DCDN(1'b1), .RIN(1'b1),
        .SIN(SIN), .SOUT(SOUT)
    );

    integer pass=0, fail=0;
    reg [31:0] rd;

    // Single APB write
    task apb_write;
        input [2:0] addr; input [31:0] data;
        begin
            @(negedge clk);
            psel<=1; pwrite<=1; paddr<=addr; pwdata<=data; penable<=0;
            @(negedge clk); penable<=1;
            @(posedge clk); while (!pready) @(posedge clk);
            @(negedge clk); psel<=0; penable<=0; pwrite<=0;
        end
    endtask

    // Single APB read
    task apb_read;
        input [2:0] addr; output [31:0] data;
        begin
            @(negedge clk);
            psel<=1; pwrite<=0; paddr<=addr; pwdata<=0; penable<=0;
            @(negedge clk); penable<=1;
            @(posedge clk); while (!pready) @(posedge clk);
            data = prdata;
            @(negedge clk); psel<=0; penable<=0;
        end
    endtask

    // Enable DLAB (LCR[7]=1), write DLL, disable DLAB
    task set_baud;
        input [7:0] dll_val;
        begin
            apb_write(3'b011, 32'h83);   // LCR = 0x83 (DLAB=1, 8N1)
            apb_write(3'b000, {24'h0, dll_val}); // DLL
            apb_write(3'b001, 32'h00);   // DLM=0
            apb_write(3'b011, 32'h03);   // LCR = 0x03 (DLAB=0, 8N1)
        end
    endtask

    integer i, byte_period;
    reg [7:0] rx_byte;
    reg tx_done;

    // Receive one UART byte on SIN (samples at baud-rate midpoint)
    // baud_period = DLL * 16 clocks (at 100 MHz). DLL=1 => 16 clocks/bit
    task uart_rx_byte;
        input integer baud_ticks;    // clocks per bit
        output [7:0] data;
        integer sample_delay, b;
        begin
            // Wait for start bit (SOUT goes low)
            @(negedge SOUT);
            // Sample at midpoint of start bit
            repeat (baud_ticks/2) @(posedge clk);
            // Sample 8 data bits
            data = 8'h00;
            for (b = 0; b < 8; b = b+1) begin
                repeat (baud_ticks) @(posedge clk);
                data[b] = SOUT;
            end
            // Wait past stop bit
            repeat (baud_ticks) @(posedge clk);
        end
    endtask

    // Send one byte on SIN into UART RX at given baud_ticks per bit
    task uart_tx_byte;
        input integer baud_ticks;
        input [7:0] data;
        integer b;
        begin
            // Start bit
            SIN <= 0;
            repeat (baud_ticks) @(posedge clk);
            // 8 data bits LSB first
            for (b = 0; b < 8; b = b+1) begin
                SIN <= data[b];
                repeat (baud_ticks) @(posedge clk);
            end
            // Stop bit
            SIN <= 1;
            repeat (baud_ticks) @(posedge clk);
        end
    endtask

    initial begin
        clk=0; rst_n=0; psel=0; penable=0; pwrite=0;
        paddr=0; pwdata=0; SIN=1;
        repeat(4) @(posedge clk); rst_n <= 1; @(posedge clk);

        $display("=== tb_apb_uart tests ===");

        // TC1: Set DLL=1 via DLAB, read back
        set_baud(8'h01);   // DLL=1 => 16-clock baud tick
        // Read DLL back (DLAB must be 1)
        apb_write(3'b011, 32'h83);  // DLAB=1
        apb_read(3'b000, rd);       // DLL
        apb_write(3'b011, 32'h03);  // DLAB=0
        if (rd[7:0] === 8'h01) begin
            $display("[PASS] TC1 DLL=1 readback correct"); pass=pass+1;
        end else begin
            $display("[FAIL] TC1 DLL readback=0x%02h", rd[7:0]); fail=fail+1;
        end

        // TC2: LCR write/read
        apb_write(3'b011, 32'h1B);   // 8N2, no DLAB
        apb_read (3'b011, rd);
        if (rd[7:0] === 8'h1B) begin
            $display("[PASS] TC2 LCR readback 0x1B"); pass=pass+1;
        end else begin
            $display("[FAIL] TC2 LCR readback=0x%02h", rd[7:0]); fail=fail+1;
        end

        // TC3: SCR scratch register
        apb_write(3'b111, 32'hA5);
        apb_read (3'b111, rd);
        if (rd[7:0] === 8'hA5) begin
            $display("[PASS] TC3 SCR=0xA5 readback"); pass=pass+1;
        end else begin
            $display("[FAIL] TC3 SCR readback=0x%02h", rd[7:0]); fail=fail+1;
        end

        // Restore 8N1
        apb_write(3'b011, 32'h03);

        // TC4: IER write/read (only [3:0] bits valid)
        apb_write(3'b001, 32'hFF);   // write all; only 0xF sticks
        apb_read (3'b001, rd);
        if (rd[7:0] === 8'h0F) begin
            $display("[PASS] TC4 IER masked to 0x0F"); pass=pass+1;
        end else begin
            $display("[FAIL] TC4 IER=0x%02h (expected 0x0F)", rd[7:0]); fail=fail+1;
        end

        // TC5: LSR[5] (THRE) and LSR[6] (TEMT) both 1 when TX FIFO empty
        apb_read(3'b101, rd);
        if (rd[6] && rd[5]) begin
            $display("[PASS] TC5 LSR THRE=1 TEMT=1 (TX FIFO empty at reset)"); pass=pass+1;
        end else begin
            $display("[FAIL] TC5 LSR=0x%02h (expected THRE=TEMT=1)", rd[7:0]); fail=fail+1;
        end

        // TC6: TX loopback — write byte to THR, receive on SOUT
        set_baud(8'h01);    // 16 clocks/bit at 100 MHz
        apb_write(3'b001, 32'h00);  // IER=0 (no interrupts)
        apb_write(3'b011, 32'h03);  // LCR=8N1
        // Write 0x55 to THR
        apb_write(3'b000, 32'h55);
        uart_rx_byte(16, rx_byte);
        if (rx_byte === 8'h55) begin
            $display("[PASS] TC6 TX loopback: sent 0x55, received 0x%02h", rx_byte); pass=pass+1;
        end else begin
            $display("[FAIL] TC6 TX loopback: expected 0x55, got 0x%02h", rx_byte); fail=fail+1;
        end

        // TC7: RX loopback — send byte on SIN, read from RBR
        uart_tx_byte(16, 8'hA5);
        repeat(20) @(posedge clk);  // let RX state machine finish
        apb_read(3'b101, rd);       // read LSR
        if (rd[0]) begin            // DR (data ready) bit
            apb_read(3'b000, rd);   // read RBR
            if (rd[7:0] === 8'hA5) begin
                $display("[PASS] TC7 RX loopback: received 0xA5"); pass=pass+1;
            end else begin
                $display("[FAIL] TC7 RX: got 0x%02h", rd[7:0]); fail=fail+1;
            end
        end else begin
            $display("[FAIL] TC7 RX: LSR DR=0, no byte received"); fail=fail+1;
        end

        // TC8: IIR idle = 0xC1 (no interrupt pending)
        apb_write(3'b001, 32'h00);  // disable all interrupts
        apb_read(3'b010, rd);
        if (rd[7:0] === 8'hC1) begin
            $display("[PASS] TC8 IIR=0xC1 (no interrupt)"); pass=pass+1;
        end else begin
            $display("[FAIL] TC8 IIR=0x%02h (expected 0xC1)", rd[7:0]); fail=fail+1;
        end

        $display("=== tb_apb_uart RESULTS: PASS=%0d FAIL=%0d ===", pass, fail);
        if (fail==0) $display("[PASS] tb_apb_uart ALL TESTS PASSED");
        else         $display("[FAIL] tb_apb_uart %0d FAILED", fail);
        $finish;
    end
endmodule
