onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/clk
add wave -noupdate /mp3_tb/clk
add wave -noupdate -radix hexadecimal /mp3_tb/clk
add wave -noupdate -label Registers -radix hexadecimal -childformat {{{/mp3_tb/dut/mp3_cpu/cd/r/data[7]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[6]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[5]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[4]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[3]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[2]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[1]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp3_tb/dut/mp3_cpu/cd/r/data[7]} {-height 15 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[6]} {-height 15 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[5]} {-height 15 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[4]} {-height 15 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[3]} {-height 15 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[2]} {-height 15 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[1]} {-height 15 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[0]} {-height 15 -radix hexadecimal}} /mp3_tb/dut/mp3_cpu/cd/r/data
add wave -noupdate -label PC -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/pc/data
add wave -noupdate -label {IF Opcdoe} -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/ifid_register/ctrl_word_in.opcode
add wave -noupdate -label {IFID Opcode} -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/ifid_register/ctrl_word_out.opcode
add wave -noupdate -label {IDEX Opcode} -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/idex_register/ctrl_word_out.opcode
add wave -noupdate -label {EXMEM Opcode} -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/exmem_register/ctrl_word_out.opcode
add wave -noupdate -label {MEMWB Opcode} -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/memwb_register/ctrl_word_out.opcode
add wave -noupdate -label Advance -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/advance
add wave -noupdate -label Flush /mp3_tb/dut/mp3_cpu/cd/flush
add wave -noupdate /mp3_tb/dut/mp3_cpu/cd/data_request
add wave -noupdate /mp3_tb/dut/mp3_cpu/cd/data_response
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/mem_address
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/mem_output
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/branch_predictor/bp_miss
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/branch_predictor/branch_enable
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/branch_predictor/flush
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/branch_predictor/if_control_word
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/branch_predictor/incoming_control_word
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/branch_predictor/incoming_valid_branch
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/branch_predictor/outgoing_control_word
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/branch_predictor/outgoing_valid_branch
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/branch_predictor/pcmux_sel
add wave -noupdate /mp3_tb/dut/mp3_cpu/cd/branch_enable
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/instr
add wave -noupdate /mp3_tb/dut/mp3_cpu/cd/CCCOMP/branch_enable
add wave -noupdate /mp3_tb/dut/mp3_cpu/cd/CCCOMP/cc
add wave -noupdate /mp3_tb/dut/mp3_cpu/cd/CCCOMP/dest
add wave -noupdate /mp3_tb/dut/mp3_cpu/cd/ifid_register/dest
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15805000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 209
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
WaveRestoreZoom {15144032 ps} {17098941 ps}
