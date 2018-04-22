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
nop_flag, second_cycle_request, flush, bp_miss, stall, mem_sel;
logic [1:0] ex_sel1, ex_sel2, ex_storesel;
lc3b_offset6 offset6;
lc3b_offset9 offset9;
lc3b_offset11 offset11;
lc3b_reg src1, src2, dest, storemux_out, wb_dest, dest_out, mem_dest, gencc_out, cc_out, destmux_out, src1_out, src2_out;

lc3b_word pcmux_out, pc_plus2_out, br_add_out, alu_out, mem_wdata, adj9_out, ifpc,
idpc, expc, mempc, adj9_out2, adj11_out, adj11_out2, adj6_out, adj6_out2, offsetmux_out, imm5, imm4, imm4_out,
sr1, sr2, sr1_out, sr2_out, offset6_out, offset9_out, offset11_out, imm5_out, trapvect8, trapvect8_out, ex_trapvect8, wb_offset9, wb_offset11, source_data_out, ex_source_data_out, pc_out,
regfilemux_out, alumux_out, ex_alu_out, ex_offset9, ex_offset11, mdrmux_out, marmux_out, wb_alu_out, mem_wdata_out,if_offset6, if_offset9, if_offset11, wordslicemux_out, wordinmux_out,
mem_output, if_offset6_in, ex_sr1mux_out, ex_sr2mux_out, mem_srcmux_out, ex_storemux_out, alubasemux_out, predicted_pc;

lc3b_control_word if_ctrl_initial, if_ctrl, id_ctrl, ex_ctrl, mem_ctrl, wb_ctrl, control_word_out, mem_ctrl_out;

/* Counters */
reg [15:0] i_cache_hits;
reg [15:0] i_cache_misses;
reg [15:0] d_cache_hits;
reg [15:0] d_cache_misses;
reg [15:0] l2_cache_hits;
reg [15:0] l2_cache_misses;
reg [15:0] mispredictions;
reg [15:0] total_branches;
reg [15:0] total_stalls;
logic reset_i_cache_hits;
logic reset_i_cache_misses;
logic reset_d_cache_hits;
logic reset_d_cache_misses;
logic reset_l2_cache_hits;
logic reset_l2_cache_misses;
logic reset_total_branchs;
logic reset_mispredictions;
logic reset_stalls;
lc3b_word mem_rdata_out;

logic [2:0] pcmux_sel, bits4_5_11;
logic [1:0] mbemux_out;
assign instruction_address = pc_out;
assign write_data = mem_wdata;
logic load_regfile;
// Eventually, we'll be able to predict with JSR offset mode
assign load_regfile = (wb_ctrl.load_regfile && advance) ||
    (wb_ctrl.opcode == op_jsr && flush) ||
    (wb_ctrl.opcode == op_trap && flush);
logic icache_request;
assign instruction_request = icache_request & ~flush;
logic load_memaddr;
    /*******************************************************************************
  * PC
******************************************************************************/
register pc
(
	.clk,
	.load(advance | flush), // load on wb demand or fetch
	.in(pcmux_out),
	.out(pc_out)
);

