import lc3b_types::*;

module tagchecker4 (
    input valid,
    input lc3b_c_tag cache_tag, addr_tag,
    output logic match
);

assign match = valid && (cache_tag == addr_tag);

endmodule : tagchecker4