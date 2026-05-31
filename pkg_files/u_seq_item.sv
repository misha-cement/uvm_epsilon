class u_a_master_item extends uvm_sequence_item;

    `uvm_object_utils(u_a_master_item)

    rand bit   a_m_tvalid;
    rand bit   [15:0] a_m_tdata;


    function new (string name = "u_a_master_item");
        super.new(name);
    endfunction

    constraint m_a_tvalid_freq {a_m_tvalid dist {1 := 1, 0 := 7};}

endclass: u_a_master_item


class u_b_master_item extends uvm_sequence_item;

    `uvm_object_utils(u_b_master_item)

    rand bit   b_m_tvalid;
    rand bit   [15:0] b_m_tdata;


    function new (string name = "u_a_master_item");
        super.new(name);
    endfunction

    constraint m_b_tvalid_freq {b_m_tvalid dist {1 := 3, 0 := 1};}

endclass: u_b_master_item


class u_slave_item extends uvm_sequence_item;

    `uvm_object_utils(u_slave_item)

    rand bit   s_tready;

    function new (string name = "u_slave_item");
        super.new(name);
    endfunction

    constraint s_tready_freq {s_tready dist {1 := 1, 0 := 1};}

endclass: u_slave_item



class u_data_item extends uvm_sequence_item;

    `uvm_object_utils(u_data_item)

    bit [15:0] data;

    function new (string name = "u_data_item");
        super.new(name);
    endfunction

endclass: u_data_item


