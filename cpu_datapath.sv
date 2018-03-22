import lc3b_types::*;

module cpu_datapath(
  input clk,
  input lc3b_word instr,
  input instruction_response,
  input lc3b_word mem_rdata,
  input data_response,

  output lc3b_word instruction_address,
  output logic [1:0] mem_byte_enable,
  output lc3b_word mem_address,
  output lc3b_word write_data,
  output logic instruction_request,
  output logic data_request,
  output logic write_enable
);

logic load_pc, advance, readyifid, readyidex, readyexmem, readymemwb, force_dest, branch_enable,
nop_flag, second_cycle_request, branch_taken;
lc3b_offset6 offset6;
lc3b_offset9 offset9;
lc3b_offset11 offset11;
lc3b_reg src1, src2, dest, storemux_out, wb_dest, dest_out, ex_dest, gencc_out, cc_out, destmux_out;

lc3b_word pcmux_out, pc_plus2_out, br_add_out, alu_out, mem_wdata, adj9_out, ifpc,
idpc, expc, mempc, adj9_out2, adj11_out, adj11_out2, adj6_out, adj6_out2, offsetmux_out, imm5, imm4, imm4_out,
sr1, sr2, sr1_out, sr2_out, offset6_out, offset9_out, offset11_out, imm5_out, trapvect8, trapvect8_out, ex_trapvect8, wb_offset9, wb_offset11, source_data_out, ex_source_data_out, pc_out,
regfilemux_out, alumux_out, ex_alu_out, ex_offset9, ex_offset11, mdrmux_out, marmux_out, wb_alu_out, mem_wdata_out,if_offset6, if_offset9, if_offset11, wordslicemux_out, wordinmux_out,
mem_output, if_offset6_in;

lc3b_control_word if_ctrl, id_ctrl, ex_ctrl, mem_ctrl, wb_ctrl, control_word_out, mem_ctrl_out;

logic [2:0] bits4_5_11;
logic [1:0] pcmux_sel, mbemux_out;
assign instruction_address = pc_out;
assign write_data = mem_wdata;
/*******************************************************************************
  * PC
******************************************************************************/
register pc
(
	.clk,
	.load(advance), // load on wb demand or fetch
	.in(pcmux_out),
	.out(pc_out)
);

