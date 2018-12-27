import lc3b_types::*;

module cpu
(   wishbone.master cpu_to_cache
);
logic mem_resp; // input
lc3b_word mem_rdata; // input
logic mem_read; // output
logic mem_write; // output
lc3b_mem_wmask mem_byte_enable; // output
lc3b_word mem_address; // output
lc3b_word mem_wdata; // output
logic [15:0] mem_byte_mask;
logic [127:0] raw_dat;
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

always_comb begin
	mem_byte_mask = 16'({8'(signed'(mem_byte_enable[1])), 8'(signed'(mem_byte_enable[0]))});
	mem_resp = cpu_to_cache.ACK;
	raw_dat = cpu_to_cache.DAT_S >> (8 * mem_address[3:0]); // shift input data by offset
	mem_rdata = raw_dat[15:0]; // take bottom 2 bytes
	cpu_to_cache.STB = mem_read | mem_write;
	cpu_to_cache.CYC = mem_read | mem_write;
	cpu_to_cache.WE = mem_write;
	cpu_to_cache.SEL = 16'({14'd0, mem_byte_enable}) << mem_address[3:0];
	cpu_to_cache.ADR = mem_address[15:4];
	cpu_to_cache.DAT_M = 128'({112'd0, mem_wdata & mem_byte_mask}) << (8 * mem_address[3:0]);
end

cpu_datapath Datapath
(
	.clk(cpu_to_cache.CLK),
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
	.clk(cpu_to_cache.CLK),
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