import lc3b_types::*;

module mp2
(
    wishbone.master wb
);

wishbone wishb(wb.CLK);

cpu cpu_master(
	.clk(wishb.CLK),
	.cpu_to_cache(wishb)
);

cache Cache(
    .cpu_to_cache(wishb),
    .cache_to_mem(wb)
);

endmodule : mp2
