
`include "uvm_macros.svh"
module testbench;
    import uvm_pkg::*;
    import test_pkg::*;

    logic aclk, aresetn;

    localparam width = 16;
    localparam depth = 16;

    a_m_intf a_m_if (aclk, aresetn);
    b_m_intf b_m_if (aclk, aresetn);
    s_intf s_if (aclk, aresetn);

    a_plus_b_on_fifo  #(.width (width),
                        .depth (depth))
                       u_dut
                      (.aclk         (aclk),
                       .aresetn      (aresetn),
                       .a_m_tvalid   (a_m_if.tvalid),
                       .b_m_tvalid   (b_m_if.tvalid),
                       .a_m_tready   (a_m_if.tready),
                       .b_m_tready   (b_m_if.tready),
                       .s_tvalid     (s_if.tvalid),
                       .s_tready     (s_if.tready),
                       .a_m_tdata    (a_m_if.tdata),
                       .b_m_tdata    (b_m_if.tdata),
                       .s_tdata      (s_if.tdata));


    initial begin
        aclk = 0;
        forever begin
            #5; aclk = ~aclk;
        end
    end

    initial begin
        repeat(4) @(posedge aclk);
        aresetn = 1; 
        @(posedge aclk);
        aresetn <= 0;
        repeat(1024) @(posedge aclk);
        aresetn = 1;
        @(posedge aclk);
        aresetn <= 0;
    end

    initial begin
        repeat(1000000) @(posedge aclk);
        $display("Timeout");
        $stop();
    end

        
    initial begin
        uvm_config_db #(virtual a_m_intf)::set (null, "*", "vif", a_m_if);
        uvm_config_db #(virtual b_m_intf)::set (null, "*", "vif", b_m_if);
        uvm_config_db #(virtual s_intf)::set (null, "*", "vif", s_if);
        run_test("u_test_base");
    end


endmodule