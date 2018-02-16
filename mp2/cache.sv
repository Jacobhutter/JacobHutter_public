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

always_comb begin
  cache_to_mem.ADR = cpu_to_cache.ADR & 16'hFFF8; // eliminate offset
end

mux2 cache_in_mux
(
  .sel(cache_in_mux_sel),
	.a(cpu_to_cache.DAT_M),
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
  .data_out(cpu_to_cache.DAT_S),
  .dirty,
  .control_load
);

cache_control cc
(
  .clk(cpu_to_cache.CLK),
  .hit,
  .dirty,
  .stb(cpu_to_cache.STB),
  .ack_in(cache_to_mem.ACK),
  .cache_in_mux_sel,
  .ack_out(cpu_to_cache.ACK),
  .stb_out(cache_to_mem.STB),
  .we_out(cache_to_mem.WE),
  .control_load
);

endmodule : cache
