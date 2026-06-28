class u_coverage extends uvm_subscriber #(u_data_item);

    `uvm_component_utils(u_coverage)

    u_data_item item;

    covergroup covgroup;
        a_m: coverpoint item.a_m_tdata {
            bins a1 [16] = {[0: $]};
        }
        b_m: coverpoint item.b_m_tdata {
            bins b1 [16] = {[0: $]};
        }
        m_cross: cross a_m, b_m {}

    endgroup

    function new (string name = "u_agent_base", uvm_component parent = null);
        super.new(name, parent);
        covgroup = new();
    endfunction

    virtual function void write(u_data_item t);
        item = t;
        covgroup.sample();
    endfunction

endclass: u_coverage