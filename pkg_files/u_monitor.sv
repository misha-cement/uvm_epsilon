class u_monitor_base extends uvm_monitor;

    `uvm_component_utils(u_monitor_base)

    virtual a_m_intf a_m_vif;
    virtual b_m_intf b_m_vif;
    virtual s_intf s_vif;

    u_data_item data_item;

    typedef bit [15:0] tdata;

    //the purpose of these mailboxes is to put tdata from each interface,
    // get each tdata when s_vif.tvalid && s_vif.tready happens and put
    // all of them to one packet
    mailbox #(tdata) a_m_mbx;
    mailbox #(tdata) b_m_mbx;
    mailbox #(tdata) s_mbx  ;

    uvm_analysis_port #(u_data_item) mon_ap;

    function new(string name="u_monitor_base", uvm_component parent = null);
        super.new(name, parent);
        a_m_mbx = new();
        b_m_mbx = new();
        s_mbx   = new();
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
        mon_ap = new("mon_ap", this);
    endfunction

    virtual function void connect_phase (uvm_phase phase);
    endfunction


    virtual task run_phase (uvm_phase phase);
        tdata p;
        forever begin
           wait(~a_m_vif.aresetn);
           fork
               a_master_monitor();
               b_master_monitor();
               slave_monitor();
               put_to_analysis_port();
           join_none
           wait(a_m_vif.aresetn);
           disable fork;
           while(a_m_mbx.try_get(p));
           while(b_m_mbx.try_get(p));
           while(s_mbx.try_get(p));
        end
    endtask


    virtual task a_master_monitor();
        tdata p;
        forever begin
            @(posedge a_m_vif.aclk);
            if (a_m_vif.tready && a_m_vif.tvalid) begin
                p = a_m_vif.tdata;
                a_m_mbx.put(p);
            end
        end
    endtask

    virtual task b_master_monitor();
        tdata p;
        forever begin
            @(posedge b_m_vif.aclk);
            if (b_m_vif.tready && b_m_vif.tvalid) begin
                p = b_m_vif.tdata;
                b_m_mbx.put(p);
            end
        end
    endtask


    virtual task slave_monitor();
        tdata p;
        forever begin
            @(posedge s_vif.aclk);
            if (s_vif.tready && s_vif.tvalid) begin
                p = s_vif.tdata;
                s_mbx.put(p);
            end
        end
    endtask

    virtual task put_to_analysis_port;
        tdata a_m_tdata;
        tdata b_m_tdata;
        tdata s_tdata;
        forever begin
            data_item = new();
            @(posedge s_vif.aclk);
            if (s_vif.tready && s_vif.tvalid) begin
                a_m_mbx.get(a_m_tdata);
                b_m_mbx.get(b_m_tdata);
                s_mbx.get(s_tdata);
                data_item.a_m_tdata = a_m_tdata;
                data_item.b_m_tdata = b_m_tdata;
                data_item.s_tdata   = s_tdata;
                mon_ap.write(data_item);
            end
        end
    endtask

endclass