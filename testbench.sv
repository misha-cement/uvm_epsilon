
`include "uvm_macros.svh"
module testbench;
    import uvm_pkg::*;
    import test_pkg::*;

    logic aclk, aresetn;

    localparam width = 16;
    localparam depth = 16;

    m_intf m_if (aclk, aresetn);
    s_intf s_if (aclk, aresetn);

    a_plus_b_on_fifo  #(.width (width),
                        .depth (depth))
                       u_dut
                      (.aclk         (aclk),
                       .aresetn      (aresetn),
                       .a_m_tvalid   (m_if.a_m_tvalid),
                       .b_m_tvalid   (m_if.b_m_tvalid),
                       .a_m_tready   (m_if.a_m_tready),
                       .b_m_tready   (m_if.b_m_tready),
                       .s_tvalid     (s_if.s_tvalid),
                       .s_tready     (s_if.s_tready),
                       .a_m_tdata    (m_if.a_m_tdata),
                       .b_m_tdata    (m_if.b_m_tdata),
                       .s_tdata      (s_if.s_tdata));


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
        repeat(10000) @(posedge aclk);
        $display("Timeout");
        $stop();
    end

        
    initial begin
        uvm_config_db #(virtual m_intf)::set (null, "*", "vif", m_if);
        uvm_config_db #(virtual s_intf)::set (null, "*", "vif", s_if);
        run_test("u_test_base");
    end


endmodule