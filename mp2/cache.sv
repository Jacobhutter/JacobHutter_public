import lc3b_types::*;

module cache
(
    wishbone.slave cpu_to_cache,
    wishbone.master cache_to_mem
);

logic hit;
logic dirty;
logic cache_in_mux_sel;
logic control_load;
lc3b_c_line cd_data_in;
logic [127:0] data_out;
logic [127:0] full_mask, cpu_to_cache_data;
logic [15:0] data_out_mux_out;
logic lru_load;

always_comb begin
	cache_to_mem.DAT_M = data_out;
   cache_to_mem.SEL = 16'b1111111111111111;
   cache_to_mem.ADR = cpu_to_cache.ADR;
	cpu_to_cache.DAT_S = data_out & full_mask; // excise word
   full_mask = 128'({8'(signed'(cpu_to_cache.SEL[15])), 8'(signed'(cpu_to_cache.SEL[14])),
   8'(signed'(cpu_to_cache.SEL[13])), 8'(signed'(cpu_to_cache.SEL[12])), 8'(signed'(cpu_to_cache.SEL[11])),
   8'(signed'(cpu_to_cache.SEL[10])), 8'(signed'(cpu_to_cache.SEL[9])), 8'(signed'(cpu_to_cache.SEL[8])),
   8'(signed'(cpu_to_cache.SEL[7])), 8'(signed'(cpu_to_cache.SEL[6])), 8'(signed'(cpu_to_cache.SEL[5])),
   8'(signed'(cpu_to_cache.SEL[4])), 8'(signed'(cpu_to_cache.SEL[3])), 8'(signed'(cpu_to_cache.SEL[2])),
   8'(signed'(cpu_to_cache.SEL[1])), 8'(signed'(cpu_to_cache.SEL[0]))});
   cpu_to_cache_data = (data_out & ~full_mask) + cpu_to_cache.DAT_M;
end

mux2 #(.width(128)) cache_in_mux
(
    .sel(cache_in_mux_sel),
	.a(cpu_to_cache_data),
	.b(cache_to_mem.DAT_S),
	.f(cd_data_in)
);

cache_datapath cd
(
  .clk(cpu_to_cache.CLK),
  .address(cpu_to_cache.ADR),
  .data_in(cd_data_in),
  .write_enable(cpu_to_cache.WE),
  .hit,
  .data_out(data_out),
  .dirty,
  .control_load,
  .lru_load
);

cache_control cc
(
  .clk(cpu_to_cache.CLK),
  .write_enable(cpu_to_cache.WE),
  .hit,
  .dirty,
  .stb(cpu_to_cache.STB),
  .ack_in(cache_to_mem.ACK),
  .cache_in_mux_sel,
  .ack_out(cpu_to_cache.ACK),
  .stb_out(cache_to_mem.STB),
  .cyc_out(cache_to_mem.CYC),
  .we_out(cache_to_mem.WE),
  .control_load,
  .lru_load
);

endmodule : cache
