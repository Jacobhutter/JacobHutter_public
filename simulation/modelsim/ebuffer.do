onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /evictbuf_tb/clk
add wave -noupdate /evictbuf_tb/orig_wb/CLK
add wave -noupdate /evictbuf_tb/orig_wb/DAT_M
add wave -noupdate /evictbuf_tb/orig_wb/DAT_S
add wave -noupdate /evictbuf_tb/orig_wb/ACK
add wave -noupdate /evictbuf_tb/orig_wb/CYC
add wave -noupdate /evictbuf_tb/orig_wb/STB
add wave -noupdate /evictbuf_tb/orig_wb/RTY
add wave -noupdate /evictbuf_tb/orig_wb/WE
add wave -noupdate /evictbuf_tb/orig_wb/ADR
add wave -noupdate /evictbuf_tb/orig_wb/SEL
add wave -noupdate /evictbuf_tb/dest_wb/CLK
add wave -noupdate /evictbuf_tb/dest_wb/DAT_M
add wave -noupdate /evictbuf_tb/dest_wb/DAT_S
add wave -noupdate /evictbuf_tb/dest_wb/ACK
add wave -noupdate /evictbuf_tb/dest_wb/CYC
add wave -noupdate /evictbuf_tb/dest_wb/STB
add wave -noupdate /evictbuf_tb/dest_wb/RTY
add wave -noupdate /evictbuf_tb/dest_wb/WE
add wave -noupdate /evictbuf_tb/dest_wb/ADR
add wave -noupdate /evictbuf_tb/dest_wb/SEL
add wave -noupdate /evictbuf_tb/eb_dut/eb_control/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {96247 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 257
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {234897 ps}
