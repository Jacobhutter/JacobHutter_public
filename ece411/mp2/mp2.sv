module mp2(wishbone.master mem);

wishbone cpu_to_cache(mem.CLK);

cpu cpu(cpu_to_cache);

cache cache
(
	 .cpu_to_cache(cpu_to_cache),
	 .cache_to_mem(mem)
);

//comment out the above and connect cpu directly to memory
//to test if your CPU adheres to Wishbone spec
//(not a rigorous test, but will catch some obvious errors)
//cpu cpu(mem);

endmodule : mp2