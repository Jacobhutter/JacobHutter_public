transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib nios_system
vmap nios_system nios_system
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis {I:/LAB_9/nios_system/synthesis/nios_system.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/altera_reset_controller.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/altera_reset_synchronizer.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_avalon_st_adapter_005.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_avalon_st_adapter.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/altera_avalon_sc_fifo.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_to_sw_sig.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_to_sw_port.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_to_hw_sig.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_to_hw_port.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_sysid_qsys_0.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_sdram_pll.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_sdram.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_onchip_memory2_0.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_nios_system.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_nios_system_cpu.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_nios_system_cpu_debug_slave_sysclk.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_nios_system_cpu_debug_slave_tck.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_nios_system_cpu_debug_slave_wrapper.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_nios_system_cpu_test_bench.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_jtag_uart_0.v}
vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/SubBytes.sv}
vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/lab9.sv}
vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/io_module.sv}
vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/InvMixColumns.sv}
vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/HexDriver.sv}
vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/aes_controller.sv}
vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/AddRoundKey.sv}
vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/InvShiftRows.sv}
vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/tristate.sv}
vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/BigReg.sv}
vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/InvSbox.sv}
vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/InvSubBytes.sv}
vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/mux.sv}
vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/SmallReg.sv}
vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/KeyExpansion.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_irq_mapper.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_avalon_st_adapter_005_error_adapter_0.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/altera_avalon_st_handshake_clock_crosser.v}
vlog -vlog01compat -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/altera_avalon_st_clock_crosser.v}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/altera_merlin_width_adapter.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/altera_merlin_burst_uncompressor.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/altera_merlin_arbitrator.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_rsp_mux_001.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_rsp_mux.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_rsp_demux_001.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_rsp_demux.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_cmd_mux_001.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_cmd_mux.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_cmd_demux_001.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_cmd_demux.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/altera_merlin_burst_adapter.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/altera_merlin_burst_adapter_uncmpr.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router_007.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router_003.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router_002.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router_001.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/altera_merlin_slave_agent.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/altera_merlin_master_agent.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/altera_merlin_slave_translator.sv}
vlog -sv -work nios_system +incdir+I:/LAB_9/nios_system/synthesis/submodules {I:/LAB_9/nios_system/synthesis/submodules/altera_merlin_master_translator.sv}
vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/AES.sv}

vlog -sv -work work +incdir+I:/LAB_9 {I:/LAB_9/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L nios_system -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 100000 ns
