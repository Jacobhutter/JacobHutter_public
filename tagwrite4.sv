import lc3b_types::*;

module tagwrite4 (
    input lru_sel,
    input ctrl_reload,
    input mem_resp,
    output logic write
);

always_comb
begin
    write = 0;
    if(ctrl_reload && mem_resp)
        write = lru_sel;
end


endmodule : tagwrite4