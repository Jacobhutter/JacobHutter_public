import lc3b_types::*;

module cpu
(
    input clk,
    wishbone.master cpu_to_cache

);

logic mem_resp // input
lc3b_word mem_rdata // input
logic mem_read // output
logic mem_write // output
lc3b_mem_wmask mem_byte_enable // output
lc3b_word mem_address // output
lc3b_word mem_wdata // output
assign mem_resp = cpu_to_cache.ACK;
assign mem_rdata = {cpu_to_cache.DAT_S >> mem_address[2:0]}[15:0];
assign cpu_to_cache.STB = mem_read | mem_write;
assign cpu_to_cache.CYC = mem_read | mem_write;
assign cpu_to_cache.WE = mem_write;
assign cpu_to_cache.SEL = 16'{14'd0, mem_byte_enable} << mem_address[2:0];
assign cpu_to_cache.ADR = mem_address;
assign cpu_to_cache.DAT_M = 128'd0; // just for cp1
logic load_pc;
logic load_ir;
logic load_regfile;
logic load_mar;
logic load_mdr;
logic load_cc;
lc3b_sel pcmux_sel;
logic storemux_sel;
logic adj6mux_sel;
lc3b_sel alumux_sel;
lc3b_sel regfilemux_sel;
logic destmux_sel;
lc3b_sel marmux_sel;
lc3b_sel mdrmux_sel;
lc3b_aluop aluop;
lc3b_opcode opcode;
logic branch_enable;
logic immediate;
lc3b_reg base_r;
logic jsr_trigger;
logic a;
logic d;

cpu_datapath Datapath
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
    .adj6mux_sel,
	.destmux_sel,
	.alumux_sel,
	.regfilemux_sel,
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

cpu_control Control
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
    .adj6mux_sel,
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
	/* Memory signals */
	.mem_resp,
	.mem_address,
	.branch_enable,
	.mem_read,
	.mem_write,
	.mem_byte_enable
);

endmodule : cpu
