onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/clk
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/instruction_request
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/instruction_response
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/data_request
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/data_response
add wave -noupdate -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/advance
add wave -noupdate -color Gold -label ICACHE_HIT /mp3_tb/dut/icache/ctrl_hit
add wave -noupdate -color Gold -label i_cache_hit -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/i_cache_hits_counter/count
add wave -noupdate -color Gold -label i_cache_miss -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/i_cache_misses_counter/count
add wave -noupdate -color Red -label DCACHE_HIT /mp3_tb/dut/dcache/ctrl_hit
add wave -noupdate -color Red -label d_cache_hit -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/d_cache_hits_counter/count
add wave -noupdate -color Red -label d_cache_miss -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/d_cache_misses_counter/count
add wave -noupdate -color {Lime Green} -label L2CACHE_HIT /mp3_tb/dut/l2cache/ctrl_hit
add wave -noupdate -color {Lime Green} -label l2_cache_hits -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/l2_cache_hits_counter/count
add wave -noupdate -color {Lime Green} -label l2_cache_miss -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/l2_cache_misses_counter/count
add wave -noupdate -color {Cornflower Blue} -label branches -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/branch_prediction_counter/count
add wave -noupdate -color {Cornflower Blue} -label mispredictions -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/mispredictions_counter/count
add wave -noupdate -color {Dark Orchid} -label stalls -radix hexadecimal -childformat {{{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[15]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[14]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[13]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[12]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[11]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[10]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[9]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[8]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[7]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[6]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[5]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[4]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[3]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[2]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[1]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[0]} -radix hexadecimal}} -subitemconfig {{/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[15]} {-color {Dark Orchid} -height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[14]} {-color {Dark Orchid} -height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[13]} {-color {Dark Orchid} -height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[12]} {-color {Dark Orchid} -height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[11]} {-color {Dark Orchid} -height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[10]} {-color {Dark Orchid} -height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[9]} {-color {Dark Orchid} -height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[8]} {-color {Dark Orchid} -height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[7]} {-color {Dark Orchid} -height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[6]} {-color {Dark Orchid} -height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[5]} {-color {Dark Orchid} -height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[4]} {-color {Dark Orchid} -height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[3]} {-color {Dark Orchid} -height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[2]} {-color {Dark Orchid} -height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[1]} {-color {Dark Orchid} -height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/stalls_counter/count[0]} {-color {Dark Orchid} -height 22 -radix hexadecimal}} /mp3_tb/dut/mp3_cpu/cd/stalls_counter/count
add wave -noupdate /mp3_tb/dut/mp3_cpu/cd/stall
add wave -noupdate -color White -label PC -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/pc/data
add wave -noupdate -color White -radix hexadecimal /mp3_tb/dut/mp3_cpu/instr
add wave -noupdate -color {Cornflower Blue} -label {IF Opcdoe} -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/ifid_register/ctrl_word_in.opcode
add wave -noupdate -color {Cornflower Blue} -label {IFID Opcode} -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/ifid_register/ctrl_word_out.opcode
add wave -noupdate -color {Cornflower Blue} -label {IDEX Opcode} -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/idex_register/ctrl_word_out.opcode
add wave -noupdate -color {Cornflower Blue} -label {EXMEM Opcode} -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/exmem_register/ctrl_word_out.opcode
add wave -noupdate -color {Cornflower Blue} -label {MEMWB Opcode} -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/memwb_register/ctrl_word_out.opcode
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {999431441 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 270
configure wave -valuecolwidth 78
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
WaveRestoreZoom {999404210 ps} {1000031358 ps}
