`timescale 1ns/1ps

module tb_apb_uart;
    reg clk, rst_n;
    always #5 clk = ~clk;

    reg        psel, penable, pwrite;
    reg  [2:0] paddr;
    reg [31:0] pwdata;
    wire[31:0] prdata;
    wire       pready, pslverr;

    wire       INT;
    wire       SOUT;
    reg        SIN;

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

    task set_baud;
        input [7:0] dll_val;
        begin
            apb_write(3'b011, 32'h83);
            apb_write(3'b000, {24'h0, dll_val});
            apb_write(3'b001, 32'h00);
            apb_write(3'b011, 32'h03);
        end
    endtask

    integer i, byte_period;
    reg [7:0] rx_byte;
    reg tx_done;

    task uart_rx_byte;
        input integer baud_ticks;
        output [7:0] data;
        integer sample_delay, b;
        begin

            @(negedge SOUT);

            repeat (baud_ticks/2) @(posedge clk);

            data = 8'h00;
            for (b = 0; b < 8; b = b+1) begin
                repeat (baud_ticks) @(posedge clk);
                data[b] = SOUT;
            end

            repeat (baud_ticks) @(posedge clk);
        end
    endtask

    task uart_tx_byte;
        input integer baud_ticks;
        input [7:0] data;
        integer b;
        begin

            SIN <= 0;
            repeat (baud_ticks) @(posedge clk);

            for (b = 0; b < 8; b = b+1) begin
                SIN <= data[b];
                repeat (baud_ticks) @(posedge clk);
            end

            SIN <= 1;
            repeat (baud_ticks) @(posedge clk);
        end
    endtask

    initial begin
        clk=0; rst_n=0; psel=0; penable=0; pwrite=0;
        paddr=0; pwdata=0; SIN=1;
        repeat(4) @(posedge clk); rst_n <= 1; @(posedge clk);

        $display("=== tb_apb_uart tests ===");

        set_baud(8'h01);

        apb_write(3'b011, 32'h83);
        apb_read(3'b000, rd);
        apb_write(3'b011, 32'h03);
        if (rd[7:0] === 8'h01) begin
            $display("[PASS] TC1 DLL=1 readback correct"); pass=pass+1;
        end else begin
            $display("[FAIL] TC1 DLL readback=0x%02h", rd[7:0]); fail=fail+1;
        end

        apb_write(3'b011, 32'h1B);
        apb_read (3'b011, rd);
        if (rd[7:0] === 8'h1B) begin
            $display("[PASS] TC2 LCR readback 0x1B"); pass=pass+1;
        end else begin
            $display("[FAIL] TC2 LCR readback=0x%02h", rd[7:0]); fail=fail+1;
        end

        apb_write(3'b111, 32'hA5);
        apb_read (3'b111, rd);
        if (rd[7:0] === 8'hA5) begin
            $display("[PASS] TC3 SCR=0xA5 readback"); pass=pass+1;
        end else begin
            $display("[FAIL] TC3 SCR readback=0x%02h", rd[7:0]); fail=fail+1;
        end

        apb_write(3'b011, 32'h03);

        apb_write(3'b001, 32'hFF);
        apb_read (3'b001, rd);
        if (rd[7:0] === 8'h0F) begin
            $display("[PASS] TC4 IER masked to 0x0F"); pass=pass+1;
        end else begin
            $display("[FAIL] TC4 IER=0x%02h (expected 0x0F)", rd[7:0]); fail=fail+1;
        end

        apb_read(3'b101, rd);
        if (rd[6] && rd[5]) begin
            $display("[PASS] TC5 LSR THRE=1 TEMT=1 (TX FIFO empty at reset)"); pass=pass+1;
        end else begin
            $display("[FAIL] TC5 LSR=0x%02h (expected THRE=TEMT=1)", rd[7:0]); fail=fail+1;
        end

        set_baud(8'h01);
        apb_write(3'b001, 32'h00);
        apb_write(3'b011, 32'h03);

        apb_write(3'b000, 32'h55);
        uart_rx_byte(16, rx_byte);
        if (rx_byte === 8'h55) begin
            $display("[PASS] TC6 TX loopback: sent 0x55, received 0x%02h", rx_byte); pass=pass+1;
        end else begin
            $display("[FAIL] TC6 TX loopback: expected 0x55, got 0x%02h", rx_byte); fail=fail+1;
        end

        uart_tx_byte(16, 8'hA5);
        repeat(20) @(posedge clk);
        apb_read(3'b101, rd);
        if (rd[0]) begin
            apb_read(3'b000, rd);
            if (rd[7:0] === 8'hA5) begin
                $display("[PASS] TC7 RX loopback: received 0xA5"); pass=pass+1;
            end else begin
                $display("[FAIL] TC7 RX: got 0x%02h", rd[7:0]); fail=fail+1;
            end
        end else begin
            $display("[FAIL] TC7 RX: LSR DR=0, no byte received"); fail=fail+1;
        end

        apb_write(3'b001, 32'h00);
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
