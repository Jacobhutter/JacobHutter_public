onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_master/Datapath/opcode
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_master/Datapath/pc_out
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_master/Control/mem_read
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_master/Control/mem_resp
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_master/Datapath/mem_rdata
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_master/Datapath/mem_address
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_master/mem_byte_enable
add wave -noupdate -radix binary      /mp2_tb/dut/wishb/SEL
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu_master/Datapath/mem_wdata
add wave -noupdate -radix hexadecimal -childformat {{{/mp2_tb/dut/cpu_master/Datapath/r/data[7]} -radix hexadecimal} {{/mp2_tb/dut/cpu_master/Datapath/r/data[6]} -radix hexadecimal} {{/mp2_tb/dut/cpu_master/Datapath/r/data[5]} -radix hexadecimal} {{/mp2_tb/dut/cpu_master/Datapath/r/data[4]} -radix hexadecimal} {{/mp2_tb/dut/cpu_master/Datapath/r/data[3]} -radix hexadecimal} {{/mp2_tb/dut/cpu_master/Datapath/r/data[2]} -radix hexadecimal} {{/mp2_tb/dut/cpu_master/Datapath/r/data[1]} -radix hexadecimal} {{/mp2_tb/dut/cpu_master/Datapath/r/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp2_tb/dut/cpu_master/Datapath/r/data[7]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cpu_master/Datapath/r/data[6]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cpu_master/Datapath/r/data[5]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cpu_master/Datapath/r/data[4]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cpu_master/Datapath/r/data[3]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cpu_master/Datapath/r/data[2]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cpu_master/Datapath/r/data[1]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/cpu_master/Datapath/r/data[0]} {-height 15 -radix hexadecimal}} /mp2_tb/dut/cpu_master/Datapath/r/data
add wave -noupdate -radix hexadecimal -childformat {{{/mp2_tb/dut/Cache/cd/data1/data[7]} -radix hexadecimal} {{/mp2_tb/dut/Cache/cd/data1/data[6]} -radix hexadecimal} {{/mp2_tb/dut/Cache/cd/data1/data[5]} -radix hexadecimal} {{/mp2_tb/dut/Cache/cd/data1/data[4]} -radix hexadecimal} {{/mp2_tb/dut/Cache/cd/data1/data[3]} -radix hexadecimal} {{/mp2_tb/dut/Cache/cd/data1/data[2]} -radix hexadecimal} {{/mp2_tb/dut/Cache/cd/data1/data[1]} -radix hexadecimal} {{/mp2_tb/dut/Cache/cd/data1/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp2_tb/dut/Cache/cd/data1/data[7]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/Cache/cd/data1/data[6]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/Cache/cd/data1/data[5]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/Cache/cd/data1/data[4]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/Cache/cd/data1/data[3]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/Cache/cd/data1/data[2]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/Cache/cd/data1/data[1]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/Cache/cd/data1/data[0]} {-height 15 -radix hexadecimal}} /mp2_tb/dut/Cache/cd/data1/data
add wave -noupdate -radix hexadecimal -childformat {{{/mp2_tb/dut/Cache/cd/data2/data[7]} -radix hexadecimal} {{/mp2_tb/dut/Cache/cd/data2/data[6]} -radix hexadecimal} {{/mp2_tb/dut/Cache/cd/data2/data[5]} -radix hexadecimal} {{/mp2_tb/dut/Cache/cd/data2/data[4]} -radix hexadecimal} {{/mp2_tb/dut/Cache/cd/data2/data[3]} -radix hexadecimal} {{/mp2_tb/dut/Cache/cd/data2/data[2]} -radix hexadecimal} {{/mp2_tb/dut/Cache/cd/data2/data[1]} -radix hexadecimal} {{/mp2_tb/dut/Cache/cd/data2/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp2_tb/dut/Cache/cd/data2/data[7]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/Cache/cd/data2/data[6]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/Cache/cd/data2/data[5]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/Cache/cd/data2/data[4]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/Cache/cd/data2/data[3]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/Cache/cd/data2/data[2]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/Cache/cd/data2/data[1]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/Cache/cd/data2/data[0]} {-height 15 -radix hexadecimal}} /mp2_tb/dut/Cache/cd/data2/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10016939 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 340
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
WaveRestoreZoom {0 ps} {902324 ps}
restart -f
run 10000ns
