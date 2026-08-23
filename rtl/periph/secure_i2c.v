// =============================================================================
// secure_i2c.v — Security-Hardened I2C Master Peripheral
// AXI-Lite Slave Interface, Standard (100 kHz) and Fast (400 kHz) modes
//
// Attack protections:
//   1. Address whitelist  — transactions to non-whitelisted addresses blocked
//   2. Bus timeout        — SCL held low >10 ms triggers 9-pulse bus recovery
//   3. SDA glitch filter  — SDA changes require 3 stable samples
//   4. Max transaction    — >255 bytes without STOP forces STOP + length_fault
//   5. Secure lockout     — secure_mode disables master (SCL/SDA released)
//
// Register map (AXI-Lite, 32-bit word addressing):
//   0x00 CTRL      [3:0]  {ACK_EN, RW, STOP, START}
//   0x04 ADDR      [6:0]  device address
//   0x08 WDATA     [7:0]  write byte
//   0x0C RDATA     [7:0]  read byte (RO)
//   0x10 STATUS    [6:0]  {LEN_FAULT, BUS_STUCK, BLOCKED, NACK, ACK_OK, DONE, BUSY}
//   0x14 PRESCALE  [15:0] clock divider for SCL
//   0x18 WL_CTRL   [8,1:0]{WL_EN, WL_IDX[1:0]}
//   0x1C WL_ADDR   [6:0]  whitelist entry write
//   0x20 ALERT_CLR write any to clear stuck/fault flags
// =============================================================================