always_comb begin
	if (wb_ctrl.pcmux_sel == 2'b01 && branch_enable == 0 && wb_ctrl.opcode == op_br)
		pcmux_sel = 2'b00; // branch not taken
	else
		pcmux_sel = wb_ctrl.pcmux_sel;
		
	if (wb_ctrl.opcode == op_br && branch_enable == 1)
		branch_taken = 1'b1;
	else
		branch_taken = 1'b0;
end

mux4 pcmux
(
	.sel(pcmux_sel),
	.a(pc_plus2_out),
	.b(br_add_out),
	.c(wb_alu_out),
	.d(mem_wdata_out),
	.f(pcmux_out)
);

plus2 pc_plus2
(
	.in(pc_out),
	.out(pc_plus2_out)
);

mux2 offsetmux
(
	.sel(wb_ctrl.offsetmux_sel),
	.a(wb_offset9),
	.b(wb_offset11),
	.f(offsetmux_out)
);

always_comb
begin
	br_add_out = mempc + offsetmux_out;
end

adj #(.width(11)) adj11
(
	.in(instr[10:0]),
	.out(adj11_out),
    .out2(adj11_out2)
);

adj #(.width(6)) adj6
(
	.in(instr[5:0]),
	.out(adj6_out),
    .out2(adj6_out2)
);

adj #(.width(9)) adj9
(
	.in(instr[8:0]),
	.out(adj9_out),
	.out2(adj9_out2)
);

/*******************************************************************************
  * IF Stage
  * load_pc, fetch data, build control word
******************************************************************************/
control_rom cr(
	.opcode(lc3b_opcode'(instr[15:12])),
	.bits4_5_11(3'({instr[11], instr[5], instr[4]})),
	.ctrl(if_ctrl)
);

mux2 #(.width(16)) offset6mux(
    .sel(if_ctrl.offset6mux_sel),
    .a(adj6_out),
    .b(adj6_out2),
    .f(if_offset6_in)
);

ifid ifid_register
(
	.clk,
	.advance,
	.mem_resp(instruction_response),
	.instr,
	.pc_in(pc_out),
	.ctrl_word_in(if_ctrl),
	.dest,
	.src1,
	.src2,
	.offset6_in(if_offset6_in),
	.offset9_in(adj9_out),
	.offset11_in(adj11_out),
	.mem_request(instruction_request),
    .offset6_out(if_offset6),
	.offset9_out(if_offset9),
	.offset11_out(if_offset11),
	.pc(ifpc),
	.imm5,
	.imm4,
	.trapvect8,
	.ctrl_word_out(id_ctrl),
	.ready(readyifid),
	.flush(branch_taken)
);

/*******************************************************************************
  * ID Stage
  * get register contents
******************************************************************************/
mux2 #(.width(3)) storemux
(
	.sel(id_ctrl.storemux_sel),
	.a(src2),
	.b(dest),
	.f(storemux_out)
);

mux2 #(.width(3)) destmux
(
	.sel(wb_ctrl.destmux_sel),
	.a(wb_dest),
	.b(3'b111),
	.f(destmux_out)
);

regfile r
(
	.clk,
	.load(wb_ctrl.load_regfile & advance),
	.in(regfilemux_out),
	.src_a(src1),
	.src_b(storemux_out),
	.dest(destmux_out),
	.reg_a(sr1),
	.reg_b(sr2)
);

idex idex_register
(
	.clk,
	.advance,
	.pc_in(ifpc),
	.ctrl_word_in(id_ctrl),
	.dest_in(dest),
	.sr1_in(sr1),
	.sr2_in(sr2),
	.offset6_in(if_offset6),
	.offset9_in(if_offset9),
	.offset11_in(if_offset11),
	.imm5_in(imm5),
	.imm4_in(imm4),
	.trapvect8_in(trapvect8),
	.pc(idpc),
	.dest_out,
	.sr1_out,
	.sr2_out,
	.offset6_out,
	.offset9_out,
	.offset11_out,
	.imm5_out,
	.imm4_out,
	.trapvect8_out,
	.ctrl_word_out(ex_ctrl),
	.ready(readyidex),
	.flush(branch_taken)
);

/*******************************************************************************
  * EX Stage
  * do computation
******************************************************************************/
mux4 alumux
(
	.sel(ex_ctrl.alumux_sel),
	.a(sr2_out),
	.b(offset6_out),
	.c(imm5_out),
	.d(imm4_out),
	.f(alumux_out)
);


alu ALU
(
	.aluop(ex_ctrl.aluop),
	.a(sr1_out),
	.b(alumux_out),
	.f(alu_out)
);

exmem exmem_register
(
	.clk,
	.advance,
	.pc_in(idpc),
	.ex_alu_in(alu_out),
	.dest_in(dest_out),
	.offset9_in(offset9_out),
	.offset11_in(offset11_out),
	.trapvect8_in(trapvect8_out),
	.source_data_in(sr2_out),
	.ctrl_word_in(ex_ctrl),
	.pc(expc),
	.ex_alu_out,
	.dest_out(ex_dest),
	.source_data_out(ex_source_data_out),
	.offset9_out(ex_offset9),
	.offset11_out(ex_offset11),
	.trapvect8_out(ex_trapvect8),
	.ctrl_word_out(mem_ctrl),
	.ready(readyexmem),
	.flush(branch_taken)
);

/*******************************************************************************
  * MEM Stage
  * call out to memory
******************************************************************************/

mem_control mem_ctrl_unit
(
    .clk,
    .advance,
    .mem_control_word(mem_ctrl),
    .src_data(ex_source_data_out),
    .alu_data(ex_alu_out),
    .trapvect8(ex_trapvect8),
    .mem_rdata,
    .data_response,
    
    .mem_wdata,
    .mem_byte_enable,
    .data_request,
    .mem_address,
    .mem_output,
    .write_enable,
    .ready(readymemwb)
);

memwb memwb_register
(
	.clk,
	.advance,
	.pc_in(expc),
	.ctrl_word_in(mem_ctrl),
	.wb_alu_in(ex_alu_out),
	.mem_wdata_in(mem_output),
	.dest_in(ex_dest),
	.offset9_in(ex_offset9),
	.offset11_in(ex_offset11),
	.dest_out(wb_dest),
	.wb_alu_out,
	.mem_wdata_out,
	.pc(mempc),
	.offset9_out(wb_offset9),
	.offset11_out(wb_offset11),
	.ctrl_word_out(wb_ctrl)
);

/*******************************************************************************
  * WB Stage
  * finalize and stabalize values(needs to be done in 1 cycle)
******************************************************************************/
mux4 regfilemux
(
	.sel(wb_ctrl.regfilemux_sel),
	.a(wb_alu_out),
	.b(mem_wdata_out),
	.c(mempc),
	.d(br_add_out),
	.f(regfilemux_out)
);

gencc Gencc
(
	.in(regfilemux_out),
   .out(gencc_out)
);

register #(.width(3)) CC
(
	.clk,
	.load(wb_ctrl.load_cc),
	.in(gencc_out),
	.out(cc_out)
);

cccomp CCCOMP
(
	.cc(cc_out),
	.dest(wb_dest),
	.branch_enable(branch_enable)
);

always_comb begin
	advance = readyifid & readyidex & readyexmem & readymemwb; // when all stages ready, move pipeline along
end

/* Spin (nicely, so we don't chew up cycles) XD */

endmodule : cpu_datapath
