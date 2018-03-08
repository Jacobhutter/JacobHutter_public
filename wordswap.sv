import lc3b_types::*;

module wordswap (
    input lc3b_c_offset cpu_offset,
    input [1:0] cpu_wmask, 
    input cpu_write,
    input lc3b_word cpu_datain,
    input lc3b_c_line mem_datain, cache_line,
    input ctrl_reload,
    output lc3b_c_line out
);

always_comb
begin
    out = cache_line;
    if(ctrl_reload)
        out = mem_datain;
    if(cpu_write) begin
        for(int i=0; i<8; i++) begin
            if(cpu_offset[3:1] == i && cpu_wmask[0])
                out[16*i +: 8] = cpu_datain[7:0];
            if(cpu_offset[3:1] == i && cpu_wmask[1])
                out[16*i+8 +: 8] = cpu_datain[15:8];
        end
    end
end

endmodule : wordswap
