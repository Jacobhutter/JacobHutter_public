import lc3b_types::*;

module cpu_datapath(
  input clk,
  input lc3b_word instr,
  input instruction_response,
  input lc3b_word read_data,
  input data_response,
  output lc3b_word instruction_address,
  output lc3b_word data_address,
  output lc3b_word write_data,
  output logic instruction_request,
  output logic data_request
);

logic load_pc, offsetmux_sel, readyifid, readyidex, readyexmem, readymemwb;
lc3b_offset6 offset6;
lc3b_offset9 offset9;
lc3b_offset11 offset11;
lc3b_reg src1, src2, dest;
lc3b_word pcmux_out, pc_plus2_out, br_add_out, alu_out, mem_wdata, adj9_out, ifpc,
idpc, expc, mempc, adj9_out2, adj11_out, adj11_out2, adj6_out, adj6_out2, offsetmux_out, imm5,
sr1, sr2, dest_out, sr1_out, sr2_out, offset6_out, offset9_out, imm5_out, wb_offset9;
lc3b_sel pcmux_sel;
lc3lc3b_control_word if_ctrl, id_ctrl, ex_ctrl, mem_ctrl, wb_ctrl;

logic [2:0] bits4_5_11;
assign instruction_address = pc_out;

/*******************************************************************************
  * PC
******************************************************************************/
register pc
(
    .clk,
    .load(wb_ctrl.load_pc),
    .in(pcmux_out),
    .out(pc_out)
);

mux4 pcmux
(
    .sel(wb_ctrl.pcmux_sel & branch_enable),
    .a(pc_plus2_out),
    .b(br_add_out),
	.c(alu_out),
	.d(mem_wdata),
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
    br_add_out <= mempc + offsetmux_out;
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
control_rom cr(
    .opcode(lc3b_opcode'(instr[15:12])),
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
    .offset6,
    .offset9,
    .offset11,
    .mem_request(instruction_request),
    .pc(ifpc),
    .imm5,
    .ctrl_word_out(id_ctrl),
    .ready(readyifid),
);

/*******************************************************************************
  * ID/EX Stage
  * get register contents
******************************************************************************/
mux2 storemux
(
    .sel(id_ctrl.storemux_sel),
    .a(src1),
    .b(dest),
    .f(storemux_out)
);

adj #(.width(6)) adj6
(
	.in(offset6),
	.out(adj6_out),
    .out2(adj6_out2)
);

adj #(.width(9)) adj9
(
    .in(offset9),
    .out(adj9_out),
    .out2(adj9_out2)
);

regfile r
(
    .clk,
    .load(wb_ctrl.load_regfile),
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
    .offset6_in(adj6_out),
    .offset9_in(adj9_out),
    .imm5_in(imm5),
    .pc(idpc),
    .dest_out,
    .sr1_out,
    .sr2_out,
    .offset6_out,
    .offset9_out,
    .imm5_out,
    .ctrl_word_out(ex_ctrl),
    .ready(readyidex),
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
    .alu_out,
    .ex_alu_out,
    .ctrl_word_in(ex_ctrl),
    .dest(ex_dest),
    .offset9(ex_offset9),
    .pc(expc),
    .ctrl_word_out(mem_ctrl),
    .ready(readyexmem),
);

/*******************************************************************************
  * MEM/WB Stage
  * call out to memory
******************************************************************************/
mux2 mdrmux
(
    .sel(mem_ctrl.mdrmux_sel),
    .a(ex_alu_out),
    .b(write_data),
    .f(wb_mem_data_in)
);

mux2 marmux
(
    .sel(mem_ctrl.marmux_sel),
    .a(alu_out),
    .b(expc),
    .f(data_address)
);


memwb memwb_register
(
    .clk,
    .advance,
    .pcin(expc)
    .ctrl_word_in(mem_ctrl),
    .wb_alu_in(ex_alu_out)
    .wb_mem_data_in(ex_mem_data),
    .data_request,
    .data_response,
    .write_data,
    .read_data,
    .dest_in(ex_dest),
    .offset9_in(ex_offset9),
    .dest_out(wb_dest),
    .wb_mem_data_out,
    .wb_alu_out,
    .pc(mempc),
    .offset9_out(wb_offset9),
    .ctrl_word_out(wb_ctrl),
    .ready(readymemwb),
);

/*******************************************************************************
  * WB Stage
  * finalize and stabalize values(needs to be done in 1 cycle)
******************************************************************************/
mux2 refgilemux
(
    .sel(wb_ctrl.regfilemux_sel),
    .a(wb_alu_out),
    .b(wb_mem_data_out),
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
    advance <= readyifid & readyidex & readyexmem & readymemwb;
end

endmodule : cpu_datapath
