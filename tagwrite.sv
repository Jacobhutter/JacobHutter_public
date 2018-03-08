import lc3b_types::*;

module tagwrite (
    input ctrl_reload,
    input lru_switch,
    input mem_resp,
    output logic write
);

assign write = ctrl_reload & lru_switch & mem_resp;

endmodule : tagwrite
