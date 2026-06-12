interface m_intf (input logic aclk, input logic aresetn);
    logic  a_m_tvalid;
    logic  b_m_tvalid;
    logic  a_m_tready;
    logic  b_m_tready;
    logic  [15:0] a_m_tdata, b_m_tdata;
endinterface


interface s_intf (input logic aclk, input logic aresetn);
    logic  s_tvalid; 
    logic  s_tready;
    logic  [15:0] s_tdata;
endinterface