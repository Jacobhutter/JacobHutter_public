onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /globalBHT_tb/clk
add wave -noupdate -radix hexadecimal /globalBHT_tb/pc_in
add wave -noupdate {/globalBHT_tb/pc_in[0]}
add wave -noupdate /globalBHT_tb/update
add wave -noupdate /globalBHT_tb/predict
add wave -noupdate -expand /globalBHT_tb/DUT/pht_array/data
add wave -noupdate -radix unsigned /globalBHT_tb/DUT/pht_array/index
add wave -noupdate /globalBHT_tb/DUT/branch_history_register
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10000 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {186912 ps}
