import lc3b_types::*;

module cache4 (
    wishbone.slave wb_cpu,
    wishbone.master wb_mem
);

logic clk;
logic ctrl_hit, ctrl_write, ctrl_reload;
logic need_writeback;
lc3b_word mem_address;
logic [11:0] wb_addr_reg;
logic cpu_read, cpu_write;

always_ff @(posedge wb_cpu.CLK)
begin
    wb_addr_reg <= mem_address[15:4];
end

always_comb
begin
    clk = wb_cpu.CLK;
    cpu_read = 0;
    cpu_write = 0;
    if(wb_cpu.STB && wb_cpu.WE)
        cpu_write = 1'b1;
    else if(wb_cpu.STB)
        cpu_read = 1'b1;
    
    wb_mem.ADR = wb_addr_reg;
    wb_mem.SEL = {16{1'b1}};
    /* Deal with later? */
    wb_cpu.RTY = 1'b0;
    wb_mem.CYC = wb_mem.STB;
end

cache4_control cache_ctrl (
    .clk,
    .cpu_resp(wb_cpu.ACK),
    .cpu_strobe(wb_cpu.STB),
    .need_writeback,
    .ctrl_hit,
    .ctrl_write,
    .ctrl_reload,
    .mem_resp(wb_mem.ACK),
    .mem_we(wb_mem.WE),
    .mem_strobe(wb_mem.STB),
    .cpu_write
);

cache4_datapath cache_dpth (
    .clk,
    .ctrl_reload,
    .ctrl_write,
    .ctrl_hit,
    .need_writeback,
    .cpu_address({wb_cpu.ADR, 4'd0}),
    .cpu_sel(wb_cpu.SEL),
    .cpu_datain(wb_cpu.DAT_M),
    .cpu_read,
    .cpu_write,
    .cpu_resp(wb_cpu.ACK),
    .cpu_dataout(wb_cpu.DAT_S),
    .mem_datain(wb_mem.DAT_S),
    .mem_resp(wb_mem.ACK),
    .mem_address,
    .mem_dataout(wb_mem.DAT_M)

);

endmodule : cache4
