echo "Compiling..."
vlog a_plus_b_on_fifo.sv fifo_shift_register_pointer.sv  intf.sv test_pkg.sv testbench.sv
echo "Running..."
vsim testbench -do questa.tcl  -voptargs="+acc" +UVM_USE_OVM_RUN_SEMANTIC
