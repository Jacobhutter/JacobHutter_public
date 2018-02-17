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
logic [2:0] offset;
logic [127:0] data_out;
logic [15:0] data_out_mux_out;

always_comb begin
	offset = cpu_to_cache.ADR[2:0];
   cache_to_mem.ADR = cpu_to_cache.ADR & 16'hFFF8; // eliminate offset
	cpu_to_cache.DAT_S = {112'd0, data_out_mux_out};
end

mux8 #(.width(16)) data_out_mux
(
	.sel(offset),
	.a(data_out[15:0]),
	.b(data_out[31:16]),
	.c(data_out[47:32]),
	.d(data_out[63:48]),
	.e(data_out[79:64]),
	.g(data_out[95:80]),
	.h(data_out[111:96]),
	.i(data_out[127:112]),
	.f(data_out_mux_out)
);

mux2 #(.width(128)) cache_in_mux
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
  .data_out(data_out),
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
  .cyc_out(cache_to_mem.CYC),
  .we_out(cache_to_mem.WE),
  .control_load
);

endmodule : cache
