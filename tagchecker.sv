import lc3b_types::*;

module tagchecker (
    input valid0, valid1,
    input lc3b_c_tag tag0, tag1, addr_tag,
    output logic match0, match1,
    output logic cpu_resp
);

assign match0 = valid0 && (tag0 == addr_tag);
assign match1 = valid1 && (tag1 == addr_tag);
assign cpu_resp = match0 || match1;

endmodule : tagchecker
