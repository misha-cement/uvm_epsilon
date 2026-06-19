class u_a_m_sequence extends uvm_sequence;
     `uvm_object_utils(u_a_m_sequence)

     int n_cycles   = 16;
     int cycle_time = 16;

     virtual task body();

         u_seq_config cfg = u_seq_config::type_id::create("cfg");

         u_a_master_item m_item = u_a_master_item::type_id::create("m_item");
 
         repeat(n_cycles) begin

            if (!cfg.randomize()) begin
                `uvm_error("body", "randomization failed")
            end
            
            m_item.tvalid_one_freq  = cfg.a_m_tvalid_one_freq;
            m_item.tvalid_zero_freq = cfg.a_m_tvalid_zero_freq;

            repeat(cycle_time) begin
               start_item(m_item);
               if (!m_item.randomize()) begin
                  `uvm_error("body", "randomization failed")
               end     
               finish_item(m_item);
            end
         end
     endtask
endclass: u_a_m_sequence




class u_b_m_sequence extends uvm_sequence;
     `uvm_object_utils(u_b_m_sequence)

     int n_cycles   = 16;
     int cycle_time = 16;

     virtual task body();

         u_seq_config cfg = u_seq_config::type_id::create("cfg");

         u_b_master_item m_item = u_b_master_item::type_id::create("m_item");
 
         repeat(n_cycles) begin

            if (!cfg.randomize()) begin
                `uvm_error("body", "randomization failed")
            end

            m_item.tvalid_one_freq  = cfg.b_m_tvalid_one_freq;
            m_item.tvalid_zero_freq = cfg.b_m_tvalid_zero_freq;

            repeat(cycle_time) begin
               start_item(m_item);
               if (!m_item.randomize()) begin
                  `uvm_error("body", "randomization failed")
               end     
               finish_item(m_item);
            end
         end
     endtask
endclass: u_b_m_sequence




class u_s_sequence extends uvm_sequence;
     `uvm_object_utils(u_s_sequence)

     int n_cycles   = 16;
     int cycle_time = 16;

     virtual task body();

         u_seq_config cfg = u_seq_config::type_id::create("cfg");

         u_slave_item s_item = u_slave_item::type_id::create("s_item");
 
         repeat(n_cycles) begin

            if (!cfg.randomize()) begin
                `uvm_error("body", "randomization failed")
            end

            s_item.tready_one_freq  = cfg.s_tready_one_freq;
            s_item.tready_zero_freq = cfg.s_tready_zero_freq;

            repeat(cycle_time) begin
               start_item(s_item);
               if (!s_item.randomize()) begin
                  `uvm_error("body", "randomization failed")
               end     
               finish_item(s_item);
            end
         end

     endtask
endclass