module SPRAM #(parameter MEM_DEPTH = 256)(
    input clk, rst_n,
    input [9:0] D_in, // 10 Bits 2:8 , 2 -> for Control , 8 -> address Bus
    input rx_valid,
    output reg [7:0] D_out,
    output reg tx_valid
);
    reg [7:0] SP_RAM [MEM_DEPTH-1:0];

    reg [7:0] W_address;    // to Hold write address
    reg [7:0] R_address;    // to Hold read address

    always @(posedge clk) begin
        if (~rst_n) begin
            W_address <= 8'd0;
            R_address <= 8'd0;
            tx_valid <= 1'b0;
            D_out <= 8'd0;
        end
        else begin
            if (D_in[9:8] == 2'b00 && rx_valid) begin
                W_address <= D_in[7:0];
                tx_valid <= 1'b0;
            end
            else if (D_in[9:8] == 2'b01 && rx_valid) begin
                SP_RAM[W_address] <= D_in[7:0];
                tx_valid <= 1'b0;
            end
            else if (D_in[9:8] == 2'b10 && rx_valid) begin
                R_address <= D_in[7:0];
                tx_valid <= 1'b0;
            end
            else if (D_in[9:8] == 2'b11) begin
                D_out <= SP_RAM[R_address];
                tx_valid <= 1'b1;
            end
        end
    end    

endmodule



module SPI_Slave #(
    parameter IDLE = 0,
    parameter CHK_CMD = 1,
    parameter WRITE = 2,
    parameter READ_ADD = 3,
    parameter READ_DATA = 4,
    localparam CNT_SAT = 4'd10
)(
    input clk, rst_n,
    input SS_n,
    input [7:0] tx_data,
    input tx_valid,
    input MOSI,
    output reg MISO,
    output reg [9:0] rx_data,
    output reg rx_valid
);
    (* fsm_encoding="sequential" *) reg [2:0] cs, ns;
    reg ADD_SAVED;
    reg [3:0] counter_1; // 0 -> 10
    reg [2:0] counter_2; // 0 -> 7

    // state memory
    always @(posedge clk) begin
        if (~rst_n)
            cs <= IDLE;
        else
            cs <= ns;
    end

    // next state block
    always @(*) begin
        case (cs)
            IDLE: begin
                if (SS_n == 1'b0)
                    ns = CHK_CMD;
                else
                    ns = IDLE;
            end
            CHK_CMD: begin
                if (SS_n == 1'b0) begin
                    if (MOSI == 1'b1 && ADD_SAVED == 1'b0)
                        ns = READ_ADD;
                    else if (MOSI == 1'b1 && ADD_SAVED == 1'b1)
                        ns = READ_DATA;
                    else
                        ns = WRITE;
                end
                else
                    ns = IDLE;
            end
            WRITE: begin
                if (SS_n == 1'b1)
                    ns = IDLE;
                else
                    ns = WRITE;
            end
            READ_DATA: begin
                if (SS_n == 1'b1)
                    ns = IDLE;
                else
                    ns = READ_DATA;
            end
            READ_ADD: begin
                if (SS_n == 1'b1)
                    ns = IDLE;
                else
                    ns = READ_ADD;
            end
            default: ns = IDLE;
        endcase
    end

    // output block
    always @(posedge clk) begin
        if (~rst_n || counter_1 == CNT_SAT || cs == CHK_CMD || cs == IDLE)
            counter_1 <= 4'd0;
        else
            counter_1 <= counter_1 + 1'b1;
    end

    always @(posedge clk) begin
        if (~rst_n || cs != READ_DATA)
            counter_2 <= 3'd0;
        else if (tx_valid)
            counter_2 <= counter_2 + 1'b1;
    end

    always @(*) begin
        if (cs == READ_DATA && SS_n == 1'b0) begin
            case (counter_2)
                3'd0: MISO = tx_data[7];
                3'd1: MISO = tx_data[6];
                3'd2: MISO = tx_data[5];
                3'd3: MISO = tx_data[4];
                3'd4: MISO = tx_data[3];
                3'd5: MISO = tx_data[2];
                3'd6: MISO = tx_data[1];
                3'd7: MISO = tx_data[0];
            endcase
        end
        else
            MISO = 1'b0; // default value
    end

    // FF flag
    always @(posedge clk) begin
        if (~rst_n || cs == READ_DATA)
            ADD_SAVED <= 1'b0;
        else if (cs == READ_ADD)
            ADD_SAVED <= 1'b1;
    end

    always @(posedge clk) begin
        if (~rst_n || cs == CHK_CMD || cs == IDLE)
            rx_data <= 10'd0;
        else if ((cs == WRITE || cs == READ_DATA || cs == READ_ADD) && SS_n == 1'b0)
            rx_data <= {rx_data[8:0], MOSI};
    end

    always @(*) begin
        if (counter_1 == CNT_SAT && cs != IDLE && cs != CHK_CMD)
            rx_valid = 1'b1;
        else
            rx_valid = 1'b0;
    end

endmodule


module SPI_Wrapper (
    input clk, rst_n,
    input SS_n,
    input MOSI,
    output MISO
);
    wire rx_valid, tx_valid;
    wire [9:0] rx_data;
    wire [7:0] tx_data;

    SPI_Slave SS1 (.clk(clk), .rst_n(rst_n), .SS_n(SS_n), .MISO(MISO), .MOSI(MOSI), .tx_data(tx_data), .tx_valid(tx_valid), .rx_data(rx_data), .rx_valid(rx_valid));

    SPRAM SRAM (.clk(clk), .rst_n(rst_n), .D_in(rx_data), .rx_valid(rx_valid), .D_out(tx_data), .tx_valid(tx_valid));

endmodule