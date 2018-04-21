import lc3b_types::*;

module bp(
	input clk,
	input lc3b_word incoming_pc,
	input lc3b_word outgoing_pc,
	input lc3b_word br_add_out,
	input lc3b_control_word incoming_control_word,
	input lc3b_control_word outgoing_control_word,
	input branch_enable,
	input incoming_valid_branch,
	input outgoing_valid_branch,
	input logic [1:0] outgoing_pcmux_sel,

	output lc3b_control_word if_control_word,
	output lc3b_word predicted_pc,
	output logic [2:0] pcmux_sel,
	output logic flush,
	output logic bp_miss,
	output logic stall
);
logic miss, wb_should_branch, wb_predict;
lc3b_word target_addr_out;

assign wb_should_branch = branch_enable || outgoing_control_word.opcode == op_trap || 
		outgoing_control_word.opcode == op_jsr || outgoing_control_word.opcode == op_jmp;
assign wb_predict = outgoing_control_word.predicted_branch;
		
		
mux2 target_addr_mux
(
		.a(incoming_pc),
		.b(outgoing_pc - 2),
		.sel(outgoing_valid_branch),
		.f(target_addr_out)
);

btb btb
(
	.clk,
	.target_addr(target_addr_out),
	.new_branch_address(br_add_out),
	.we(outgoing_valid_branch & miss),
	.branch_address(predicted_pc),
	.miss
);

always_comb begin
	flush = 0;
	pcmux_sel = 0;
	stall = 0;
	bp_miss = 0;
	if_control_word = incoming_control_word;

	if_control_word.predicted_branch = 0;
	if(outgoing_valid_branch && wb_should_branch && !wb_predict) begin
		pcmux_sel = outgoing_pcmux_sel;
		flush = 1;
		bp_miss = 1;
	end
	else if(outgoing_valid_branch && !wb_should_branch && wb_predict) begin
		pcmux_sel = 3'b101;
		flush = 1;
		bp_miss = 1;
	end
	/* make initial guess based on incoming word */
	else if(incoming_valid_branch && !miss) begin 
			pcmux_sel = 3'b100; // predict taken
			if_control_word.predicted_branch = 1'b1;
	end

end


endmodule : bp
