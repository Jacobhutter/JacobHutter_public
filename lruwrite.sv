import lc3b_types::*;

module lruwrite (
    input ctrl_hit,
    input match0, match1,
    output write
);

assign write = ctrl_hit && (match0 || match1);

endmodule : lruwrite
