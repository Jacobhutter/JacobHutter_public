import lc3b_types::*;

module datawrite (
    input ctrl_hit, ctrl_reload,
    input cpu_write,
    input lru_switch, tag_match,
    output write
);

assign write = (ctrl_hit && tag_match && cpu_write) || 
    (ctrl_reload && lru_switch);

endmodule : datawrite