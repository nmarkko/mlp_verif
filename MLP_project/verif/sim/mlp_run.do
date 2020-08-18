################################################################################
#    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
#    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
#    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
#
#    FILE            run
#
#    DESCRIPTION
#
################################################################################

# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

# compile DUT
vcom ../../dut/MLP_SRC/bram.vhd
vcom ../../dut/MLP_SRC/mem_subsystem.vhd
vcom ../../dut/MLP_SRC/mlp.vhd
vcom ../../dut/MLP_SRC/axi_mlp_v1_0_S00_AXI.vhd
vcom ../../dut/MLP_SRC/axi_mlp_v1_0_S00_AXIS.vhd
vcom ../../dut/MLP_SRC/axi_mlp_v1_0.vhd



# compile testbench
vlog +cover -sv \
    +incdir+$env(UVM_HOME) \
    +incdir+../sv \
    ../sv/verif_pkg.sv \
    ../sv/verif_top.sv
vopt verif_top -o dut_optimized +cover 

# run simulation

vsim -coverage dut_optimized  -novopt +UVM_TIMEOUT=200 +UVM_TESTNAME=test_mlp_simple +UVM_VERBOSITY=UVM_HIGH -sv_seed random 

