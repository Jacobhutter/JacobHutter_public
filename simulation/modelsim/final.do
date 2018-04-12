onerror {resume}
quietly WaveActivateNextPane {} 0
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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25740000 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {24406 ns} {26454 ns}
