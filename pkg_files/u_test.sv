class u_test_base extends uvm_test;
    
    `uvm_component_utils(u_test_base)


    function new(string name = "u_test_base", uvm_component parent);
        super.new(name, parent);
    endfunction

    u_env_base u_env;
    u_a_m_sequence u_a_m_sqnce;
    u_b_m_sequence u_b_m_sqnce;
    u_s_sequence u_s_sqnce;

    virtual s_intf vif;

    u_test_config u_test_cfg = u_test_config::type_id::create("u_test_cfg", this);
    u_seq_config  u_seq_cfg  = u_seq_config::type_id::create("u_seq_cfg", this);

    virtual function void configure_cfg();
        u_test_cfg.n_cycles   = 16;
        u_test_cfg.cycle_time = 200;
        uvm_config_db # (u_test_config)::set(this, "*", "u_test_cfg", u_test_cfg);
        uvm_config_db # (u_seq_config)::set(this, "*", "u_seq_cfg", u_seq_cfg);
    endfunction


    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        u_env = u_env_base::type_id::create("u_env", this);
        u_a_m_sqnce = u_a_m_sequence::type_id::create("u_a_m_sqnce", this);
        u_b_m_sqnce = u_b_m_sequence::type_id::create("u_b_m_sqnce", this);
        u_s_sqnce   = u_s_sequence::type_id::create("u_s_sqnce", this);
        if (!uvm_config_db#(virtual s_intf)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name, ".vif" });
        end
        configure_cfg();
    endfunction


    virtual task run_phase(uvm_phase phase);
       super.run_phase(phase);
       phase.raise_objection(this);
       fork
           randomize_seq_cfg();
           u_a_m_sqnce.start(u_env.u_agent.u_a_m_sequencer);
           u_b_m_sqnce.start(u_env.u_agent.u_b_m_sequencer);
           u_s_sqnce.start(u_env.u_agent.u_s_sequencer);
       join_any
       $display("nitori");
       phase.drop_objection(this);
    endtask


    virtual task randomize_seq_cfg();
        repeat (u_test_cfg.n_cycles) begin
            if (!u_seq_cfg.randomize()) begin
                `uvm_error("body", "randomization failed")
            end
            repeat(u_test_cfg.cycle_time) @(posedge vif.aclk);
        end
    endtask

endclass