create_clock -period 50MHz -name 50MHzClk [get_ports clk_in]
derive_clock_uncertainty
set_false_path -from [get_ports reset_in]
set_false_path -to [get_ports lights_out*]
