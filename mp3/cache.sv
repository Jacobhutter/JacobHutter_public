import lc3b_types::*;

module cache (
    wishbone.slave wb_cpu,
    wishbone.master wb_mem
);

logic clk;
logic cache_lru; 
logic [1:0] cache_dirty;
logic ctrl_hit, ctrl_write, ctrl_reload;
lc3b_word cpu_address, cpu_datain, cpu_dataout, mem_address;
logic [1:0] cpu_wmask;
logic cpu_read, cpu_write;

always_comb
begin
    clk = wb_cpu.CLK;
    cpu_address = wb_cpu.ADR << 4;
    cpu_datain = 0;
    cpu_wmask = 0;
    for(int i=0; i<8; i++) begin
        if(wb_cpu.SEL[2*i]) begin
            cpu_datain[7:0] = wb_cpu.DAT_M[16*i +: 8];
            cpu_wmask[0] = 1'b1;
            cpu_address[3:0] = (i << 1);
        end
        if(wb_cpu.SEL[2*i+1]) begin
            cpu_datain[15:8] = wb_cpu.DAT_M[16*i+8 +: 8];
            cpu_wmask[1] = 1'b1;
            cpu_address[3:0] = (i << 1);
        end
    end
    cpu_read = 0;
    cpu_write = 0;
    if(wb_cpu.STB && wb_cpu.WE)
        cpu_write = 1'b1;
    else if(wb_cpu.STB)
        cpu_read = 1'b1;
    
    wb_mem.ADR = mem_address[15:4];
    wb_mem.SEL = {16{1'b1}};
    /* Deal with later? */
    wb_cpu.RTY = 1'b0;
    wb_mem.CYC = wb_mem.STB;
end

cache_control cache_ctrl (
    .clk,
    .cpu_resp(wb_cpu.ACK),
    .cpu_strobe(wb_cpu.STB),
    .cache_lru,
    .cache_dirty,
    .ctrl_hit,
    .ctrl_write,
    .ctrl_reload,
    .mem_resp(wb_mem.ACK),
    .mem_we(wb_mem.WE),
    .mem_strobe(wb_mem.STB),
    .cpu_write
);

cache_datapath cache_dpth (
    .clk,
    .ctrl_reload,
    .ctrl_write,
    .ctrl_hit,
    .lru_out(cache_lru),
    .dirty_out(cache_dirty),
    .cpu_address,
    .cpu_datain,
    .cpu_read,
    .cpu_write,
    .cpu_wmask,
    .cpu_resp(wb_cpu.ACK),
    .cpu_dataout(wb_cpu.DAT_S),
    .mem_datain(wb_mem.DAT_S),
    .mem_resp(wb_mem.ACK),
    .mem_address,
    .mem_dataout(wb_mem.DAT_M)

);

endmodule : cache