`timescale 1ns/1ps

module secure_i2c #(
    parameter CLK_FREQ       = 50_000_000,
    parameter BUS_TIMEOUT_CY = 500_000,   // 10 ms @ 50 MHz
    parameter PRESCALE_DEF   = 125        // 50 MHz / (4 * 100 kHz) = 125
) (
    input  wire        clk,
    input  wire        rst_n,

    // Security
    input  wire        secure_mode,

    // I2C tristate bus
    output reg         scl_out,
    output reg         scl_oen,   // 1 = output enabled (drive low)
    input  wire        scl_in,
    output reg         sda_out,
    output reg         sda_oen,   // 1 = output enabled (drive low)
    input  wire        sda_in,

    // Interrupt
    output wire        irq,

    // AXI-Lite slave
    input  wire [31:0] s_axil_awaddr,
    input  wire        s_axil_awvalid,
    output reg         s_axil_awready,
    input  wire [31:0] s_axil_wdata,
    input  wire [3:0]  s_axil_wstrb,
    input  wire        s_axil_wvalid,
    output reg         s_axil_wready,
    output reg  [1:0]  s_axil_bresp,
    output reg         s_axil_bvalid,
    input  wire        s_axil_bready,
    input  wire [31:0] s_axil_araddr,
    input  wire        s_axil_arvalid,
    output reg         s_axil_arready,
    output reg  [31:0] s_axil_rdata,
    output reg  [1:0]  s_axil_rresp,
    output reg         s_axil_rvalid,
    input  wire        s_axil_rready
);

    // =========================================================================
    // Address constants
    // =========================================================================
    localparam ADDR_CTRL      = 6'h00;
    localparam ADDR_ADDR      = 6'h04;
    localparam ADDR_WDATA     = 6'h08;
    localparam ADDR_RDATA     = 6'h0C;
    localparam ADDR_STATUS    = 6'h10;
    localparam ADDR_PRESCALE  = 6'h14;
    localparam ADDR_WL_CTRL   = 6'h18;
    localparam ADDR_WL_ADDR   = 6'h1C;
    localparam ADDR_ALERT_CLR = 6'h20;

    // I2C master FSM states
    localparam ST_IDLE      = 4'd0;
    localparam ST_WL_CHECK  = 4'd1;
    localparam ST_START     = 4'd2;
    localparam ST_ADDR_TX   = 4'd3;
    localparam ST_ADDR_ACK  = 4'd4;
    localparam ST_DATA_TX   = 4'd5;
    localparam ST_DATA_ACK  = 4'd6;
    localparam ST_DATA_RX   = 4'd7;
    localparam ST_RX_ACK    = 4'd8;
    localparam ST_STOP      = 4'd9;
    localparam ST_RECOVERY  = 4'd10;
    localparam ST_DONE      = 4'd11;

    // =========================================================================
    // Registers
    // =========================================================================
    reg [3:0]  ctrl_reg;
    reg [6:0]  addr_reg;
    reg [7:0]  wdata_reg;
    reg [7:0]  rdata_reg;
    reg [15:0] prescale_reg;

    // Status bits
    reg        busy, done_flag, ack_ok, nack_flag;
    reg        blocked_flag, bus_stuck_flag, len_fault_flag;

    // Whitelist
    reg        wl_en;
    reg [1:0]  wl_idx;
    reg [6:0]  whitelist [0:3];

    // I2C FSM
    reg [3:0]  i2c_state;
    reg [3:0]  bit_cnt;
    reg [7:0]  shift_reg;
    reg [15:0] scl_cnt;      // prescaler counter
    reg        scl_phase;    // 0 = SCL low half, 1 = SCL high half
    reg [7:0]  byte_cnt;     // transaction byte count
    reg        do_read;

    // SDA glitch filter
    reg [1:0]  sda_filt_cnt;
    reg        sda_filt_val;
    reg        sda_stable;

    // SCL glitch / bus timeout
    reg [19:0] scl_low_cnt;
    reg        bus_timeout;

    // Recovery pulse counter
    reg [3:0]  rcv_pulse_cnt;
    reg [15:0] rcv_cnt;

    // AXI write state
    reg        aw_active;
    reg [5:0]  aw_addr_lat;

    // =========================================================================
    // SDA Glitch Filter — 3 stable samples required
    // =========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sda_filt_cnt <= 2'd0;
            sda_filt_val <= 1'b1;
            sda_stable   <= 1'b1;
        end else begin
            if (sda_in == sda_filt_val) begin
                if (sda_filt_cnt < 2'd3)
                    sda_filt_cnt <= sda_filt_cnt + 1'b1;
                else
                    sda_stable <= sda_filt_val;
            end else begin
                sda_filt_val <= sda_in;
                sda_filt_cnt <= 2'd0;
            end
        end
    end

    // =========================================================================
    // SCL Bus Timeout Monitor
    // =========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scl_low_cnt  <= 20'd0;
            bus_timeout  <= 1'b0;
        end else begin
            if (!scl_in && busy) begin
                if (scl_low_cnt < BUS_TIMEOUT_CY[19:0])
                    scl_low_cnt <= scl_low_cnt + 1'b1;
                else
                    bus_timeout <= 1'b1;
            end else begin
                scl_low_cnt <= 20'd0;
                bus_timeout <= 1'b0;
            end
        end
    end

    // =========================================================================
    // Whitelist Check (combinational)
    // =========================================================================
    wire wl_pass = !wl_en ||
                   (addr_reg == whitelist[0]) ||
                   (addr_reg == whitelist[1]) ||
                   (addr_reg == whitelist[2]) ||
                   (addr_reg == whitelist[3]);

    // =========================================================================
    // I2C Master FSM
    // =========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i2c_state    <= ST_IDLE;
            scl_out      <= 1'b1;
            scl_oen      <= 1'b0;
            sda_out      <= 1'b1;
            sda_oen      <= 1'b0;
            scl_cnt      <= 16'd0;
            scl_phase    <= 1'b0;
            bit_cnt      <= 4'd0;
            shift_reg    <= 8'd0;
            byte_cnt     <= 8'd0;
            rdata_reg    <= 8'd0;
            busy         <= 1'b0;
            done_flag    <= 1'b0;
            ack_ok       <= 1'b0;
            nack_flag    <= 1'b0;
            blocked_flag <= 1'b0;
            bus_stuck_flag <= 1'b0;
            len_fault_flag <= 1'b0;
            do_read      <= 1'b0;
            rcv_pulse_cnt <= 4'd0;
            rcv_cnt      <= 16'd0;
        end else begin
            // Secure mode: release bus
            if (secure_mode) begin
                scl_oen   <= 1'b0;
                sda_oen   <= 1'b0;
                i2c_state <= ST_IDLE;
                busy      <= 1'b0;
            end

            // Bus timeout recovery trigger
            if (bus_timeout && !bus_stuck_flag) begin
                bus_stuck_flag <= 1'b1;
                i2c_state      <= ST_RECOVERY;
                rcv_pulse_cnt  <= 4'd0;
                rcv_cnt        <= 16'd0;
                busy           <= 1'b1;
            end

            // SCL prescaler tick
            scl_cnt <= scl_cnt + 1'b1;
            if (scl_cnt >= prescale_reg) begin
                scl_cnt   <= 16'd0;
                scl_phase <= ~scl_phase;
            end

            case (i2c_state)
                // -----------------------------------------------------------------
                ST_IDLE: begin
                    scl_oen   <= 1'b0;
                    sda_oen   <= 1'b0;
                    done_flag <= 1'b0;
                    if (ctrl_reg[0] && !busy && !secure_mode) begin
                        busy      <= 1'b1;
                        byte_cnt  <= 8'd0;
                        do_read   <= ctrl_reg[2];
                        i2c_state <= ST_WL_CHECK;
                    end
                end
                // -----------------------------------------------------------------
                ST_WL_CHECK: begin
                    if (!wl_pass) begin
                        blocked_flag <= 1'b1;
                        busy         <= 1'b0;
                        i2c_state    <= ST_IDLE;
                    end else begin
                        i2c_state <= ST_START;
                        scl_cnt   <= 16'd0;
                        scl_phase <= 1'b0;
                    end
                end
                // -----------------------------------------------------------------
                // START condition: SDA goes low while SCL is high
                ST_START: begin
                    scl_oen <= 1'b0; // release SCL (high)
                    if (scl_phase) begin
                        sda_out <= 1'b0;
                        sda_oen <= 1'b1; // pull SDA low
                        if (scl_cnt == 16'd0) begin
                            // SCL goes low after SDA low
                            scl_oen   <= 1'b1;
                            shift_reg <= {addr_reg, do_read};
                            bit_cnt   <= 4'd7;
                            i2c_state <= ST_ADDR_TX;
                        end
                    end
                end
                // -----------------------------------------------------------------
                // Transmit 7-bit address + R/W
                ST_ADDR_TX: begin
                    if (!scl_phase && scl_cnt == 16'd0) begin
                        // SCL low — set SDA
                        sda_out <= shift_reg[7];
                        sda_oen <= 1'b1;
                        scl_oen <= 1'b1; // hold SCL low
                    end else if (scl_phase && scl_cnt == 16'd0) begin
                        // SCL high — shift
                        if (bit_cnt == 4'd0) begin
                            // Last bit sent — prepare for ACK
                            scl_oen   <= 1'b1;
                            sda_oen   <= 1'b0; // release SDA for ACK
                            i2c_state <= ST_ADDR_ACK;
                        end else begin
                            shift_reg <= {shift_reg[6:0], 1'b0};
                            bit_cnt   <= bit_cnt - 1'b1;
                            scl_oen   <= 1'b0; // let SCL rise
                        end
                    end
                end
                // -----------------------------------------------------------------
                ST_ADDR_ACK: begin
                    if (!scl_phase && scl_cnt == 16'd0) begin
                        scl_oen <= 1'b1; // SCL low — sample SDA
                        if (!sda_stable) begin
                            ack_ok  <= 1'b1;
                            nack_flag <= 1'b0;
                            // Prepare data phase
                            if (do_read) begin
                                sda_oen   <= 1'b0;
                                shift_reg <= 8'd0;
                                bit_cnt   <= 4'd7;
                                i2c_state <= ST_DATA_RX;
                            end else begin
                                shift_reg <= wdata_reg;
                                bit_cnt   <= 4'd7;
                                i2c_state <= ST_DATA_TX;
                            end
                        end else begin
                            nack_flag <= 1'b1;
                            ack_ok    <= 1'b0;
                            i2c_state <= ST_STOP;
                        end
                    end
                end
                // -----------------------------------------------------------------
                ST_DATA_TX: begin
                    // Length fault check
                    if (byte_cnt == 8'd255) begin
                        len_fault_flag <= 1'b1;
                        i2c_state      <= ST_STOP;
                    end else if (!scl_phase && scl_cnt == 16'd0) begin
                        sda_out <= shift_reg[7];
                        sda_oen <= 1'b1;
                        scl_oen <= 1'b1;
                    end else if (scl_phase && scl_cnt == 16'd0) begin
                        if (bit_cnt == 4'd0) begin
                            scl_oen   <= 1'b1;
                            sda_oen   <= 1'b0;
                            byte_cnt  <= byte_cnt + 1'b1;
                            i2c_state <= ST_DATA_ACK;
                        end else begin
                            shift_reg <= {shift_reg[6:0], 1'b0};
                            bit_cnt   <= bit_cnt - 1'b1;
                            scl_oen   <= 1'b0;
                        end
                    end
                end
                // -----------------------------------------------------------------
                ST_DATA_ACK: begin
                    if (!scl_phase && scl_cnt == 16'd0) begin
                        scl_oen <= 1'b1;
                        if (!sda_stable) begin
                            // Got ACK — done for single-byte, issue STOP
                            i2c_state <= ST_STOP;
                        end else begin
                            nack_flag <= 1'b1;
                            i2c_state <= ST_STOP;
                        end
                    end
                end
                // -----------------------------------------------------------------
                ST_DATA_RX: begin
                    if (!scl_phase && scl_cnt == 16'd0) begin
                        scl_oen <= 1'b1;
                    end else if (scl_phase && scl_cnt == prescale_reg >> 1) begin
                        // Sample at SCL mid-high
                        shift_reg <= {shift_reg[6:0], sda_stable};
                        if (bit_cnt == 4'd0) begin
                            rdata_reg <= {shift_reg[6:0], sda_stable};
                            byte_cnt  <= byte_cnt + 1'b1;
                            i2c_state <= ST_RX_ACK;
                        end else begin
                            bit_cnt <= bit_cnt - 1'b1;
                        end
                    end
                end
                // -----------------------------------------------------------------
                ST_RX_ACK: begin
                    // Master sends NACK (release SDA = 1) then STOP
                    if (!scl_phase && scl_cnt == 16'd0) begin
                        sda_out   <= 1'b1;
                        sda_oen   <= 1'b1; // NACK
                        scl_oen   <= 1'b1;
                    end else if (scl_phase && scl_cnt == 16'd0) begin
                        scl_oen   <= 1'b0;
                        i2c_state <= ST_STOP;
                    end
                end
                // -----------------------------------------------------------------
                ST_STOP: begin
                    if (!scl_phase && scl_cnt == 16'd0) begin
                        sda_out <= 1'b0;
                        sda_oen <= 1'b1;
                        scl_oen <= 1'b0; // SCL high
                    end else if (scl_phase && scl_cnt == 16'd0) begin
                        sda_out   <= 1'b1; // SDA rises while SCL high = STOP
                        sda_oen   <= 1'b0;
                        i2c_state <= ST_DONE;
                    end
                end
                // -----------------------------------------------------------------
                ST_RECOVERY: begin
                    // Drive 9 SCL pulses to unstick a held-low SDA
                    if (!scl_phase && scl_cnt == 16'd0) begin
                        scl_oen <= 1'b1; // drive SCL low
                    end else if (scl_phase && scl_cnt == 16'd0) begin
                        scl_oen <= 1'b0; // release SCL high
                        rcv_pulse_cnt <= rcv_pulse_cnt + 1'b1;
                        if (rcv_pulse_cnt == 4'd8) begin
                            sda_oen   <= 1'b0;
                            i2c_state <= ST_IDLE;
                            busy      <= 1'b0;
                        end
                    end
                end
                // -----------------------------------------------------------------
                ST_DONE: begin
                    done_flag <= 1'b1;
                    busy      <= 1'b0;
                    i2c_state <= ST_IDLE;
                end
                default: i2c_state <= ST_IDLE;
            endcase

            // Clear START bit once accepted
            if (i2c_state != ST_IDLE)
                ctrl_reg[0] <= 1'b0;
        end
    end

    // =========================================================================
    // AXI-Lite Write Channel
    // =========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_axil_awready <= 1'b0;
            s_axil_wready  <= 1'b0;
            s_axil_bvalid  <= 1'b0;
            s_axil_bresp   <= 2'b00;
            aw_active      <= 1'b0;
            aw_addr_lat    <= 6'd0;
            ctrl_reg       <= 4'd0;
            addr_reg       <= 7'd0;
            wdata_reg      <= 8'd0;
            prescale_reg   <= PRESCALE_DEF[15:0];
            wl_en          <= 1'b0;
            wl_idx         <= 2'd0;
            whitelist[0]   <= 7'd0;
            whitelist[1]   <= 7'd0;
            whitelist[2]   <= 7'd0;
            whitelist[3]   <= 7'd0;
        end else begin
            s_axil_awready <= 1'b0;
            s_axil_wready  <= 1'b0;

            if (s_axil_awvalid && !aw_active) begin
                s_axil_awready <= 1'b1;
                aw_addr_lat    <= s_axil_awaddr[7:2];
                aw_active      <= 1'b1;
            end

            if (s_axil_wvalid && aw_active && !s_axil_bvalid) begin
                s_axil_wready <= 1'b1;
                aw_active     <= 1'b0;

                case (aw_addr_lat)
                    ADDR_CTRL[5:0]:      ctrl_reg     <= s_axil_wdata[3:0];
                    ADDR_ADDR[5:0]:      addr_reg     <= s_axil_wdata[6:0];
                    ADDR_WDATA[5:0]:     wdata_reg    <= s_axil_wdata[7:0];
                    ADDR_PRESCALE[5:0]:  prescale_reg <= s_axil_wdata[15:0];
                    ADDR_WL_CTRL[5:0]: begin
                        wl_idx <= s_axil_wdata[1:0];
                        wl_en  <= s_axil_wdata[8];
                    end
                    ADDR_WL_ADDR[5:0]:
                        whitelist[wl_idx] <= s_axil_wdata[6:0];
                    ADDR_ALERT_CLR[5:0]: begin
                        bus_stuck_flag <= 1'b0;
                        len_fault_flag <= 1'b0;
                        blocked_flag   <= 1'b0;
                    end
                    default: ;
                endcase

                s_axil_bvalid <= 1'b1;
                s_axil_bresp  <= 2'b00;
            end

            if (s_axil_bvalid && s_axil_bready)
                s_axil_bvalid <= 1'b0;
        end
    end

    // =========================================================================
    // AXI-Lite Read Channel
    // =========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_axil_arready <= 1'b0;
            s_axil_rvalid  <= 1'b0;
            s_axil_rdata   <= 32'd0;
            s_axil_rresp   <= 2'b00;
        end else begin
            s_axil_arready <= 1'b0;

            if (s_axil_arvalid && !s_axil_rvalid) begin
                s_axil_arready <= 1'b1;
                s_axil_rvalid  <= 1'b1;
                s_axil_rresp   <= 2'b00;

                case (s_axil_araddr[7:2])
                    ADDR_CTRL[5:0]:     s_axil_rdata <= {28'd0, ctrl_reg};
                    ADDR_ADDR[5:0]:     s_axil_rdata <= {25'd0, addr_reg};
                    ADDR_WDATA[5:0]:    s_axil_rdata <= {24'd0, wdata_reg};
                    ADDR_RDATA[5:0]:    s_axil_rdata <= {24'd0, rdata_reg};
                    ADDR_STATUS[5:0]:   s_axil_rdata <= {25'd0,
                                            len_fault_flag,  // [6]
                                            bus_stuck_flag,  // [5]
                                            blocked_flag,    // [4]
                                            nack_flag,       // [3]
                                            ack_ok,          // [2]
                                            done_flag,       // [1]
                                            busy             // [0]
                                        };
                    ADDR_PRESCALE[5:0]: s_axil_rdata <= {16'd0, prescale_reg};
                    ADDR_WL_CTRL[5:0]:  s_axil_rdata <= {23'd0, wl_en, 6'd0, wl_idx};
                    ADDR_WL_ADDR[5:0]:  s_axil_rdata <= {25'd0, whitelist[wl_idx]};
                    default:            s_axil_rdata <= 32'hDEAD_BEEF;
                endcase
            end

            if (s_axil_rvalid && s_axil_rready)
                s_axil_rvalid <= 1'b0;
        end
    end

    // =========================================================================
    // IRQ
    // =========================================================================
    assign irq = done_flag | nack_flag | bus_stuck_flag | len_fault_flag | blocked_flag;

endmodule
