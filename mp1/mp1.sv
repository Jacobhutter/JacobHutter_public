import lc3b_types::*;

module mp1
(
    input clk,

    /* Memory signals */
    input mem_resp,
    input lc3b_word mem_rdata,
    output logic mem_read,
    output logic mem_write,
    output lc3b_mem_wmask mem_byte_enable,
    output lc3b_word mem_address,
    output lc3b_word mem_wdata
);

logic load_pc;
logic load_ir;
logic load_regfile;
logic load_mar;
logic load_mdr;
logic load_cc;
lc3b_sel pcmux_sel;
logic storemux_sel;
lc3b_sel alumux_sel;
lc3b_sel regfilemux_sel;
logic destmux_sel;
lc3b_sel marmux_sel;
logic mdrmux_sel;
lc3b_aluop aluop;
lc3b_opcode opcode;
logic branch_enable;
logic immediate;
lc3b_reg base_r;
logic jsr_trigger;
logic mem_wdata_mux_sel;
logic a;
logic d;

datapath Datapath
(
	.clk,
   .load_pc,
	.load_ir,
	.load_regfile,
	.load_mar,
	.load_mdr,
	.load_cc,
	.pcmux_sel,
	.storemux_sel,
	.destmux_sel,
	.alumux_sel,
	.regfilemux_sel,
	.mem_wdata_mux_sel,
	.marmux_sel,
	.mdrmux_sel,
	.mem_rdata,
	.aluop,
	.opcode,
	.branch_enable,
	.mem_address,
	.mem_wdata,
	.immediate,
	.base_r,
	.a,
	.d,
	.jsr_trigger
);

control Control
(
	.clk,
	.opcode, 
	.load_pc,
	.load_ir,
	.load_regfile, 
	.aluop, 
	.load_mar,
	.load_mdr,
	.load_cc,
	.pcmux_sel,
	.storemux_sel,
	.destmux_sel,
	.alumux_sel,
	.regfilemux_sel,
	.marmux_sel,
	.mdrmux_sel,
	.immediate,
	.base_r,
	.jsr_trigger,
	.a,
	.d,
	.mem_wdata_mux_sel,
	/* Memory signals */ 
	.mem_resp, 
	.branch_enable,
	.mem_read, 
	.mem_write, 
	.mem_byte_enable
);

endmodule : mp1
