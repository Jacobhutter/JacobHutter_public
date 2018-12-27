import lc3b_types::*;

module swapaddress (
    input ctrl_write,
    input lc3b_word cpu_addr,
    input lru_switch,
    input lc3b_c_tag tag0, tag1,
    output lc3b_word mem_addr

);

always_comb
begin
    mem_addr = cpu_addr;
    if(ctrl_write && ~lru_switch)
        mem_addr = {tag0, cpu_addr[6:0]};
    else if(ctrl_write && lru_switch)
        mem_addr = {tag1, cpu_addr[6:0]};
end

endmodule : swapaddress