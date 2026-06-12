class u_a_master_driver_base extends uvm_driver#(u_a_master_item);

    `uvm_component_utils(u_a_master_driver_base)

    virtual m_intf vif;

    u_a_master_item m_item;

    function new(string name = "u_a_master_driver_base", uvm_component parent);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual m_intf)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name, ".vif" });
        end
    endfunction: build_phase


    virtual task run_phase (uvm_phase phase);
        forever begin
            wait(~vif.aresetn);
            fork
               forever begin
                   @(posedge vif.aclk);
                   // Holds m_tvalid and input data until m_tready = 1
                   if (vif.a_m_tvalid && ~vif.a_m_tready) begin
                   end
                   else begin
                      drive_item();
                   end
               end
            join_none
            wait(vif.aresetn);
            disable fork;
        end
    endtask: run_phase


    virtual task drive_item();
        seq_item_port.get_next_item(m_item);
        vif.a_m_tvalid <= m_item.a_m_tvalid;
        vif.a_m_tdata  <= m_item.a_m_tdata;
        seq_item_port.item_done();
    endtask

endclass: u_a_master_driver_base



class u_b_master_driver_base extends uvm_driver#(u_b_master_item);

    `uvm_component_utils(u_b_master_driver_base)

    virtual m_intf vif;

    u_b_master_item m_item;

    function new(string name = "u_b_master_driver_base", uvm_component parent);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual m_intf)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name, ".vif" });
        end
    endfunction: build_phase


    virtual task run_phase (uvm_phase phase);
        forever begin
            wait(~vif.aresetn);
            fork
               forever begin
                   @(posedge vif.aclk);
                   // Holds m_tvalid and input data until m_tready = 1
                   if (vif.b_m_tvalid && ~vif.b_m_tready) begin
                   end
                   else begin
                      drive_item();
                   end
               end
            join_none
            wait(vif.aresetn);
            disable fork;
        end
    endtask: run_phase


    virtual task drive_item();
        seq_item_port.get_next_item(m_item);
        vif.b_m_tvalid <= m_item.b_m_tvalid;
        vif.b_m_tdata  <= m_item.b_m_tdata;
        seq_item_port.item_done();
    endtask

endclass: u_b_master_driver_base





class u_slave_driver_base extends uvm_driver#(u_slave_item);

    `uvm_component_utils(u_slave_driver_base)

    virtual s_intf vif;

    u_slave_item s_item;

    function new(string name = "u_slave_driver_base", uvm_component parent);
        super.new(name, parent);
    endfunction
    

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual s_intf)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name, ".vif" });
        end
    endfunction: build_phase


    task run_phase (uvm_phase phase);
        forever begin
            wait(~vif.aresetn);
            fork
                forever begin
                    @(posedge vif.aclk);
                    seq_item_port.get_next_item(s_item);
                        vif.s_tready <= s_item.s_tready;
                    seq_item_port.item_done();
                end
            join_none
            wait(vif.aresetn);
            disable fork;
        end
    endtask: run_phase

endclass: u_slave_driver_base