onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datapath_tb/clk
add wave -noupdate /datapath_tb/mp3_cpu/cd/r/data
add wave -noupdate /datapath_tb/mp3_cpu/cd/advance
add wave -noupdate /datapath_tb/mp3_cpu/cd/flush
add wave -noupdate /datapath_tb/mp3_cpu/cd/branch_enable
add wave -noupdate /datapath_tb/mp3_cpu/cd/pc/out
add wave -noupdate /datapath_tb/mp3_cpu/cd/instruction_request
add wave -noupdate /datapath_tb/mp3_cpu/cd/instruction_response
add wave -noupdate /datapath_tb/mp3_cpu/cd/instr
add wave -noupdate /datapath_tb/mp3_cpu/cd/mem_address
add wave -noupdate /datapath_tb/mp3_cpu/cd/data_request
add wave -noupdate /datapath_tb/mp3_cpu/cd/data_response
add wave -noupdate /datapath_tb/mp3_cpu/cd/mem_rdata
add wave -noupdate /datapath_tb/mp3_cpu/cd/write_data
add wave -noupdate /datapath_tb/mp3_cpu/cd/ifid_register/ctrl_word_in.opcode
add wave -noupdate /datapath_tb/mp3_cpu/cd/ifid_register/ctrl_word_out.opcode
add wave -noupdate /datapath_tb/mp3_cpu/cd/idex_register/ctrl_word_out.opcode
add wave -noupdate /datapath_tb/mp3_cpu/cd/exmem_register/ctrl_word_out.opcode
add wave -noupdate /datapath_tb/mp3_cpu/cd/memwb_register/ctrl_word_out.opcode
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {998537327 ps} 0} {{Cursor 2} {772905000 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 182
configure wave -valuecolwidth 357
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
WaveRestoreZoom {772648392 ps} {773175719 ps}
