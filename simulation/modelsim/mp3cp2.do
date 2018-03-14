onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label REG -radix hexadecimal -childformat {{{/mp3_tb/dut/mp3_cpu/cd/r/data[7]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[6]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[5]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[4]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[3]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[2]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[1]} -radix hexadecimal} {{/mp3_tb/dut/mp3_cpu/cd/r/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp3_tb/dut/mp3_cpu/cd/r/data[7]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[6]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[5]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[4]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[3]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[2]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[1]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/mp3_cpu/cd/r/data[0]} {-height 22 -radix hexadecimal}} /mp3_tb/dut/mp3_cpu/cd/r/data
add wave -noupdate -label OPCODE -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/cr/opcode
add wave -noupdate -label PC_OUT -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/pc/out
add wave -noupdate -label CTRL.opcode -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/cr/ctrl.opcode
add wave -noupdate -label IFID.opcode -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/ifid_register/ctrl_word_out.opcode
add wave -noupdate -label IDEX.opcode -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/idex_register/ctrl_word_out.opcode
add wave -noupdate -label EXEM.opcode -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/exmem_register/ctrl_word_out.opcode
add wave -noupdate -label MEMWB.opcode -radix hexadecimal /mp3_tb/dut/mp3_cpu/cd/memwb_register/ctrl_word_out.opcode
add wave -noupdate -label INSTR_CACHE.DAT_M -radix hexadecimal /mp3_tb/dut/wb_icache/DAT_M
add wave -noupdate -label INSTR_CACHE.DAT_S -radix hexadecimal /mp3_tb/dut/wb_icache/DAT_S
add wave -noupdate -label INSTR_CACHE.ACK -radix hexadecimal /mp3_tb/dut/wb_icache/ACK
add wave -noupdate -label INSTR_CACHE.CYC -radix hexadecimal /mp3_tb/dut/wb_icache/CYC
add wave -noupdate -label INSTR_CACHE.STB -radix hexadecimal /mp3_tb/dut/wb_icache/STB
add wave -noupdate -label INSTR_CACHE.RTY -radix hexadecimal /mp3_tb/dut/wb_icache/RTY
add wave -noupdate -label INSTR_CACHE.WE -radix hexadecimal /mp3_tb/dut/wb_icache/WE
add wave -noupdate -label INSTR_CACHE.ADR -radix hexadecimal /mp3_tb/dut/wb_icache/ADR
add wave -noupdate -label INSTR_CACHE.SEL -radix hexadecimal /mp3_tb/dut/wb_icache/SEL
add wave -noupdate -radix hexadecimal /mp3_tb/dut/wb_dcache/CLK
add wave -noupdate -radix hexadecimal /mp3_tb/dut/wb_dcache/DAT_M
add wave -noupdate -radix hexadecimal /mp3_tb/dut/wb_dcache/DAT_S
add wave -noupdate -radix hexadecimal /mp3_tb/dut/wb_dcache/ACK
add wave -noupdate -radix hexadecimal /mp3_tb/dut/wb_dcache/CYC
add wave -noupdate -radix hexadecimal /mp3_tb/dut/wb_dcache/STB
add wave -noupdate -radix hexadecimal /mp3_tb/dut/wb_dcache/RTY
add wave -noupdate -radix hexadecimal /mp3_tb/dut/wb_dcache/WE
add wave -noupdate -radix hexadecimal /mp3_tb/dut/wb_dcache/ADR
add wave -noupdate -radix hexadecimal /mp3_tb/dut/wb_dcache/SEL
add wave -noupdate -radix hexadecimal /mp3_tb/dut/inter_connect/wb_mem/CLK
add wave -noupdate -radix hexadecimal /mp3_tb/dut/inter_connect/wb_mem/DAT_M
add wave -noupdate -radix hexadecimal /mp3_tb/dut/inter_connect/wb_mem/DAT_S
add wave -noupdate -radix hexadecimal /mp3_tb/dut/inter_connect/wb_mem/ACK
add wave -noupdate -radix hexadecimal /mp3_tb/dut/inter_connect/wb_mem/CYC
add wave -noupdate -radix hexadecimal /mp3_tb/dut/inter_connect/wb_mem/STB
add wave -noupdate -radix hexadecimal /mp3_tb/dut/inter_connect/wb_mem/RTY
add wave -noupdate -radix hexadecimal /mp3_tb/dut/inter_connect/wb_mem/WE
add wave -noupdate -radix hexadecimal /mp3_tb/dut/inter_connect/wb_mem/ADR
add wave -noupdate -radix hexadecimal /mp3_tb/dut/inter_connect/wb_mem/SEL
add wave -noupdate -radix hexadecimal /mp3_tb/dut/inter_connect/state
add wave -noupdate -radix hexadecimal /mp3_tb/wb/ACK
add wave -noupdate -radix hexadecimal /mp3_tb/dut/icache/cache_dpth/tag_checker/match0
add wave -noupdate -radix hexadecimal /mp3_tb/dut/icache/cache_dpth/tag_checker/match1
add wave -noupdate -radix hexadecimal /mp3_tb/dut/icache/cache_dpth/tag_arr0/data
add wave -noupdate -radix hexadecimal /mp3_tb/dut/icache/cache_dpth/tag_arr1/data
add wave -noupdate -radix hexadecimal /mp3_tb/dut/icache/cache_dpth/mem_address
add wave -noupdate -radix hexadecimal /mp3_tb/dut/icache/cache_dpth/cpu_address
add wave -noupdate -radix hexadecimal -childformat {{{/mp3_tb/dut/icache/cache_dpth/data_arr0/data[7]} -radix hexadecimal} {{/mp3_tb/dut/icache/cache_dpth/data_arr0/data[6]} -radix hexadecimal} {{/mp3_tb/dut/icache/cache_dpth/data_arr0/data[5]} -radix hexadecimal} {{/mp3_tb/dut/icache/cache_dpth/data_arr0/data[4]} -radix hexadecimal} {{/mp3_tb/dut/icache/cache_dpth/data_arr0/data[3]} -radix hexadecimal} {{/mp3_tb/dut/icache/cache_dpth/data_arr0/data[2]} -radix hexadecimal} {{/mp3_tb/dut/icache/cache_dpth/data_arr0/data[1]} -radix hexadecimal} {{/mp3_tb/dut/icache/cache_dpth/data_arr0/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp3_tb/dut/icache/cache_dpth/data_arr0/data[7]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/icache/cache_dpth/data_arr0/data[6]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/icache/cache_dpth/data_arr0/data[5]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/icache/cache_dpth/data_arr0/data[4]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/icache/cache_dpth/data_arr0/data[3]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/icache/cache_dpth/data_arr0/data[2]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/icache/cache_dpth/data_arr0/data[1]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/icache/cache_dpth/data_arr0/data[0]} {-height 22 -radix hexadecimal}} /mp3_tb/dut/icache/cache_dpth/data_arr0/data
add wave -noupdate -radix hexadecimal -childformat {{{/mp3_tb/dut/icache/cache_dpth/data_arr1/data[7]} -radix hexadecimal} {{/mp3_tb/dut/icache/cache_dpth/data_arr1/data[6]} -radix hexadecimal} {{/mp3_tb/dut/icache/cache_dpth/data_arr1/data[5]} -radix hexadecimal} {{/mp3_tb/dut/icache/cache_dpth/data_arr1/data[4]} -radix hexadecimal} {{/mp3_tb/dut/icache/cache_dpth/data_arr1/data[3]} -radix hexadecimal} {{/mp3_tb/dut/icache/cache_dpth/data_arr1/data[2]} -radix hexadecimal} {{/mp3_tb/dut/icache/cache_dpth/data_arr1/data[1]} -radix hexadecimal} {{/mp3_tb/dut/icache/cache_dpth/data_arr1/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp3_tb/dut/icache/cache_dpth/data_arr1/data[7]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/icache/cache_dpth/data_arr1/data[6]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/icache/cache_dpth/data_arr1/data[5]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/icache/cache_dpth/data_arr1/data[4]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/icache/cache_dpth/data_arr1/data[3]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/icache/cache_dpth/data_arr1/data[2]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/icache/cache_dpth/data_arr1/data[1]} {-height 22 -radix hexadecimal} {/mp3_tb/dut/icache/cache_dpth/data_arr1/data[0]} {-height 22 -radix hexadecimal}} /mp3_tb/dut/icache/cache_dpth/data_arr1/data
add wave -noupdate -radix hexadecimal /mp3_tb/dut/icache/cache_dpth/data_arr0/clk
add wave -noupdate -radix hexadecimal /mp3_tb/dut/icache/cache_dpth/data_arr0/write
add wave -noupdate -radix hexadecimal /mp3_tb/dut/icache/cache_dpth/data_arr0/index
add wave -noupdate -radix hexadecimal /mp3_tb/dut/icache/cache_dpth/data_arr0/datain
add wave -noupdate -radix hexadecimal /mp3_tb/dut/icache/cache_dpth/data_arr0/dataout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {135742 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 578
configure wave -valuecolwidth 357
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
WaveRestoreZoom {0 ps} {589907 ps}
