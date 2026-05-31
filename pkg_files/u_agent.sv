class u_agent_base extends uvm_agent;

    `uvm_component_utils(u_agent_base)

    uvm_sequencer #(u_a_master_item) u_a_m_sequencer;
    uvm_sequencer #(u_b_master_item) u_b_m_sequencer;
    uvm_sequencer #(u_slave_item)    u_s_sequencer;
    u_a_master_driver_base    u_a_m_driver;
    u_b_master_driver_base    u_b_m_driver;
    u_slave_driver_base       u_s_driver;
    u_monitor_base            u_monitor;
    u_scoreboard_base         u_scoreboard;


    function new (string name = "u_agent_base", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        u_monitor = u_monitor_base::type_id::create("u_monitor", this);

        if (is_active == UVM_ACTIVE) begin
            u_a_m_driver   = u_a_master_driver_base::type_id::create("u_a_m_driver", this);
            u_b_m_driver   = u_b_master_driver_base::type_id::create("u_b_m_driver", this);
            u_s_driver     = u_slave_driver_base::type_id::create("u_s_driver", this);
            u_scoreboard   = u_scoreboard_base::type_id::create("u_scoreboard", this);
            u_a_m_sequencer  = new("u_a_m_sequencer", this);
            u_b_m_sequencer  = new("u_b_m_sequencer", this);
            u_s_sequencer    = new("u_s_sequencer", this);
        end


    endfunction

    virtual function void connect_phase (uvm_phase phase);
        if (is_active == UVM_ACTIVE) begin
            u_a_m_driver.seq_item_port.connect(u_a_m_sequencer.seq_item_export);
            u_b_m_driver.seq_item_port.connect(u_b_m_sequencer.seq_item_export);
            u_s_driver.seq_item_port.connect(u_s_sequencer.seq_item_export);
            u_monitor.mon_a_m_ap.connect(u_scoreboard.a_m_fifo.analysis_export);
            u_monitor.mon_b_m_ap.connect(u_scoreboard.b_m_fifo.analysis_export);
            u_monitor.mon_s_ap.connect(u_scoreboard.s_fifo.analysis_export);
        end
    endfunction

endclass: u_agent_base
