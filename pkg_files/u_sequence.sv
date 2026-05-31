class u_a_m_sequence extends uvm_sequence;
     `uvm_object_utils(u_a_m_sequence)

     int sim_time = 256;

     virtual task body();

         u_a_master_item m_item = u_a_master_item::type_id::create("m_item");
 
         repeat(sim_time) begin
             start_item(m_item);     
             if (!m_item.randomize()) begin
                `uvm_error("body", "randomization failed")
             end     
             finish_item(m_item);
         end
     endtask
endclass: u_a_m_sequence




class u_b_m_sequence extends uvm_sequence;
     `uvm_object_utils(u_b_m_sequence)

     int sim_time = 256;

     virtual task body();

         u_b_master_item m_item = u_b_master_item::type_id::create("m_item");
 
         repeat(sim_time) begin
             start_item(m_item);     
             if (!m_item.randomize()) begin
                `uvm_error("body", "randomization failed")
             end     
             finish_item(m_item);
         end
     endtask
endclass: u_b_m_sequence




class u_s_sequence extends uvm_sequence;
     `uvm_object_utils(u_s_sequence)

     int sim_time = 256;

     virtual task body();

         u_slave_item s_item = u_slave_item::type_id::create("s_item");
 
         repeat(sim_time) begin
             start_item(s_item);     
             if (!s_item.randomize()) begin
                `uvm_error("body", "randomization failed")
             end     
             finish_item(s_item);
         end

     endtask
endclass