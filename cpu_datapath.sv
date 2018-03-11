import lc3b_types::*;

module cpu_datapath(
  input clk,
  input lc3b_word instr,
  input instruction_response,
  input lc3b_word mem_rdata,
  input data_response,

  output lc3b_word instruction_address,
  output lc3b_word mem_address,
  output lc3b_word write_data,
  output logic instruction_request,
  output logic data_request,
  output logic write_enable
);

logic load_pc, load_mar, load_mdr, advance, readyifid, readyidex, readyexmem, readymemwb, force_dest, branch_enable, nop_flag;
lc3b_offset6 offset6;
lc3b_offset9 offset9;
lc3b_offset11 offset11;
lc3b_opcode input_opcode;
lc3b_reg src1, src2, dest, storemux_out, wb_dest, dest_out, ex_dest, gencc_out, cc_out;

lc3b_word pcmux_out, pc_plus2_out, br_add_out, alu_out, mem_wdata, adj9_out, ifpc,
idpc, expc, mempc, adj9_out2, adj11_out, adj11_out2, adj6_out, adj6_out2, offsetmux_out, imm5,
sr1, sr2, sr1_out, sr2_out, offset6_out, offset9_out, imm5_out, wb_offset9, source_data_out, ex_source_data_out, pc_out,
regfilemux_out, alumux_out, ex_alu_out, ex_offset9, mdrmux_out, marmux_out, wb_alu_out, mem_wdata_out,if_offset6, if_offset9;

lc3b_control_word if_ctrl, id_ctrl, ex_ctrl, mem_ctrl, wb_ctrl, control_word_out;

logic [2:0] bits4_5_11;
assign instruction_address = pc_out;
assign write_data = mem_wdata;
assign write_enable = wb_ctrl.mem_write;
assign data_request = mem_ctrl.mem_read | mem_ctrl.mem_write;
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

mux2 pcmux
(
    .sel(wb_ctrl.pcmux_sel & branch_enable),
    .a(pc_plus2_out),
    .b(br_add_out),
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
    .b(adj11_out),
    .f(offsetmux_out)
);

always_comb
begin
    br_add_out = mempc + offsetmux_out + 2;
end

adj #(.width(11)) adj11
(
	.in(offset11),
	.out(adj11_out),
  .out2(adj11_out2)
);

/*******************************************************************************
  * IF/ID Stage
  * pc+2, fetch data, build control word
******************************************************************************/
always_comb begin
	if(instr == 16'd0) begin
		input_opcode = lc3b_opcode'({1'b1,1'b1,1'b1,1'b1});
		nop_flag = 1;
	end
	else begin
		input_opcode = lc3b_opcode'(instr[15:12]);
		nop_flag = 0;
	end
end

control_rom cr(
    .opcode(input_opcode),
    .bits4_5_11(3'({instr[4], instr[5], instr[11]})),
    .ctrl(if_ctrl)
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
    .offset6_in(adj6_out),
    .offset9_in(adj9_out),
    .offset11,
    .mem_request(instruction_request),
    .load_pc,
	 .offset6_out(if_offset6),
    .offset9_out(if_offset9),
    .pc(ifpc),
    .imm5,
    .ctrl_word_out(id_ctrl),
    .ready(readyifid)
);

/*******************************************************************************
  * ID/EX Stage
  * get register contents
******************************************************************************/
mux2 #(.width(3)) storemux
(
    .sel(id_ctrl.storemux_sel | force_dest),
    .a(src1),
    .b(dest),
    .f(storemux_out)
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

regfile r
(
    .clk,
    .load(wb_ctrl.load_regfile & advance),
    .in(regfilemux_out),
    .src_a(storemux_out),
    .src_b(src2),
    .dest(wb_dest),
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
    .source_data_in(sr1),
    .offset6_in(if_offset6),
    .offset9_in(if_offset9),
    .imm5_in(imm5),
    .pc(idpc),
    .force_dest,
    .dest_out,
    .sr1_out,
    .sr2_out,
	 .source_data_out,
    .offset6_out,
    .offset9_out,
    .imm5_out,
    .ctrl_word_out(ex_ctrl),
    .ready(readyidex)
);

/*******************************************************************************
  * EX/MEM Stage
  * do computation
******************************************************************************/
mux2 alumux
(
    .sel(ex_ctrl.alumux_sel),
    .a(sr2_out),
    .b(offset6_out),
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
    .source_data_in(source_data_out),
    .ctrl_word_in(ex_ctrl),
    .pc(expc),
    .ex_alu_out,
    .dest_out(ex_dest),
    .source_data_out(ex_source_data_out),
    .offset9_out(ex_offset9),
    .ctrl_word_out(mem_ctrl),
    .ready(readyexmem)
);

/*******************************************************************************
  * MEM/WB Stage
  * call out to memory
******************************************************************************/
mux2 mdrmux
(
    .sel(mem_ctrl.mdrmux_sel),
    .a(ex_source_data_out),
    .b(mem_rdata),
    .f(mdrmux_out)
);

mux2 marmux
(
    .sel(mem_ctrl.marmux_sel),
    .a(ex_alu_out),
    .b(mempc),
    .f(marmux_out)
);

register MDR
(
    .clk,
    .load(mem_ctrl.mem_read | mem_ctrl.mem_write),
    .in(mdrmux_out),
    .out(mem_wdata)
);

register MAR
(
    .clk,
    .load(mem_ctrl.mem_read),
    .in(marmux_out),
    .out(mem_address)
);


memwb memwb_register
(
    .clk,
    .advance,
    .pc_in(expc),
    .ctrl_word_in(mem_ctrl),
    .wb_alu_in(ex_alu_out),
	 .mem_wdata_in(mem_wdata),
    //.data_request,
	 .load_mar,
	 .load_mdr,
    .data_response,
    .dest_in(ex_dest),
    .offset9_in(ex_offset9),
    .dest_out(wb_dest),
    .wb_alu_out,
	 .mem_wdata_out,
    .pc(mempc),
    .offset9_out(wb_offset9),
    .ctrl_word_out(wb_ctrl),
    .ready(readymemwb)
);

/*******************************************************************************
  * WB Stage
  * finalize and stabalize values(needs to be done in 1 cycle)
******************************************************************************/
mux2 regfilemux
(
    .sel(wb_ctrl.regfilemux_sel),
    .a(wb_alu_out),
    .b(mem_wdata_out),
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

endmodule : cpu_datapath
