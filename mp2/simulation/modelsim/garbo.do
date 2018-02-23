onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp2_tb/clk
add wave -noupdate /mp2_tb/clk
add wave -noupdate -radix hexadecimal /mp2_tb/clk
add wave -noupdate -radix hexadecimal /mp2_tb/dut/mem/DAT_M
add wave -noupdate -radix hexadecimal /mp2_tb/dut/mem/DAT_S
add wave -noupdate -radix hexadecimal /mp2_tb/dut/mem/ACK
add wave -noupdate -radix hexadecimal /mp2_tb/dut/mem/CYC
add wave -noupdate -radix hexadecimal /mp2_tb/dut/mem/STB
add wave -noupdate -radix hexadecimal /mp2_tb/dut/mem/RTY
add wave -noupdate -radix hexadecimal /mp2_tb/dut/mem/WE
add wave -noupdate -radix hexadecimal /mp2_tb/dut/mem/ADR
add wave -noupdate -radix hexadecimal /mp2_tb/dut/mem/SEL
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_to_cache/DAT_M
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_to_cache/DAT_S
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_to_cache/ACK
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_to_cache/CYC
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_to_cache/STB
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_to_cache/RTY
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_to_cache/WE
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_to_cache/ADR
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_to_cache/SEL
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu/opcode
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu/Datapath/r/data
add wave -noupdate -radix hexadecimal -childformat {{{/mp2_tb/dut/cache/cd/data1/data[7]} -radix hexadecimal} {{/mp2_tb/dut/cache/cd/data1/data[6]} -radix hexadecimal} {{/mp2_tb/dut/cache/cd/data1/data[5]} -radix hexadecimal} {{/mp2_tb/dut/cache/cd/data1/data[4]} -radix hexadecimal} {{/mp2_tb/dut/cache/cd/data1/data[3]} -radix hexadecimal} {{/mp2_tb/dut/cache/cd/data1/data[2]} -radix hexadecimal} {{/mp2_tb/dut/cache/cd/data1/data[1]} -radix hexadecimal} {{/mp2_tb/dut/cache/cd/data1/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp2_tb/dut/cache/cd/data1/data[7]} {-height 16 -radix hexadecimal} {/mp2_tb/dut/cache/cd/data1/data[6]} {-height 16 -radix hexadecimal} {/mp2_tb/dut/cache/cd/data1/data[5]} {-height 16 -radix hexadecimal} {/mp2_tb/dut/cache/cd/data1/data[4]} {-height 16 -radix hexadecimal} {/mp2_tb/dut/cache/cd/data1/data[3]} {-height 16 -radix hexadecimal} {/mp2_tb/dut/cache/cd/data1/data[2]} {-height 16 -radix hexadecimal} {/mp2_tb/dut/cache/cd/data1/data[1]} {-height 16 -radix hexadecimal} {/mp2_tb/dut/cache/cd/data1/data[0]} {-height 16 -radix hexadecimal}} /mp2_tb/dut/cache/cd/data1/data
add wave -noupdate -radix hexadecimal -childformat {{{/mp2_tb/dut/cache/cd/data2/data[7]} -radix hexadecimal} {{/mp2_tb/dut/cache/cd/data2/data[6]} -radix hexadecimal} {{/mp2_tb/dut/cache/cd/data2/data[5]} -radix hexadecimal} {{/mp2_tb/dut/cache/cd/data2/data[4]} -radix hexadecimal} {{/mp2_tb/dut/cache/cd/data2/data[3]} -radix hexadecimal} {{/mp2_tb/dut/cache/cd/data2/data[2]} -radix hexadecimal} {{/mp2_tb/dut/cache/cd/data2/data[1]} -radix hexadecimal} {{/mp2_tb/dut/cache/cd/data2/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp2_tb/dut/cache/cd/data2/data[7]} {-height 16 -radix hexadecimal} {/mp2_tb/dut/cache/cd/data2/data[6]} {-height 16 -radix hexadecimal} {/mp2_tb/dut/cache/cd/data2/data[5]} {-height 16 -radix hexadecimal} {/mp2_tb/dut/cache/cd/data2/data[4]} {-height 16 -radix hexadecimal} {/mp2_tb/dut/cache/cd/data2/data[3]} {-height 16 -radix hexadecimal} {/mp2_tb/dut/cache/cd/data2/data[2]} {-height 16 -radix hexadecimal} {/mp2_tb/dut/cache/cd/data2/data[1]} {-height 16 -radix hexadecimal} {/mp2_tb/dut/cache/cd/data2/data[0]} {-height 16 -radix hexadecimal}} /mp2_tb/dut/cache/cd/data2/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {302597 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 270
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
WaveRestoreZoom {0 ps} {946176 ps}
