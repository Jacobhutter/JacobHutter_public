import lc3b_types::*;

module datapath
(
    input clk,

    /* control signals */
    input load_pc,
	 input load_ir,
	 input load_regfile,
	 input load_mar,
	 input load_mdr,
	 input load_cc,
	 input lc3b_sel pcmux_sel,
	 input storemux_sel,
    input adj6mux_sel,
	 input destmux_sel,
	 input lc3b_sel alumux_sel,
	 input lc3b_sel regfilemux_sel,
	 input lc3b_sel marmux_sel,
	 input lc3b_sel mdrmux_sel,
	 input lc3b_word mem_rdata,
	 input lc3b_aluop aluop,
	 output lc3b_opcode opcode,
	 output logic branch_enable,
	 output lc3b_word mem_address,
	 output lc3b_word mem_wdata,
	 output logic immediate,
	 output logic jsr_trigger,
	 output logic a,
	 output logic d,
	 output lc3b_reg base_r
);

/* declare internal signals */
lc3b_word sr1_out;
lc3b_word sr2_out;
lc3b_word adj6_out;
lc3b_word adj6_out2;
lc3b_word adj6mux_out;
lc3b_word adj9_out;
lc3b_word adj9_out2;
lc3b_word pcmux_out;
lc3b_word alumux_out;
lc3b_word regfilemux_out;
lc3b_word marmux_out;
lc3b_word mdrmux_out;
lc3b_word alu_out;
lc3b_word pc_out;
lc3b_word br_add_out;
lc3b_word pc_plus2_out;
lc3b_word imm4;
lc3b_word imm5;
lc3b_word trapvect8;
lc3b_word mem_rdata_mux_out;


lc3b_reg sr1;
assign base_r = sr1;
lc3b_reg sr2;
lc3b_reg dest;
lc3b_reg storemux_out;
lc3b_reg destmux_out;

lc3b_offset6 offset6;
lc3b_offset9 offset9;

lc3b_nzp gencc_out;
lc3b_nzp cc_out;


/*
 * storemux
 */
mux2 #(.width(3)) storemux
(
	.sel(storemux_sel),
	.a(sr1),
	.b(dest),
	.f(storemux_out)
);


/*
 * PC
 */
mux4 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus2_out),
    .b(br_add_out),
	 .c(alu_out),
	 .d(mem_wdata),
    .f(pcmux_out)
);

register pc
(
    .clk,
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);

plus2 pc_plus2
(
	.in(pc_out),
	.out(pc_plus2_out)
);

always_comb
begin
	br_add_out <= pc_out + adj9_out;
end

adj #(.width(9)) adj9
(
	.in(offset9),
	.out(adj9_out),
    .out2(adj9_out2)
);

ir IR
(
	.clk,
	.load(load_ir),
	.in(mem_wdata),
	.opcode(opcode),
	.dest(dest),
	.src1(sr1),
	.src2(sr2),
	.offset6(offset6),
	.offset9(offset9),
	.immediate,
	.jsr_trigger,
	.a,
	.d,
	.imm4,
	.imm5,
	.trapvect8
);

adj #(.width(6)) adj6
(
	.in(offset6),
	.out(adj6_out),
    .out2(adj6_out2)
);

mux2 adj6mux
(
    .sel(adj6mux_sel),
    .a(adj6_out),
    .b(adj6_out2),
    .f(adj6mux_out)
);

mux4 regfilemux
(
    .sel(regfilemux_sel),
    .a(alu_out),
    .b(mem_wdata),
	 .c(pc_out),
	 .d(br_add_out),
    .f(regfilemux_out)
);

mux2 #(.width(3)) destmux
(
	.sel(destmux_sel),
	.a(dest),
	.b(3'b111),
	.f(destmux_out)
);

regfile r
(
	.clk,
	.load(load_regfile),
	.in(regfilemux_out),
	.src_a(storemux_out),
	.src_b(sr2),
	.dest(destmux_out),
	.reg_a(sr1_out),
	.reg_b(sr2_out)
);

mux4 alumux
(
    .sel(alumux_sel),
    .a(sr2_out),
    .b(adj6mux_out),
	 .c(imm5),
	 .d(imm4),
    .f(alumux_out)
);

alu ALU
(
	.aluop(aluop),
	.a(sr1_out),
	.b(alumux_out),
	.f(alu_out)
);

gencc Gencc
(
	.in(regfilemux_out),
	.out(gencc_out)
);

register #(.width(3)) CC
(
	.clk,
	.load(load_cc),
	.in(gencc_out),
	.out(cc_out)
);

cccomp CCCOMP
(
	.cc(cc_out),
	.dest(dest),
	.branch_enable(branch_enable)
);

mux2 mem_rdata_mux
(
	.sel(mem_address[0]),
	.a(16'({8'd0, mem_rdata[7:0]})),
	.b(16'({8'd0, mem_rdata[15:8]})),
	.f(mem_rdata_mux_out)
);

mux4 mdrmux
(
	.sel(mdrmux_sel),
	.a(alu_out),
	.b(mem_rdata),
   .c(16'({8'd0, alu_out[7:0]})),
   .d(mem_rdata_mux_out),
	.f(mdrmux_out)
);

mux4 marmux
(
	.sel(marmux_sel),
	.a(alu_out),
	.b(pc_out),
	.c(trapvect8),
	.d(mem_wdata),
	.f(marmux_out)
);

register MDR
(
	.clk,
	.load(load_mdr),
	.in(mdrmux_out),
	.out(mem_wdata)
);

register MAR
(
	.clk,
	.load(load_mar),
	.in(marmux_out),
	.out(mem_address)
);

endmodule : datapath
