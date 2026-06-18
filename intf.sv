interface a_m_intf (input logic aclk, input logic aresetn);
    logic  tvalid;
    logic  tready;
    logic  [15:0] tdata;
endinterface

interface b_m_intf (input logic aclk, input logic aresetn);
    logic  tvalid;
    logic  tready;
    logic  [15:0] tdata;
endinterface


interface s_intf (input logic aclk, input logic aresetn);
    logic  tvalid; 
    logic  tready;
    logic  [15:0] tdata;
endinterface