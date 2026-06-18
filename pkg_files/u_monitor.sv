class u_monitor_base extends uvm_monitor;

    `uvm_component_utils(u_monitor_base)

    virtual a_m_intf a_m_vif;
    virtual b_m_intf b_m_vif;
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
        if      (!uvm_config_db#(virtual a_m_intf)::get(this, "", "vif", a_m_vif)) begin
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name, ".vif" });
        end
        else if (!uvm_config_db#(virtual b_m_intf)::get(this, "", "vif", b_m_vif)) begin
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
           wait(~a_m_vif.aresetn);
           fork
               a_master_monitor();
               b_master_monitor();
               slave_monitor();
           join_none
           wait(a_m_vif.aresetn);
           disable fork;
        end
    endtask


    virtual task a_master_monitor();
        int cnt = 0;
        forever begin
            a_m_data_item = new();
            @(posedge a_m_vif.aclk);
            if (a_m_vif.tready && a_m_vif.tvalid) begin
                a_m_data_item.tdata = a_m_vif.tdata;
                cnt++;
                mon_a_m_ap.write(a_m_data_item);
            end
        end
    endtask

    virtual task b_master_monitor();
        int cnt = 0;
        forever begin
            b_m_data_item = new();
            @(posedge b_m_vif.aclk);
            if (b_m_vif.tready && b_m_vif.tvalid) begin
                b_m_data_item.tdata = b_m_vif.tdata;
                cnt++;
                mon_b_m_ap.write(b_m_data_item);
            end
        end
    endtask


    virtual task slave_monitor();
        forever begin
            s_data_item = new();
            @(posedge s_vif.aclk);
            if (s_vif.tready && s_vif.tvalid) begin
                s_data_item.tdata = s_vif.tdata;
                mon_s_ap.write(s_data_item);
            end
        end
    endtask

endclass