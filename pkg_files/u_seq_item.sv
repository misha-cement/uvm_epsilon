class u_a_master_item extends uvm_sequence_item;

    `uvm_object_utils(u_a_master_item)

    rand bit   tvalid;
    rand bit   [15:0] tdata;


    function new (string name = "u_a_master_item");
        super.new(name);
    endfunction

    constraint m_a_tvalid_freq {tvalid dist {1 := 1, 0 := 7};}

endclass: u_a_master_item


class u_b_master_item extends uvm_sequence_item;

    `uvm_object_utils(u_b_master_item)

    rand bit   tvalid;
    rand bit   [15:0] tdata;


    function new (string name = "u_a_master_item");
        super.new(name);
    endfunction

    constraint m_b_tvalid_freq {tvalid dist {1 := 3, 0 := 1};}

endclass: u_b_master_item


class u_slave_item extends uvm_sequence_item;

    `uvm_object_utils(u_slave_item)

    rand bit   tready;

    function new (string name = "u_slave_item");
        super.new(name);
    endfunction

    constraint s_tready_freq {tready dist {1 := 1, 0 := 1};}

endclass: u_slave_item



class u_data_item extends uvm_sequence_item;

    `uvm_object_utils(u_data_item)

    bit [15:0] tdata;

    function new (string name = "u_data_item");
        super.new(name);
    endfunction

endclass: u_data_item


