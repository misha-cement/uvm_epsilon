class u_test_base extends uvm_test;
    
    `uvm_component_utils(u_test_base)


    function new(string name = "u_test_base", uvm_component parent);
        super.new(name, parent);
    endfunction

    u_env_base u_env;
    u_a_m_sequence u_a_m_sqnce;
    u_b_m_sequence u_b_m_sqnce;
    u_s_sequence u_s_sqnce;

    int sim_time = 2048;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        u_env = u_env_base::type_id::create("u_env", this);
        u_a_m_sqnce = u_a_m_sequence::type_id::create("u_a_m_sqnce", this);
        u_b_m_sqnce = u_b_m_sequence::type_id::create("u_b_m_sqnce", this);
        u_s_sqnce   = u_s_sequence::type_id::create("u_s_sqnce", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
       u_a_m_sqnce.sim_time = this.sim_time;
       u_b_m_sqnce.sim_time = this.sim_time;
       u_s_sqnce.sim_time   = this.sim_time;
       super.run_phase(phase);

       phase.raise_objection(this);
       fork
           u_a_m_sqnce.start(u_env.u_agent.u_a_m_sequencer);
           u_b_m_sqnce.start(u_env.u_agent.u_b_m_sequencer);
           u_s_sqnce.start(u_env.u_agent.u_s_sequencer);
       join_any
       $display("nitori");
       phase.drop_objection(this);
    endtask

endclass