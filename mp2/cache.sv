import lc3b_types::*;

module cache
(
    wishbone.slave cpu_to_cache,
    wishbone.master cache_to_mem
);

cache_datapath cd();

cache_control cc();

endmodule : cache
