onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/clk
add wave -noupdate /mp3_tb/dut/mp3_cpu/cd/pc/out
add wave -noupdate -expand /mp3_tb/dut/mp3_cpu/cd/r/data
add wave -noupdate /mp3_tb/dut/mp3_cpu/cd/cr/ctrl.opcode
add wave -noupdate /mp3_tb/dut/mp3_cpu/cd/ifid_register/ctrl_word_out.opcode
add wave -noupdate /mp3_tb/dut/mp3_cpu/cd/idex_register/ctrl_word_out.opcode
add wave -noupdate /mp3_tb/dut/mp3_cpu/cd/exmem_register/ctrl_word_out.opcode
add wave -noupdate /mp3_tb/dut/mp3_cpu/cd/memwb_register/ctrl_word_out.opcode
add wave -noupdate /mp3_tb/dut/wb_icache/CLK
add wave -noupdate /mp3_tb/dut/wb_icache/DAT_M
add wave -noupdate /mp3_tb/dut/wb_icache/DAT_S
add wave -noupdate /mp3_tb/dut/wb_icache/ACK
add wave -noupdate /mp3_tb/dut/wb_icache/CYC
add wave -noupdate /mp3_tb/dut/wb_icache/STB
add wave -noupdate /mp3_tb/dut/wb_icache/RTY
add wave -noupdate /mp3_tb/dut/wb_icache/WE
add wave -noupdate /mp3_tb/dut/wb_icache/ADR
add wave -noupdate /mp3_tb/dut/wb_icache/SEL
add wave -noupdate /mp3_tb/dut/wb_dcache/CLK
add wave -noupdate /mp3_tb/dut/wb_dcache/DAT_M
add wave -noupdate /mp3_tb/dut/wb_dcache/DAT_S
add wave -noupdate /mp3_tb/dut/wb_dcache/ACK
add wave -noupdate /mp3_tb/dut/wb_dcache/CYC
add wave -noupdate /mp3_tb/dut/wb_dcache/STB
add wave -noupdate /mp3_tb/dut/wb_dcache/RTY
add wave -noupdate /mp3_tb/dut/wb_dcache/WE
add wave -noupdate /mp3_tb/dut/wb_dcache/ADR
add wave -noupdate /mp3_tb/dut/wb_dcache/SEL
add wave -noupdate /mp3_tb/dut/inter_connect/wb_mem/CLK
add wave -noupdate /mp3_tb/dut/inter_connect/wb_mem/DAT_M
add wave -noupdate /mp3_tb/dut/inter_connect/wb_mem/DAT_S
add wave -noupdate /mp3_tb/dut/inter_connect/wb_mem/ACK
add wave -noupdate /mp3_tb/dut/inter_connect/wb_mem/CYC
add wave -noupdate /mp3_tb/dut/inter_connect/wb_mem/STB
add wave -noupdate /mp3_tb/dut/inter_connect/wb_mem/RTY
add wave -noupdate /mp3_tb/dut/inter_connect/wb_mem/WE
add wave -noupdate /mp3_tb/dut/inter_connect/wb_mem/ADR
add wave -noupdate /mp3_tb/dut/inter_connect/wb_mem/SEL
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {26562 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 551
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
WaveRestoreZoom {193277 ps} {289533 ps}
radix -hex
