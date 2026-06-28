class u_scoreboard_base extends uvm_scoreboard;
    
    `uvm_component_utils(u_scoreboard_base)

    uvm_analysis_imp #(u_data_item, u_scoreboard_base) u_scr_a_imp;

    function new(string name="u_scoreboard_base", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        u_scr_a_imp = new("u_scr_a_imp", this);
    endfunction

    virtual function void write(u_data_item item);
        bit [15:0] exp_out;
        bit [15:0] act_out;
        exp_out = item.a_m_tdata + item.b_m_tdata;
        act_out = item.s_tdata;
        if (act_out != exp_out) begin
            `uvm_info("ERROR", $sformatf("Error, expected: 0x%0h, actual: 0x%0h", exp_out, act_out), UVM_LOW)
        end
    endfunction


endclass