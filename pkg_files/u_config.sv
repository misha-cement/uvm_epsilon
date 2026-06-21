class u_test_config extends uvm_object;

    `uvm_object_utils(u_test_config)

    int n_cycles;
    int cycle_time;

    function new (string name = "u_test_config");
        super.new(name);
    endfunction

endclass