import lc3b_types::*;

module wordswap (
    input lc3b_word cpu_sel,
    input cpu_write,
    input lc3b_c_line cpu_datain, mem_datain, cache_line,
    input ctrl_reload,
    output lc3b_c_line out
);

always_comb
begin
    out = cache_line;
    if(ctrl_reload)
        out = mem_datain;
    if(cpu_write) begin
        for(int i=0; i<16; i++) begin
            if(cpu_sel[i])
                out[8*i +: 8] = cpu_datain[8*i +: 8];
        end
    end
end

endmodule : wordswap