mux8 pcmux
(
	.sel(pcmux_sel),
	.in0(pc_plus2_out),
	.in1(br_add_out),
	.in2(wb_alu_out),
	.in3(mem_wdata_out),
  .in4(predicted_pc),
  .in5(mempc),
  .in6(16'd0),
  .in7(16'd0),
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
	.ctrl(if_ctrl_initial)
);

bp branch_predictor
(
	.clk, /*inputs*/
   .incoming_pc(pc_out),
   .outgoing_pc(mempc),
   .br_add_out,
	.incoming_control_word(if_ctrl_initial),
	.outgoing_control_word(wb_ctrl),
	.branch_enable,
	.incoming_valid_branch(if_ctrl.valid_branch),
	.outgoing_valid_branch(wb_ctrl.valid_branch),
	.outgoing_pcmux_sel(wb_ctrl.pcmux_sel),
	.if_control_word(if_ctrl), /* outputs */
   .predicted_pc,
	.pcmux_sel,
	.flush,
	.bp_miss,
	.stall
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
	.mem_request(icache_request),
    .offset6_out(if_offset6),
	.offset9_out(if_offset9),
	.offset11_out(if_offset11),
	.pc(ifpc),
	.imm5,
	.imm4,
	.trapvect8,
	.ctrl_word_out(id_ctrl),
	.ready(readyifid),
	.flush
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
	.load(load_regfile),
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
    .src1,
    .src2,
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
    .src1_out,
    .src2_out,
	.trapvect8_out,
	.ctrl_word_out(ex_ctrl),
	.ready(readyidex),
	.flush
);

/*******************************************************************************
  * EX Stage
  * do computation
******************************************************************************/

/* data forwarding muxes (snail mail from wb or quick mail from alu forward)*/
mux4 ex_sr1mux
(
    .sel(ex_sel1),
    .a(sr1_out),
    .b(ex_alu_out),
    .c(mem_output),
    .d(regfilemux_out),
    .f(ex_sr1mux_out)
);

mux4 ex_sr2mux
(
    .sel(ex_sel2),
    .a(sr2_out),
    .b(ex_alu_out),
    .c(mem_output),
    .d(regfilemux_out),
    .f(ex_sr2mux_out)
);

mux4 ex_storemux
(
    .sel(ex_storesel),
    .a(sr2_out),
    .b(ex_alu_out),
    .c(mem_output),
    .d(regfilemux_out),
    .f(ex_storemux_out)
);
/*************************/

mux8 alumux
(
    .sel(ex_ctrl.alumux_sel),
	.in0(ex_sr2mux_out),
	.in1(offset6_out),
	.in2(offset9_out),
    .in3(imm5_out),
	.in4(imm4_out),
	.in5(16'd0),
    .in6(16'd0),
    .in7(16'd0),
    .f(alumux_out)
);

mux4 alubasemux
(
    .sel(ex_ctrl.alubasemux_sel),
    .a(ex_sr1mux_out),
    .b(idpc),
    .c(trapvect8_out),
    .d(16'd0),
    .f(alubasemux_out)
);


alu ALU
(
	.aluop(ex_ctrl.aluop),
	.a(alubasemux_out),
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
	.source_data_in(ex_storemux_out),
	.ctrl_word_in(ex_ctrl),
    .load_memaddr,
    .next_memaddr(mem_rdata),
	.pc(expc),
	.ex_alu_out,
	.dest_out(mem_dest),
	.source_data_out(ex_source_data_out),
	.offset9_out(ex_offset9),
	.offset11_out(ex_offset11),
	.trapvect8_out(ex_trapvect8),
	.ctrl_word_out(mem_ctrl),
	.ready(readyexmem),
	.flush
);

/*******************************************************************************
  * MEM Stage
  * call out to memory
******************************************************************************/
/* mem_data forwarding muxes */
//mux4 mem_srcmux
//(
//    .sel(mem_sel),
//    .a(ex_source_data_out),
//    .b(regfilemux_out),
//    .f(mem_srcmux_out)
//);
/*************************/

mem_control mem_ctrl_unit
(
    .clk,
    .advance,
    .mem_control_word(mem_ctrl),
    .src_data(ex_source_data_out),
    .alu_data(ex_alu_out),
    .trapvect8(ex_trapvect8),
    .mem_rdata(mem_rdata_out),
    .data_response,
    .flush,

    .mem_wdata,
    .mem_byte_enable,
    .data_request,
    .mem_address,
    .mem_output,
    .write_enable,
    .load_memaddr,
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
	.dest_in(mem_dest),
	.offset9_in(ex_offset9),
	.offset11_in(ex_offset11),
	.dest_out(wb_dest),
	.wb_alu_out,
	.mem_wdata_out,
	.pc(mempc),
	.offset9_out(wb_offset9),
	.offset11_out(wb_offset11),
	.ctrl_word_out(wb_ctrl),
    .flush
);

MMIO_counters memory_mapped_counters
(
	.i_cache_hits(i_cache_hits),
	.i_cache_misses(i_cache_misses),
	.d_cache_hits(d_cache_hits),
	.d_cache_misses(d_cache_misses),
	.l2_cache_hits(l2_cache_hits),
	.l2_cache_misses(l2_cache_misses),
	.total_branches(total_branches),
	.mispredictions(mispredictions),
	.total_stalls(total_stalls),
	.opcode(mem_ctrl.opcode),
	.mem_address,
	.mem_rdata_in(mem_rdata),

	.reset_i_cache_hits,
	.reset_i_cache_misses,
	.reset_d_cache_hits,
	.reset_d_cache_misses,
	.reset_l2_cache_hits,
	.reset_l2_cache_misses,
	.reset_total_branchs,
	.reset_mispredictions,
	.reset_stalls,
	.mem_rdata_out

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


dataforward dataforward
(
    .ex_dest(dest_out),
    .wb_dest,
    .mem_dest,
    .ex_src1(src1_out),
    .ex_src2(src2_out),
    .mem_valid_dest(mem_ctrl.valid_dest),
    .wb_valid_dest(wb_ctrl.valid_dest),
    .mem_access(mem_ctrl.mem_read | mem_ctrl.mem_write),
    .ex_sel1,
    .ex_sel2,
    .ex_storesel
);

/********************************************/
/*						Counters						  */
/********************************************/

performence_counter i_cache_hits_counter
(
	.clk(clk),
	.trigger(instruction_request & instruction_response & advance),
	.opcode(lc3b_opcode'(instr[15:12])),
	.thresh(16'd0),
	.count(i_cache_hits),
	.cont(1'b1),
	.reset(reset_i_cache_hits)
);

/* Count misses not cycles */
performence_counter i_cache_misses_counter
(
	.clk(clk),
	.trigger(instruction_request & !advance),
	.opcode(lc3b_opcode'(instr[15:12])),
	.thresh(16'd2),
	.count(i_cache_misses),
	.cont(1'b0),
	.reset(reset_i_cache_misses)
);

performence_counter d_cache_hits_counter
(
	.clk(clk),
	.trigger(data_response & data_request & advance),
	.opcode(lc3b_opcode'(instr[15:12])),
	.thresh(16'd0),
	.count(d_cache_hits),
	.cont(1'b1),
	.reset(reset_d_cache_hits)
);

performence_counter d_cache_misses_counter
(
	.clk(clk),
	.trigger(data_request & !advance),
	.pc_in(instruction_address),
	.opcode(lc3b_opcode'(instr[15:12])),
	.thresh(16'd2),
	.count(d_cache_misses),
	.cont(1'b0),
	.reset(reset_d_cache_misses)
);

performence_counter l2_cache_hits_counter
(
	.clk((instruction_request| data_request) & clk),
	.trigger((instruction_response & instruction_request & !advance) | (data_response & data_request & !advance)),
	.opcode(lc3b_opcode'(instr[15:12])),
	.thresh(16'd2),
	.count(l2_cache_hits),
	.cont(1'b0),
	.reset(reset_l2_cache_hits)
);

performence_counter l2_cache_misses_counter
(
	.clk(clk),
	.trigger((instruction_request | data_request) & !advance),
	.opcode(lc3b_opcode'(instr[15:12])),
	.thresh(16'd4),
	.count(l2_cache_misses),
	.cont(1'b0),
	.reset(reset_l2_cache_misses)
);

performence_counter branch_prediction_counter
(
	.clk(clk),
	.trigger(wb_ctrl.valid_branch),
	.opcode(lc3b_opcode'(instr[15:12])),
	.count(total_branches),
	.thresh(16'd0),
	.cont(1'b0),
	.reset(reset_total_branchs)
);

performence_counter mispredictions_counter
(
	.clk(clk),
	.trigger(bp_miss),
	.opcode(lc3b_opcode'(instr[15:12])),
	.count(mispredictions),
	.thresh(16'd0),
	.cont(1'b0),
	.reset(reset_mispredictions)
);

performence_counter stalls_counter
(
	.clk(clk),
	.trigger(stall),
	.opcode(lc3b_opcode'(instr[15:12])),
	.count(total_stalls),
	.thresh(16'd0),
	.cont(1'b1),
	.reset(reset_stalls)
);

always_comb begin
	advance = instruction_response & readymemwb; // when all stages ready, move pipeline along
end

/* Spin (nicely, so we don't chew up cycles) XD */

endmodule : cpu_datapath
