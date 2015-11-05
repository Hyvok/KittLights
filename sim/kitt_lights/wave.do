onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /kitt_lights_tb/DUT_inst/reset
add wave -noupdate -expand /kitt_lights_tb/DUT_inst/lights_out
add wave -noupdate -expand /kitt_lights_tb/DUT_inst/active
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16224417351 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 218
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ps} {64692944896 ps}
