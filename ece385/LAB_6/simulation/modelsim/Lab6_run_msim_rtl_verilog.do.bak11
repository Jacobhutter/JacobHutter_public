transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/tristate.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/SLC3_2.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/two_mux.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/Mem2IO.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/HexDriver.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/buffermux.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/16bitreg.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/register_1.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/mux_8.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/logic2.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/logic1.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/ISDU.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/ALUK.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/4to1mux.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/mux_3.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/test_memory.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/Reg_File.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/datapath.sv}
vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/slc3.sv}

vlog -sv -work work +incdir+I:/LAB_6 {I:/LAB_6/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 10000 ns
