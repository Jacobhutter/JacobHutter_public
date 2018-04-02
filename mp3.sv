module mp3(
    wishbone.master wb_physmem
);

wishbone wb_icache(wb_physmem.CLK);
wishbone wb_dcache(wb_physmem.CLK);
wishbone wb_iconnect(wb_physmem.CLK);
wishbone wb_dconnect(wb_physmem.CLK);
wishbone wb_l2connect(wb_physmem.CLK);

cpu mp3_cpu(
    .ifetch(wb_icache),
    .memory(wb_dcache)
);

cache icache(
	 .wb_cpu(wb_icache),
	 .wb_mem(wb_iconnect)
);

cache dcache(
  .wb_cpu(wb_dcache),
  .wb_mem(wb_dconnect)
);

cache l2cache(
    .wb_cpu(wb_l2connect),
    .wb_mem(wb_physmem)
);

interconnect inter_connect(
    .wb_icache(wb_iconnect),
    .wb_dcache(wb_dconnect),
    .wb_mem(wb_l2connect)
);




endmodule : mp3
