class u_env_base extends uvm_env;
    
    `uvm_component_utils(u_env_base)

    u_agent_base u_agent;

    function new (string name = "u_env_base", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        u_agent = u_agent_base::type_id::create("u_agent", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

endclass