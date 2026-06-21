class u_a_m_sequence_base extends uvm_sequence;
     `uvm_object_utils(u_a_m_sequence_base)

     rand int tvalid_one_freq;
     rand int tvalid_zero_freq;

     constraint tvalid_one_freq_range  {tvalid_one_freq  inside {1, 4, 16};}
     constraint tvalid_zero_freq_range {tvalid_zero_freq inside {1, 4, 16};}

     
     function new(string name = "u_a_m_sequence_base");
        super.new(name);
     endfunction


     virtual task body();

         u_a_master_item m_item = u_a_master_item::type_id::create("m_item");
         u_test_config u_test_cfg;

         if (!uvm_config_db # (u_test_config)::get(null, get_full_name(), "u_test_cfg", u_test_cfg)) begin
            `uvm_fatal("NOCFG", {"can't get config" });
         end
  
         m_item.tvalid_one_freq  = this.tvalid_one_freq;
         m_item.tvalid_zero_freq = this.tvalid_zero_freq;
 
         repeat (u_test_cfg.cycle_time) begin
            
            start_item(m_item);
            if (!m_item.randomize()) begin
               `uvm_error("body", "randomization failed")
            end     
            finish_item(m_item);
         end
     endtask
endclass: u_a_m_sequence_base


class u_a_m_top_sequence extends uvm_sequence;

    `uvm_object_utils(u_a_m_top_sequence)

    function new(string name = "u_a_m_top_sequence");
        super.new(name);
    endfunction


    virtual task body();

        u_a_m_sequence_base u_seq_base = u_a_m_sequence_base::type_id::create("u_seq_base");

        u_test_config u_test_cfg;

         if (!uvm_config_db # (u_test_config)::get(null, get_full_name(), "u_test_cfg", u_test_cfg)) begin
            `uvm_fatal("NOCFG", {"can't get config" });

         end


         repeat (u_test_cfg.n_cycles) begin
            if (!u_seq_base.randomize()) begin
               `uvm_error("body", "randomization failed")
            end
            u_seq_base.start(m_sequencer);
         end
        

    endtask

endclass: u_a_m_top_sequence


class u_b_m_sequence_base extends u_a_m_sequence_base;
     `uvm_object_utils(u_b_m_sequence_base)

     function new(string name = "u_b_m_sequence_base");
        super.new(name);
     endfunction
     
     virtual task body();
         u_b_master_item m_item = u_b_master_item::type_id::create("m_item");
         u_test_config u_test_cfg;

         if (!uvm_config_db # (u_test_config)::get(null, get_full_name(), "u_test_cfg", u_test_cfg)) begin
            `uvm_fatal("NOCFG", {"can't get config" });
         end
  
         m_item.tvalid_one_freq  = this.tvalid_one_freq;
         m_item.tvalid_zero_freq = this.tvalid_zero_freq;
 
         repeat (u_test_cfg.cycle_time) begin
            
            start_item(m_item);
            if (!m_item.randomize()) begin
               `uvm_error("body", "randomization failed")
            end     
            finish_item(m_item);
         end
     endtask

endclass: u_b_m_sequence_base


class u_b_m_top_sequence extends u_a_m_top_sequence;

    `uvm_object_utils(u_b_m_top_sequence)

     function new(string name = "u_b_m_top_sequence");
        super.new(name);
     endfunction
     
     virtual task body();
         u_b_m_sequence_base u_seq_base = u_b_m_sequence_base::type_id::create("u_seq_base");

        u_test_config u_test_cfg;

         if (!uvm_config_db # (u_test_config)::get(null, get_full_name(), "u_test_cfg", u_test_cfg)) begin
            `uvm_fatal("NOCFG", {"can't get config" });

         end


         repeat (u_test_cfg.n_cycles) begin
            if (!u_seq_base.randomize()) begin
               `uvm_error("body", "randomization failed")
            end
            u_seq_base.start(m_sequencer);
         end
     endtask
endclass


class u_s_sequence_base extends uvm_sequence;

    `uvm_object_utils(u_s_sequence_base)


     rand int tready_one_freq;
     rand int tready_zero_freq;

     constraint s_tready_one_freq_range    {tready_one_freq    inside {1, 4, 16};}
     constraint s_tready_zero_freq_range   {tready_zero_freq   inside {1, 4, 16};}

     function new(string name = "u_s_sequence_base");
        super.new(name);
     endfunction

     virtual task body();

         u_slave_item s_item = u_slave_item::type_id::create("s_item");

         u_test_config u_test_cfg;

         if (!uvm_config_db # (u_test_config)::get(null, get_full_name(), "u_test_cfg", u_test_cfg)) begin
            `uvm_fatal("NOCFG", {"can't get config" });
         end

         s_item.tready_one_freq  = this.tready_one_freq;
         s_item.tready_zero_freq = this.tready_zero_freq;
 
         repeat(u_test_cfg.cycle_time) begin

            start_item(s_item);
            if (!s_item.randomize()) begin
               `uvm_error("body", "randomization failed")
            end     
            finish_item(s_item);
         end

     endtask
endclass


class u_s_top_sequence extends uvm_sequence;

     `uvm_object_utils(u_s_top_sequence)

     function new(string name = "u_s_top_sequence");
        super.new(name);
     endfunction

     virtual task body();

         u_s_sequence_base u_seq_base = u_s_sequence_base::type_id::create("u_seq_base");

         u_test_config u_test_cfg;

         if (!uvm_config_db # (u_test_config)::get(null, get_full_name(), "u_test_cfg", u_test_cfg)) begin
            `uvm_fatal("NOCFG", {"can't get config" });
         end

         repeat (u_test_cfg.n_cycles) begin

            if (!u_seq_base.randomize()) begin
               `uvm_error("body", "randomization failed")
            end
            u_seq_base.start(m_sequencer);
         
         end
     endtask
endclass: u_s_top_sequence




    