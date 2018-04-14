onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/clk
add wave -noupdate -label Advance -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/advance
add wave -noupdate -label Flush /mp3_tb/dut/mp3_cpu/cd/flush
add wave -noupdate /mp3_tb/dut/mp3_cpu/cd/branch_enable
add wave -noupdate -label Registers -radix hexadecimal -childformat {{{/mp3_tb/dut/mp3_cpu/cd/r/data[7]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[6]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[5]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[4]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[3]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[2]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[1]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp3_tb/dut/mp3_cpu/cd/r/data[7]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[6]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[5]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[4]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[3]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[2]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[1]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[0]} {-color Gold -height 15 -radix hexadecimal}} /mp3_tb/dut/mp3_cpu/cd/r/data
add wave -noupdate -color White -label PC -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/pc/data
add wave -noupdate -color White -radix hexadecimal /mp3_tb/dut/mp3_cpu/instr
add wave -noupdate -color {Cornflower Blue} -label {IF Opcdoe} -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/ifid_register/ctrl_word_in.opcode
add wave -noupdate -color {Cornflower Blue} -label {IFID Opcode} -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/ifid_register/ctrl_word_out.opcode
add wave -noupdate -color {Cornflower Blue} -label {IDEX Opcode} -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/idex_register/ctrl_word_out.opcode
add wave -noupdate -color {Cornflower Blue} -label {EXMEM Opcode} -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/exmem_register/ctrl_word_out.opcode
add wave -noupdate -color {Cornflower Blue} -label {MEMWB Opcode} -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/memwb_register/ctrl_word_out.opcode
add wave -noupdate -color Red -radix hexadecimal /mp3_tb/dut/mp3_cpu/mem_address
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {998537327 ps} 0} {{Cursor 2} {772905000 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 209
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
WaveRestoreZoom {772648392 ps} {773161608 ps}
