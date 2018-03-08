import lc3b_types::*;

module cpu_datapath(
  input clk,
  input lc3b_word instr,
  output lc3b_word pc_out
);

logic load_pc, offsetmux_sel;
logic [8:0] offset9;
logic [10:0] offset11;
lc3b_word pcmux_out, pc_plus2_out, br_add_out, alu_out, mem_wdata, adj9_out,
adj9_out2, adj11_out, adj11_out2, offsetmux_out;
lc3b_sel pcmux_sel;


/*******************************************************************************
  * PC
******************************************************************************/
register pc
(
   .clk,
   .load(load_pc),
   .in(pcmux_out),
   .out(pc_out)
);

mux4 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus2_out),
    .b(br_add_out),
	  .c(alu_out),
	  .d(mem_wdata),
    .f(pcmux_out)
);

always_comb
begin
	br_add_out <= pc_out + offsetmux_out;
end

plus2 pc_plus2
(
	.in(pc_out),
	.out(pc_plus2_out)
);

mux2 offsetmux
(
  .sel(offsetmux_sel),
  .a(adj9_out),
  .b(adj11_out),
  .f(offsetmux_out)
);

adj #(.width(9)) adj9
(
	.in(offset9),
	.out(adj9_out),
  .out2(adj9_out2)
);

adj #(.width(11)) adj11
(
	.in(offset11),
	.out(adj11_out),
  .out2(adj11_out2)
);



endmodule : cpu_datapath
