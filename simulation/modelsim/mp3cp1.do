onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/clk
add wave -noupdate /mp3_tb/clk
add wave -noupdate /mp3_tb/clk
add wave -noupdate /mp3_tb/clk
add wave -noupdate /mp3_tb/clk
add wave -noupdate /mp3_tb/clk
add wave -noupdate -label REG -radix hexadecimal -childformat {{{/mp3_tb/dut/cd/r/data[7]} -radix hexadecimal} {{/mp3_tb/dut/cd/r/data[6]} -radix hexadecimal} {{/mp3_tb/dut/cd/r/data[5]} -radix hexadecimal} {{/mp3_tb/dut/cd/r/data[4]} -radix hexadecimal} {{/mp3_tb/dut/cd/r/data[3]} -radix hexadecimal} {{/mp3_tb/dut/cd/r/data[2]} -radix hexadecimal} {{/mp3_tb/dut/cd/r/data[1]} -radix hexadecimal} {{/mp3_tb/dut/cd/r/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp3_tb/dut/cd/r/data[7]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/cd/r/data[6]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/cd/r/data[5]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/cd/r/data[4]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/cd/r/data[3]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/cd/r/data[2]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/cd/r/data[1]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/cd/r/data[0]} {-height 22 -radix hexadecimal}} /mp3_tb/dut/cd/r/data
add wave -noupdate -label PC_OUT -radix hexadecimal /mp3_tb/dut/cd/pc/data
add wave -noupdate /mp3_tb/dut/cd/cr/opcode
add wave -noupdate -label IFID.OPCODE /mp3_tb/dut/cd/ifid_register/ctrl_word_out.opcode
add wave -noupdate -label IDEX.OPCODE /mp3_tb/dut/cd/idex_register/ctrl_word_out.opcode
add wave -noupdate -label EXEM.OPCODE /mp3_tb/dut/cd/exmem_register/ctrl_word_out.opcode
add wave -noupdate -label MEMWB.OPCODE /mp3_tb/dut/cd/memwb_register/ctrl_word_out.opcode
add wave -noupdate -radix hexadecimal /mp3_tb/dut/instr
add wave -noupdate -label INSTR.ADDR -radix hexadecimal /mp3_tb/i/ADR
add wave -noupdate -label INSTR.DATA_M -radix hexadecimal /mp3_tb/i/DAT_M
add wave -noupdate -label INSTR.DATA_S -radix hexadecimal /mp3_tb/i/DAT_S
add wave -noupdate -label DATA.DATA_M -radix hexadecimal /mp3_tb/d/DAT_M
add wave -noupdate -label DATA.DATA_S -radix hexadecimal /mp3_tb/d/DAT_S
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/ifid_register/offset6
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/idex_register/offset6_in
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/exmem_register/ex_alu_out
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/alumux/f
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/ALU/a
add wave -noupdate /mp3_tb/dut/cd/ALU/aluop
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/ALU/b
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/ALU/f
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/alumux/a
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/alumux/b
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/alumux/f
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/MAR/data
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/MAR/in
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/MAR/load
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/r/dest
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/r/in
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/r/load
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/memwb_register/advance
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/memwb_register/dest_out
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/memwb_register/mem_wdata_out
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/memwb_register/ready
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/ifid_register/pc
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/idex_register/pc
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/exmem_register/pc
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/memwb_register/pc
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/memwb_register/offset9_out
add wave -noupdate /mp3_tb/dut/cd/ifid_register/dest
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/idex_register/dest_out
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/exmem_register/dest_out
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/memwb_register/dest_out
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/regfilemux/a
add wave -noupdate -radix hexadecimal /mp3_tb/dut/cd/regfilemux/b
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {92504 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 351
configure wave -valuecolwidth 359
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
WaveRestoreZoom {0 ps} {513533 ps}
