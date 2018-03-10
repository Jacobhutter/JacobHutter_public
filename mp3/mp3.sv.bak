module mp3(
    wishbone.master l,
    wishbone.master Ifetch,
);

wishbone cpu_to_instr(Ifetch.CLK);

wishbone cpu_to_d(l.CLK);

wishbone d_to_l(l.CLK)

cpu cpu(
    .instructions(cpu_to_instr),
    .data(cpu_to_d)
);

cache Icache(
	 .cpu_to_cache(cpu_to_instr),
	 .cache_to_mem(Ifetch)
);

cache Dcache(
  .cpu_to_cache(cpu_to_d),
  .cache_to_mem(d_to_l)
);

cache Lcache(
	 .cpu_to_cache(d_to_l),
	 .cache_to_mem(l)
);

endmodule : mp3
