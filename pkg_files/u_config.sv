class u_seq_config extends uvm_object;

    `uvm_object_utils(u_seq_config)

    rand int a_m_tvalid_one_freq;
    rand int a_m_tvalid_zero_freq;
    rand int b_m_tvalid_one_freq;
    rand int b_m_tvalid_zero_freq;
    rand int s_tready_one_freq;
    rand int s_tready_zero_freq;

    function new (string name = "u_seq_config");
        super.new(name);
    endfunction

    constraint a_m_tvalid_one_freq_range  {a_m_tvalid_one_freq  inside {1, 4, 16};}
    constraint a_m_tvalid_zero_freq_range {a_m_tvalid_zero_freq inside {1, 4, 16};}
    constraint b_m_tvalid_one_freq_range  {b_m_tvalid_one_freq  inside {1, 4, 16};}
    constraint b_m_tvalid_zero_freq_range {b_m_tvalid_zero_freq inside {1, 4, 16};}
    constraint s_tready_one_freq_range    {s_tready_one_freq    inside {1, 4, 16};}
    constraint s_tready_zero_freq_range   {s_tready_zero_freq   inside {1, 4, 16};}


endclass


class u_test_config extends uvm_object;

    `uvm_object_utils(u_test_config)

    int n_cycles;
    int cycle_time;

    function new (string name = "u_test_config");
        super.new(name);
    endfunction

endclass