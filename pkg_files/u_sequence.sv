class u_a_m_sequence extends uvm_sequence;
     `uvm_object_utils(u_a_m_sequence)

     virtual task body();

         u_a_master_item m_item = u_a_master_item::type_id::create("m_item");

         u_seq_config u_seq_cfg;
         
         u_test_config u_test_cfg;

         if (!uvm_config_db # (u_test_config)::get(null, get_full_name(), "u_test_cfg", u_test_cfg)) begin
            `uvm_fatal("NOCFG", {"can't get config" });
        end

         if (!uvm_config_db # (u_seq_config)::get(null, get_full_name(), "u_seq_cfg", u_seq_cfg)) begin
            `uvm_fatal("NOCFG", {"can't get config" });
         end
 
         forever begin
            
            m_item.tvalid_one_freq  = u_seq_cfg.a_m_tvalid_one_freq;
            m_item.tvalid_zero_freq = u_seq_cfg.a_m_tvalid_zero_freq;

            repeat(u_test_cfg.cycle_time) begin
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


      virtual task body();

         u_b_master_item m_item = u_b_master_item::type_id::create("m_item");

         u_seq_config u_seq_cfg;

         u_test_config u_test_cfg;

         if (!uvm_config_db # (u_test_config)::get(null, get_full_name(), "u_test_cfg", u_test_cfg)) begin
            `uvm_fatal("NOCFG", {"can't get config" });
         end

         if (!uvm_config_db # (u_seq_config)::get(null, get_full_name(), "u_seq_cfg", u_seq_cfg)) begin
            `uvm_fatal("NOCFG", {"can't get config" });
         end
 
         repeat(u_test_cfg.n_cycles) begin

            m_item.tvalid_one_freq  = u_seq_cfg.b_m_tvalid_one_freq;
            m_item.tvalid_zero_freq = u_seq_cfg.b_m_tvalid_zero_freq;

            repeat(u_test_cfg.cycle_time) begin
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

         u_slave_item s_item = u_slave_item::type_id::create("s_item");

         u_seq_config u_seq_cfg;

         u_test_config u_test_cfg;

         if (!uvm_config_db # (u_test_config)::get(null, get_full_name(), "u_test_cfg", u_test_cfg)) begin
            `uvm_fatal("NOCFG", {"can't get config" });
         end

         if (!uvm_config_db # (u_seq_config)::get(null, get_full_name(), "u_seq_cfg", u_seq_cfg)) begin
            `uvm_fatal("NOCFG", {"can't get config" });
         end
 
         forever begin

            s_item.tready_one_freq  = u_seq_cfg.s_tready_one_freq;
            s_item.tready_zero_freq = u_seq_cfg.s_tready_zero_freq;

            repeat(u_test_cfg.cycle_time) begin
               start_item(s_item);
               if (!s_item.randomize()) begin
                  `uvm_error("body", "randomization failed")
               end     
               finish_item(s_item);
            end
         end

     endtask
endclass