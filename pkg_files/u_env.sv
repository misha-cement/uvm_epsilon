class u_env_base extends uvm_env;
    
    `uvm_component_utils(u_env_base)

    u_agent_base u_agent;
    u_scoreboard_base u_scoreboard;

    function new (string name = "u_env_base", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        u_agent = u_agent_base::type_id::create("u_agent", this);
        u_scoreboard = u_scoreboard_base::type_id::create("u_scoreboard", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        u_agent.agent_analysis_export.connect(u_scoreboard.u_scr_a_imp);
    endfunction

endclass