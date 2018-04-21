import lc3b_types::*;

module swapaddress4 (
    input ctrl_write,
    input lc3b_word cpu_addr,
    input lru_sel,
    input lc3b_c_tag tag,
    output lc3b_word mem_addr
);

always_comb
begin
    mem_addr = 0;
    if(ctrl_write && lru_sel)
        mem_addr = {tag, cpu_addr[6:0]};
    else if(lru_sel)
        mem_addr = cpu_addr;
end

endmodule : swapaddress4