// ============================================================================
// apb_uart.sv  —  PULP-platform APB UART peripheral (self-contained Verilog)
//
// 16550-compatible register map (same as PULP apb_uart VHDL reference):
//   PADDR[2:0]  DLAB=0 Read     DLAB=0 Write   DLAB=1
//   3'b000      RBR              THR             DLL
//   3'b001      IER              IER             DLM
//   3'b010      IIR (RO)         FCR (WO)        -
//   3'b011      LCR              LCR             -
//   3'b100      MCR              MCR             -
//   3'b101      LSR (RO)         -               -
//   3'b110      MSR (RO)         -               -
//   3'b111      SCR              SCR             -
//
// Port interface is identical to the OBI apb_uart shim so pulp_uart_wrap.sv
// connects without any changes.
// ============================================================================

module apb_uart #(
    parameter FIFO_DEPTH = 16
)(
    input  wire         CLK,
    input  wire         RSTN,

    // APB slave
    input  wire         PSEL,
    input  wire         PENABLE,
    input  wire         PWRITE,
    input  wire  [2:0]  PADDR,
    input  wire  [31:0] PWDATA,
    output logic [31:0] PRDATA,
    output logic        PREADY,
    output logic        PSLVERR,

    // Interrupt
    output logic        INT,

    // Modem control outputs
    output logic        OUT1N,
    output logic        OUT2N,
    output logic        RTSN,
    output logic        DTRN,

    // Modem control inputs (tied high by wrapper)
    input  wire         CTSN,
    input  wire         DSRN,
    input  wire         DCDN,
    input  wire         RIN,

    // Serial
    input  wire         SIN,
    output logic        SOUT
);

    // -----------------------------------------------------------------------
    // Parameters
    // -----------------------------------------------------------------------
    localparam FDEPTH = FIFO_DEPTH;
    localparam FWID   = $clog2(FDEPTH);

    // -----------------------------------------------------------------------
    // 16550 Shadow Registers
    // -----------------------------------------------------------------------
    logic [7:0] dll_r, dlm_r;
    logic [7:0] ier_r, fcr_r, lcr_r, mcr_r, scr_r;
    logic       lsr_oe_r;
    wire        dlab = lcr_r[7];

    // -----------------------------------------------------------------------
    // TX FIFO
    // -----------------------------------------------------------------------
    logic [7:0]     txf_mem [0:FDEPTH-1];
    logic [FWID:0]  txf_wptr, txf_rptr;
    wire            txf_empty = (txf_wptr == txf_rptr);
    wire            txf_full  = (txf_wptr[FWID] != txf_rptr[FWID]) &&
                                (txf_wptr[FWID-1:0] == txf_rptr[FWID-1:0]);
    wire  [7:0]     txf_rdata = txf_mem[txf_rptr[FWID-1:0]];

    logic txf_wen, txf_ren;

    always_ff @(posedge CLK or negedge RSTN) begin
        if (!RSTN) txf_wptr <= '0;
        else if (txf_wen && !txf_full) begin
            txf_mem[txf_wptr[FWID-1:0]] <= PWDATA[7:0];
            txf_wptr <= txf_wptr + 1'b1;
        end
    end
    always_ff @(posedge CLK or negedge RSTN) begin
        if (!RSTN) txf_rptr <= '0;
        else if (txf_ren && !txf_empty) txf_rptr <= txf_rptr + 1'b1;
    end

    // -----------------------------------------------------------------------
    // RX FIFO
    // -----------------------------------------------------------------------
    logic [7:0]     rxf_mem [0:FDEPTH-1];
    logic [FWID:0]  rxf_wptr, rxf_rptr;
    wire            rxf_empty = (rxf_wptr == rxf_rptr);
    wire            rxf_full  = (rxf_wptr[FWID] != rxf_rptr[FWID]) &&
                                (rxf_wptr[FWID-1:0] == rxf_rptr[FWID-1:0]);
    wire  [7:0]     rxf_rdata = rxf_mem[rxf_rptr[FWID-1:0]];

    logic rxf_wen, rxf_ren;
    logic [7:0] rx_byte_in;

    always_ff @(posedge CLK or negedge RSTN) begin
        if (!RSTN) rxf_wptr <= '0;
        else if (rxf_wen && !rxf_full) begin
            rxf_mem[rxf_wptr[FWID-1:0]] <= rx_byte_in;
            rxf_wptr <= rxf_wptr + 1'b1;
        end
    end
    always_ff @(posedge CLK or negedge RSTN) begin
        if (!RSTN) rxf_rptr <= '0;
        else if (rxf_ren && !rxf_empty) rxf_rptr <= rxf_rptr + 1'b1;
    end

    // -----------------------------------------------------------------------
    // LSR / IIR / MSR (read-only status)
    // -----------------------------------------------------------------------
    wire [7:0] lsr = {1'b0, txf_empty, txf_empty, 1'b0, 1'b0, 1'b0, lsr_oe_r, ~rxf_empty};
    wire [7:0] msr = {DCDN, RIN, DSRN, CTSN, 4'b0000};

    wire int_rls  = ier_r[2] & lsr_oe_r;
    wire int_rda  = ier_r[0] & ~rxf_empty;
    wire int_thre = ier_r[1] &  txf_empty;

    wire [7:0] iir = int_rls  ? 8'hC6 :
                     int_rda  ? 8'hC4 :
                     int_thre ? 8'hC2 :
                                8'hC1;

    assign INT = ~iir[0];

    // -----------------------------------------------------------------------
    // APB interface
    // -----------------------------------------------------------------------
    wire apb_wr = PSEL & PENABLE &  PWRITE;
    wire apb_rd = PSEL & PENABLE & ~PWRITE;

    assign PREADY  = 1'b1;
    assign PSLVERR = 1'b0;

    assign txf_wen = apb_wr & ~dlab & (PADDR == 3'b000);
    assign rxf_ren = apb_rd & ~dlab & (PADDR == 3'b000);

    always_comb begin
        PRDATA = 32'h0;
        if (apb_rd) begin
            case (PADDR)
                3'b000: PRDATA = dlab ? {24'h0, dll_r}   : {24'h0, rxf_rdata};
                3'b001: PRDATA = dlab ? {24'h0, dlm_r}   : {24'h0, ier_r};
                3'b010: PRDATA = {24'h0, iir};
                3'b011: PRDATA = {24'h0, lcr_r};
                3'b100: PRDATA = {24'h0, mcr_r};
                3'b101: PRDATA = {24'h0, lsr};
                3'b110: PRDATA = {24'h0, msr};
                3'b111: PRDATA = {24'h0, scr_r};
                default: PRDATA = 32'h0;
            endcase
        end
    end

    always_ff @(posedge CLK or negedge RSTN) begin
        if (!RSTN) begin
            dll_r    <= 8'd1;  dlm_r <= 8'd0;
            ier_r    <= 8'h0;  fcr_r <= 8'h0;
            lcr_r    <= 8'h3;  mcr_r <= 8'h0;
            scr_r    <= 8'h0;
            lsr_oe_r <= 1'b0;
        end else begin
            if (rxf_wen && rxf_full) lsr_oe_r <= 1'b1;
            if (apb_rd && PADDR == 3'b101) lsr_oe_r <= 1'b0;

            if (apb_wr) begin
                case (PADDR)
                    3'b000: if (dlab) dll_r <= PWDATA[7:0];
                    3'b001: if (dlab) dlm_r <= PWDATA[7:0];
                            else      ier_r <= PWDATA[7:0] & 8'h0F;
                    3'b010: fcr_r <= PWDATA[7:0];
                    3'b011: lcr_r <= PWDATA[7:0];
                    3'b100: mcr_r <= PWDATA[7:0] & 8'h1F;
                    3'b111: scr_r <= PWDATA[7:0];
                    default: ;
                endcase
            end
        end
    end

    // -----------------------------------------------------------------------
    // Baud rate generator  (16× oversampling tick)
    // baud_div = DLM:DLL  =  Fclk / (baud × 16)
    // -----------------------------------------------------------------------
    logic [15:0] baud_div;
    logic [15:0] baud_cnt;
    logic        baud_tick;

    assign baud_div = {dlm_r, dll_r};

    always_ff @(posedge CLK or negedge RSTN) begin
        if (!RSTN) begin
            baud_cnt  <= 16'h1;
            baud_tick <= 1'b0;
        end else begin
            baud_tick <= 1'b0;
            if (baud_cnt >= baud_div) begin
                baud_cnt  <= 16'h1;
                baud_tick <= 1'b1;
            end else begin
                baud_cnt <= baud_cnt + 1'b1;
            end
        end
    end

    // -----------------------------------------------------------------------
    // TX engine  (16× baud ticks per bit)
    // -----------------------------------------------------------------------
    localparam TX_IDLE  = 2'd0;
    localparam TX_START = 2'd1;
    localparam TX_DATA  = 2'd2;
    localparam TX_STOP  = 2'd3;

    logic [1:0] tx_state;
    logic [3:0] tx_sub;      // 0..15 sub-bit counter
    logic [2:0] tx_bit_idx;
    logic [7:0] tx_shift;

    assign txf_ren = (tx_state == TX_IDLE) & ~txf_empty & baud_tick;

    always_ff @(posedge CLK or negedge RSTN) begin
        if (!RSTN) begin
            tx_state   <= TX_IDLE;
            tx_sub     <= 4'h0;
            tx_bit_idx <= 3'h0;
            tx_shift   <= 8'hFF;
            SOUT       <= 1'b1;
        end else if (baud_tick) begin
            case (tx_state)
                TX_IDLE: begin
                    SOUT <= 1'b1;
                    if (!txf_empty) begin
                        tx_shift <= txf_rdata;
                        tx_sub   <= 4'h0;
                        tx_state <= TX_START;
                    end
                end
                TX_START: begin
                    SOUT   <= 1'b0;
                    tx_sub <= tx_sub + 1'b1;
                    if (tx_sub == 4'hF) begin
                        tx_bit_idx <= 3'h0;
                        tx_sub     <= 4'h0;
                        tx_state   <= TX_DATA;
                    end
                end
                TX_DATA: begin
                    SOUT   <= tx_shift[tx_bit_idx];
                    tx_sub <= tx_sub + 1'b1;
                    if (tx_sub == 4'hF) begin
                        tx_sub <= 4'h0;
                        if (tx_bit_idx == 3'h7) tx_state <= TX_STOP;
                        else                    tx_bit_idx <= tx_bit_idx + 1'b1;
                    end
                end
                TX_STOP: begin
                    SOUT   <= 1'b1;
                    tx_sub <= tx_sub + 1'b1;
                    if (tx_sub == 4'hF) begin
                        tx_sub   <= 4'h0;
                        tx_state <= TX_IDLE;
                    end
                end
                default: tx_state <= TX_IDLE;
            endcase
        end
    end

    // -----------------------------------------------------------------------
    // RX engine  (start-bit detection + 16× oversampling)
    // 2-stage synchronizer on SIN (metastability protection)
    // -----------------------------------------------------------------------
    localparam RX_IDLE  = 2'd0;
    localparam RX_START = 2'd1;
    localparam RX_DATA  = 2'd2;
    localparam RX_STOP  = 2'd3;

    logic sin_s1, sin_s2;   // sync chain
    always_ff @(posedge CLK or negedge RSTN)
        if (!RSTN) {sin_s2, sin_s1} <= 2'b11;
        else       {sin_s2, sin_s1} <= {sin_s1, SIN};

    logic [1:0] rx_state;
    logic [3:0] rx_sub;
    logic [2:0] rx_bit_idx;
    logic [7:0] rx_shift;
    logic       rx_push;    // pulse: push rx_shift into FIFO

    assign rxf_wen   = rx_push;
    assign rx_byte_in = rx_shift;

    always_ff @(posedge CLK or negedge RSTN) begin
        if (!RSTN) begin
            rx_state   <= RX_IDLE;
            rx_sub     <= 4'h0;
            rx_bit_idx <= 3'h0;
            rx_shift   <= 8'h0;
            rx_push    <= 1'b0;
        end else begin
            rx_push <= 1'b0;
            if (baud_tick) begin
                case (rx_state)
                    RX_IDLE: begin
                        if (!sin_s2) begin   // start edge
                            rx_sub   <= 4'h0;
                            rx_state <= RX_START;
                        end
                    end
                    RX_START: begin
                        rx_sub <= rx_sub + 1'b1;
                        if (rx_sub == 4'h7) begin
                            if (!sin_s2) begin  // valid start bit mid-point
                                rx_sub     <= 4'h0;
                                rx_bit_idx <= 3'h0;
                                rx_state   <= RX_DATA;
                            end else begin
                                rx_state <= RX_IDLE; // glitch — abort
                            end
                        end
                    end
                    RX_DATA: begin
                        rx_sub <= rx_sub + 1'b1;
                        if (rx_sub == 4'hF) begin
                            rx_shift[rx_bit_idx] <= sin_s2;
                            rx_sub               <= 4'h0;
                            if (rx_bit_idx == 3'h7) rx_state <= RX_STOP;
                            else                    rx_bit_idx <= rx_bit_idx + 1'b1;
                        end
                    end
                    RX_STOP: begin
                        rx_sub <= rx_sub + 1'b1;
                        if (rx_sub == 4'hF) begin
                            rx_push  <= 1'b1;
                            rx_sub   <= 4'h0;
                            rx_state <= RX_IDLE;
                        end
                    end
                    default: rx_state <= RX_IDLE;
                endcase
            end
        end
    end

    // -----------------------------------------------------------------------
    // Modem control outputs
    // -----------------------------------------------------------------------
    assign OUT1N = ~mcr_r[2];
    assign OUT2N = ~mcr_r[3];
    assign RTSN  = ~mcr_r[1];
    assign DTRN  = ~mcr_r[0];

endmodule
// ============================================================================
// End of apb_uart.sv
// ============================================================================
