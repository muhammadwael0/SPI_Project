vlib work
vlog SPI.v SPI_tb.v
vsim -voptargs=+acc work.SPI_Wrapper_tb
add wave -position insertpoint \
sim:/SPI_Wrapper_tb/clk \
sim:/SPI_Wrapper_tb/rst_n \
sim:/SPI_Wrapper_tb/SS_n \
sim:/SPI_Wrapper_tb/dut/SS1/cs \
sim:/SPI_Wrapper_tb/dut/SS1/ns \
sim:/SPI_Wrapper_tb/dut/SS1/counter_1 \
sim:/SPI_Wrapper_tb/dut/SS1/counter_2 \
sim:/SPI_Wrapper_tb/dut/SS1/ADD_SAVED \
sim:/SPI_Wrapper_tb/MOSI_tb \
sim:/SPI_Wrapper_tb/MISO_tb \
sim:/SPI_Wrapper_tb/address_tb \
sim:/SPI_Wrapper_tb/dataWrite_tb \
sim:/SPI_Wrapper_tb/dataRead_tb \
sim:/SPI_Wrapper_tb/dut/SS1/tx_data \
sim:/SPI_Wrapper_tb/dut/SS1/tx_valid \
sim:/SPI_Wrapper_tb/dut/SRAM/D_out \
sim:/SPI_Wrapper_tb/dut/SRAM/R_address \
sim:/SPI_Wrapper_tb/dut/SS1/rx_data \
sim:/SPI_Wrapper_tb/dut/SS1/rx_valid \
sim:/SPI_Wrapper_tb/dut/SRAM/D_in \
sim:/SPI_Wrapper_tb/dut/SRAM/W_address \
sim:/SPI_Wrapper_tb/dut/SRAM/SP_RAM
run -all
#quit