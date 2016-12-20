transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib nios_system
vmap nios_system nios_system
<<<<<<< HEAD
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/nios_system.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_reset_controller.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_reset_synchronizer.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_avalon_st_adapter_005.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_avalon_st_adapter.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_avalon_sc_fifo.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_sysid_qsys_0.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_sdram_pll.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_sdram.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_otg_hpi_data.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_otg_hpi_cs.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_otg_hpi_address.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_onchip_memory2_0.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_nios2_qsys_0.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_nios2_qsys_0_cpu.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_nios2_qsys_0_cpu_debug_slave_sysclk.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_nios2_qsys_0_cpu_debug_slave_tck.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_nios2_qsys_0_cpu_debug_slave_wrapper.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_nios2_qsys_0_cpu_test_bench.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_jtag_uart_0.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_Keycode.v}
vlog -sv -work work +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3 {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/VGA_controller.sv}
vlog -sv -work work +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3 {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/lab8.sv}
vlog -sv -work work +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3 {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/hpi_io_intf.sv}
vlog -sv -work work +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3 {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3 {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/Color_Mapper.sv}
vlog -sv -work work +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3 {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/square.sv}
vlog -sv -work work +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3 {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/keycode_state_machine.sv}
vlog -sv -work work +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3 {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/reg6.sv}
vlog -sv -work work +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3 {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/shape_generator.sv}
vlog -sv -work work +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3 {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/reg16.sv}
vlog -sv -work work +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3 {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/rowmodule.sv}
vlog -sv -work work +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3 {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/font_rom.sv}
vlog -sv -work work +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3 {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/rotation.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_irq_mapper.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_avalon_st_adapter_005_error_adapter_0.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_avalon_st_handshake_clock_crosser.v}
vlog -vlog01compat -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_avalon_st_clock_crosser.v}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_width_adapter.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_burst_uncompressor.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_arbitrator.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_rsp_mux_001.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_rsp_mux.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_rsp_demux_001.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_rsp_demux.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_cmd_mux_001.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_cmd_mux.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_cmd_demux_001.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_cmd_demux.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_burst_adapter.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_burst_adapter_uncmpr.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router_007.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router_003.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router_002.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router_001.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_slave_agent.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_master_agent.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_slave_translator.sv}
vlog -sv -work nios_system +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_master_translator.sv}
vlog -sv -work work +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3 {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/gameboard.sv}
=======
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/nios_system.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_reset_controller.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_reset_synchronizer.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_avalon_st_adapter_005.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_avalon_st_adapter.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_avalon_sc_fifo.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_sysid_qsys_0.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_sdram_pll.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_sdram.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_otg_hpi_data.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_otg_hpi_cs.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_otg_hpi_address.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_onchip_memory2_0.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_nios2_qsys_0.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_nios2_qsys_0_cpu.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_nios2_qsys_0_cpu_debug_slave_sysclk.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_nios2_qsys_0_cpu_debug_slave_tck.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_nios2_qsys_0_cpu_debug_slave_wrapper.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_nios2_qsys_0_cpu_test_bench.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_jtag_uart_0.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_Keycode.v}
vlog -sv -work work +incdir+E:/final/jhutter2rwhale3ab3 {E:/final/jhutter2rwhale3ab3/VGA_controller.sv}
vlog -sv -work work +incdir+E:/final/jhutter2rwhale3ab3 {E:/final/jhutter2rwhale3ab3/lab8.sv}
vlog -sv -work work +incdir+E:/final/jhutter2rwhale3ab3 {E:/final/jhutter2rwhale3ab3/hpi_io_intf.sv}
vlog -sv -work work +incdir+E:/final/jhutter2rwhale3ab3 {E:/final/jhutter2rwhale3ab3/HexDriver.sv}
vlog -sv -work work +incdir+E:/final/jhutter2rwhale3ab3 {E:/final/jhutter2rwhale3ab3/Color_Mapper.sv}
vlog -sv -work work +incdir+E:/final/jhutter2rwhale3ab3 {E:/final/jhutter2rwhale3ab3/square.sv}
vlog -sv -work work +incdir+E:/final/jhutter2rwhale3ab3 {E:/final/jhutter2rwhale3ab3/keycode_state_machine.sv}
vlog -sv -work work +incdir+E:/final/jhutter2rwhale3ab3 {E:/final/jhutter2rwhale3ab3/reg6.sv}
vlog -sv -work work +incdir+E:/final/jhutter2rwhale3ab3 {E:/final/jhutter2rwhale3ab3/shape_generator.sv}
vlog -sv -work work +incdir+E:/final/jhutter2rwhale3ab3 {E:/final/jhutter2rwhale3ab3/reg16.sv}
vlog -sv -work work +incdir+E:/final/jhutter2rwhale3ab3 {E:/final/jhutter2rwhale3ab3/rowmodule.sv}
vlog -sv -work work +incdir+E:/final/jhutter2rwhale3ab3 {E:/final/jhutter2rwhale3ab3/rotation.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_irq_mapper.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_avalon_st_adapter_005_error_adapter_0.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_avalon_st_handshake_clock_crosser.v}
vlog -vlog01compat -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_avalon_st_clock_crosser.v}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_width_adapter.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_burst_uncompressor.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_arbitrator.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_rsp_mux_001.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_rsp_mux.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_rsp_demux_001.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_rsp_demux.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_cmd_mux_001.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_cmd_mux.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_cmd_demux_001.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_cmd_demux.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_burst_adapter.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_burst_adapter_uncmpr.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router_007.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router_003.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router_002.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router_001.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_slave_agent.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_master_agent.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_slave_translator.sv}
vlog -sv -work nios_system +incdir+E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules {E:/final/jhutter2rwhale3ab3/nios_system/synthesis/submodules/altera_merlin_master_translator.sv}
vlog -sv -work work +incdir+E:/final/jhutter2rwhale3ab3 {E:/final/jhutter2rwhale3ab3/gameboard.sv}
>>>>>>> 9b1c6dc1725e0fc6ff297331fa33a15b8a3f133f

vlog -sv -work work +incdir+C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3 {C:/Users/cam82/Desktop/final/jhutter2rwhale3ab3/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L nios_system -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
