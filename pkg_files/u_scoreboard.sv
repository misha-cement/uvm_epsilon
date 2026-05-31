class u_scoreboard_base extends uvm_scoreboard;
    
    `uvm_component_utils(u_scoreboard_base)

    virtual s_intf vif;

    uvm_tlm_analysis_fifo #(u_data_item) a_m_fifo;
    uvm_tlm_analysis_fifo #(u_data_item) b_m_fifo;
    uvm_tlm_analysis_fifo #(u_data_item) s_fifo;
    
    u_data_item a_m_data_item;
    u_data_item b_m_data_item;
    u_data_item s_data_item;


    function new(string name="u_scoreboard_base", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual s_intf)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name, ".vif" });
        end
        a_m_fifo = new("a_m_fifo", this);
        b_m_fifo = new("b_m_fifo", this);
        s_fifo   = new("s_fifo", this);
    endfunction
        

    virtual task run_phase(uvm_phase phase);
        bit [15:0] exp_out;
        bit [15:0] act_out;
        forever begin
            wait(~vif.rst);
            fork
                compare(exp_out, act_out);
            join_none
            wait(vif.rst);
            disable fork;
            while(!a_m_fifo.is_empty()) a_m_fifo.get(a_m_data_item);
            while(!b_m_fifo.is_empty()) b_m_fifo.get(b_m_data_item);
            while(!s_fifo.is_empty())   s_fifo.get(s_data_item);
        end
    endtask


    virtual task compare (bit[15:0] exp_out, bit[15:0] act_out);
        forever begin
            @(posedge vif.clk);
            if (vif.s_tvalid && vif.s_tready) begin
                a_m_fifo.get(a_m_data_item);
                b_m_fifo.get(b_m_data_item);
                s_fifo.get(s_data_item);
                exp_out = a_m_data_item.data + b_m_data_item.data;
                act_out = s_data_item.data;
                if (act_out != exp_out) begin
                    `uvm_info("ERROR", $sformatf("Error, expected: 0x%0h, actual: 0x%0h", exp_out, act_out), UVM_LOW)
                end
            end
        end
        
    endtask


    virtual function void check_phase (uvm_phase phase);

    endfunction

endclass