import lc3b_types::*;

module dirtywrite (
    input ctrl_hit, ctrl_reload,
    input lru_switch, tag_match,
    input cpu_write,
    output write
);

assign write = (ctrl_hit && cpu_write && tag_match) || (ctrl_reload && lru_switch);

endmodule : dirtywrite