module SPI_Wrapper_tb();
    localparam TESTS = 20;
    localparam MEM_DEPTH = 256;
    integer i;

    reg clk, rst_n;
    reg SS_n;
    reg MOSI_tb;
    wire MISO_tb;

    reg [7:0] address_tb;       // Address wrote in W_address reg
    reg [7:0] dataWrite_tb;     // Data wrote into memory
    reg [7:0] dataRead_tb;      // Data Read from memory

    // DUT Instantiation
    SPI_Wrapper dut (.clk(clk), .rst_n(rst_n), .SS_n(SS_n), .MOSI(MOSI_tb), .MISO(MISO_tb));

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        for (i = 0; i < MEM_DEPTH; i = i + 1)
            dut.SRAM.SP_RAM[i] = 0;
    end

    initial begin
        i = 0;
        address_tb = 0;
        dataWrite_tb = 0;
        dataRead_tb = 0;
        SS_n = 1;
        MOSI_tb = 0;
        rst_n = 0;
        @(negedge clk);
        rst_n = 1;

        repeat (TESTS) begin
            // Write Mode (Address)
            SS_n = 0;
            MOSI_tb = 1'b0;
            repeat(2) @(negedge clk);

            MOSI_tb = 1'b0;
            @(negedge clk);
            MOSI_tb = 1'b0;
            @(negedge clk);

            repeat(8) begin
                MOSI_tb = $random;
                address_tb = {address_tb[6:0], MOSI_tb};
                @(negedge clk);
            end

            SS_n = 1;
            @(negedge clk);
                    
            // Write Mode (Data)
            SS_n = 0;
            @(negedge clk);
            MOSI_tb = 1'b0;
            @(negedge clk);

            MOSI_tb = 1'b0;
            @(negedge clk);
            MOSI_tb = 1'b1;
            @(negedge clk);

            repeat(8) begin
                MOSI_tb = $random;
                dataWrite_tb = {dataWrite_tb[6:0], MOSI_tb};
                @(negedge clk);
            end

            SS_n = 1;
            @(negedge clk);

            // Read Mode (Adress)
            SS_n = 0;
            @(negedge clk);
            MOSI_tb = 1'b1;
            @(negedge clk);

            MOSI_tb = 1'b1;
            @(negedge clk);
            MOSI_tb = 1'b0;
            @(negedge clk);

            for (i = 7; i >= 0; i = i - 1) begin
                MOSI_tb = address_tb[i];
                @(negedge clk);
            end

            SS_n = 1;
            @(negedge clk);

            // Read Mode (Data)
            SS_n = 0;
            @(negedge clk);
            MOSI_tb = 1'b1;
            @(negedge clk);

            MOSI_tb = 1'b1;
            @(negedge clk);
            MOSI_tb = 1'b1;
            @(negedge clk);

            repeat(8) begin // wait for data to propagate through MISO
                MOSI_tb = $random; // Dummy bits
                @(negedge clk);
            end

            repeat(8) begin // wait for data to propagate through MISO
                dataRead_tb = {dataRead_tb[6:0], MISO_tb};
                @(negedge clk);
            end

            dataRead_tb = {dataRead_tb[6:0], MISO_tb};
            SS_n = 1;
            @(negedge clk);

            if (dataRead_tb !== dataWrite_tb) begin
                $display("[!] Error in SPI function\n");
                $stop;
            end
        end
        $display("[OK] Everything is good\n");
        $stop;
    end

endmodule