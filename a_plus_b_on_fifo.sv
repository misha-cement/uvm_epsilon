module a_plus_b_on_fifo
    #(parameter width,
      parameter depth)
      
     (input  logic  aclk, aresetn,

      input  logic  a_m_tvalid,
      input  logic  b_m_tvalid,
      output logic  a_m_tready,
      output logic  b_m_tready,

      output logic  s_tvalid, 
      input  logic  s_tready,

      input  logic  [width - 1:0] a_m_tdata, b_m_tdata,
      output logic  [width - 1:0] s_tdata);

     //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
     logic a_s_tvalid, b_s_tvalid;
     logic a_s_tready, b_s_tready;
     logic [width - 1:0] a_s_tdata, b_s_tdata;

     //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
     logic sum_m_tready;
     logic sum_m_tvalid;
     logic [width - 1:0] sum_m_tdata;

     //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
     fifo_shift_register_pointer #(.width (width),
                                   .depth (depth))
                                   fifo_a
                                  (.aclk      (aclk),
                                   .aresetn   (aresetn),
                                   .m_tvalid  (a_m_tvalid),
                                   .m_tready  (a_m_tready),
                                   .wr_data   (a_m_tdata),
                                   .s_tvalid  (a_s_tvalid),
                                   .s_tready  (a_s_tready),
                                   .rd_data   (a_s_tdata));

     fifo_shift_register_pointer #(.width (width),
                                   .depth (depth))
                                   fifo_b
                                  (.aclk      (aclk),
                                   .aresetn   (aresetn),
                                   .m_tvalid  (b_m_tvalid),
                                   .m_tready  (b_m_tready),
                                   .wr_data   (b_m_tdata),
                                   .s_tvalid  (b_s_tvalid),
                                   .s_tready  (b_s_tready),
                                   .rd_data   (b_s_tdata));
                                
     fifo_shift_register_pointer #(.width (width),
                                   .depth (depth))
                                   fifo_sum
                                  (.aclk      (aclk),
                                   .aresetn   (aresetn),
                                   .m_tvalid  (sum_m_tvalid),
                                   .m_tready  (sum_m_tready),
                                   .wr_data   (sum_m_tdata),
                                   .s_tvalid  (s_tvalid),
                                   .s_tready  (s_tready),
                                   .rd_data   (s_tdata));


    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // logic between fifos
    wire a_b_both_valid = a_s_tvalid && b_s_tvalid;

    assign a_s_tready = a_b_both_valid && sum_m_tready;

    assign b_s_tready = a_b_both_valid && sum_m_tready;

    assign sum_m_tvalid = a_b_both_valid;

    assign sum_m_tdata = a_s_tdata + b_s_tdata;


endmodule