transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/wishbone.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/register.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/plus2.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/mux2.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/lc3b_types.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/wishbone_interface.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/regfile.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/memwb.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/ifid.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/idex.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/gencc.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/exmem.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/control_rom.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/cccomp.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/alu.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/adj.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/cpu_datapath.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/cpu.sv}

vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/mp3_tb.sv}
vlog -sv -work work +incdir+/home/cblong2/ece411/mp3 {/home/cblong2/ece411/mp3/magic_memory_dual_port.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L stratixiii_ver -L rtl_work -L work -voptargs="+acc"  mp3_tb

add wave *
view structure
view signals
run 2000 ns
