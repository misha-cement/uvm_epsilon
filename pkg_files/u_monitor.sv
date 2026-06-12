class u_monitor_base extends uvm_monitor;

    `uvm_component_utils(u_monitor_base)

    virtual m_intf m_vif;
    virtual s_intf s_vif;

    u_data_item a_m_data_item;
    u_data_item b_m_data_item;
    u_data_item s_data_item;



    uvm_analysis_port #(u_data_item) mon_a_m_ap;
    uvm_analysis_port #(u_data_item) mon_b_m_ap;
    uvm_analysis_port #(u_data_item) mon_s_ap;

    function new(string name="u_monitor_base", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        if      (!uvm_config_db#(virtual m_intf)::get(this, "", "vif", m_vif)) begin
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name, ".vif" });
        end
        else if (!uvm_config_db#(virtual s_intf)::get(this, "", "vif", s_vif)) begin
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name, ".vif" });
        end
        mon_a_m_ap = new("mon_a_m_ap", this);
        mon_b_m_ap = new("mon_b_m_ap", this);
        mon_s_ap = new("mon_s_ap", this);
    endfunction

    virtual function void connect_phase (uvm_phase phase);
    endfunction


    virtual task run_phase (uvm_phase phase);
        forever begin
           wait(~m_vif.aresetn);
           fork
               a_master_monitor();
               b_master_monitor();
               slave_monitor();
           join_none
           wait(m_vif.aresetn);
           disable fork;
        end
    endtask


    virtual task a_master_monitor();
        int cnt = 0;
        forever begin
            a_m_data_item = new();
            @(posedge m_vif.aclk);
            if (m_vif.a_m_tready && m_vif.a_m_tvalid) begin
                a_m_data_item.data = m_vif.a_m_tdata;
                cnt++;
                mon_a_m_ap.write(a_m_data_item);
            end
        end
    endtask

    virtual task b_master_monitor();
        int cnt = 0;
        forever begin
            b_m_data_item = new();
            @(posedge m_vif.aclk);
            if (m_vif.b_m_tready && m_vif.b_m_tvalid) begin
                b_m_data_item.data = m_vif.b_m_tdata;
                cnt++;
                mon_b_m_ap.write(b_m_data_item);
            end
        end
    endtask


    virtual task slave_monitor();
        forever begin
            s_data_item = new();
            @(posedge s_vif.aclk);
            if (s_vif.s_tready && s_vif.s_tvalid) begin
                s_data_item.data = s_vif.s_tdata;
                mon_s_ap.write(s_data_item);
            end
        end
    endtask

endclass