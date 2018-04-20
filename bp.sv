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
logic miss;
lc3b_word target_addr_out;

mux2 target_addr_mux
(
		.a(incoming_pc),
		.b(outgoing_pc),
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
	pcmux_sel = outgoing_pcmux_sel;
	stall = 0;
	bp_miss = 0;
	if_control_word = incoming_control_word;

	/* make initial guess based on incoming word */
	if(incoming_valid_branch) begin 
		if(miss | outgoing_valid_branch) begin
			pcmux_sel = 3'b000; // predict not taken
			if_control_word.predicted_branch = 1'b0;
		end
		else begin
			pcmux_sel = 3'b100; // predict taken daddy
			if_control_word.predicted_branch = 1'b1;
		end
	end

	/* after initial assumptions and predictions made, final decision by outgoing word */
	if(outgoing_valid_branch) begin
		flush = 0;
		pcmux_sel = pcmux_sel;
		bp_miss = 0;
		
		if(branch_enable) begin 
			if(outgoing_control_word.predicted_branch == 0) begin // wrong guess
				pcmux_sel = outgoing_pcmux_sel;
				flush = 1;
				bp_miss = 1;
			end
			else begin // right guess continue 
				pcmux_sel = 3'b000;
			end 
		end 
		else begin
			if(outgoing_control_word.predicted_branch == 1) begin // wrong guess
				pcmux_sel = outgoing_pcmux_sel;
				flush = 1;
				bp_miss = 1;
			end 
			else begin
				pcmux_sel = 3'b000;
			end 
		end 
	end
end


endmodule : bp
