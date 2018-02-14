import lc3b_types::*;

module mp2
(
    wishbone.master wb
);

wishbone wb2(wb.CLK);

cpu Cpu(wb2);

cache Cache(
    .cpu_to_cache(wb2),
    .cache_to_mem(wb)
);

endmodule : mp2
