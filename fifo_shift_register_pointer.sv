module fifo_shift_register_pointer
    #(parameter width,
      parameter depth)

     (input  logic aclk, aresetn,

      input  logic m_tvalid,
      output logic m_tready,
      input  logic [width - 1:0] wr_data,

      output logic s_tvalid,
      input  logic s_tready,
      output logic [width - 1:0] rd_data);

    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    logic pop, push, full, empty;

    logic [depth - 1:0] wr_pnter, rd_pnter;
    logic [width - 1:0] data [depth - 1:0];

    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    always_ff @(posedge aclk)
       if (aresetn)
         begin
         wr_pnter[depth - 1]   <= '1;
         wr_pnter[depth - 2:0] <= '0;
         end
       else if (push)
         wr_pnter <= {wr_pnter[0], wr_pnter[depth - 1:1]};

    genvar i;
    generate
      for (i = 0; i < depth; i ++) begin: jj
        always_ff @(posedge aclk)
          if ((wr_pnter[i] && push))
            data[i] <= wr_data;
        end
    endgenerate



    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    always_ff @(posedge aclk)
       if (aresetn)
         begin
         rd_pnter[depth - 1]   <= '1;
         rd_pnter[depth - 2:0] <= '0;
         end
       else if (pop)
         rd_pnter <= {rd_pnter[0], rd_pnter[depth - 1:1]};

    always_comb begin
      rd_data = '0;
      for (int k = 0; k < depth; k++) begin
        rd_data |= (data[k] & {width{rd_pnter[k]}});
      end
    end

    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    logic last_action; //

    always_ff @(posedge aclk)
      if (aresetn)
        last_action <= '0;
      else if (pop && push)
        last_action <= last_action;
      else if (push)
        last_action <= '1;
      else if (pop)
        last_action <= '0;

    assign empty = (| (wr_pnter & rd_pnter)) && ~last_action;
    assign full  = (| (wr_pnter & rd_pnter)) &&  last_action;


    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    assign m_tready = ~ full;
    assign push  = m_tready && m_tvalid;

    assign s_tvalid = ~empty;
    assign pop = s_tvalid && s_tready;


endmodule