import lc3b_types::*;

module bp(
	input clk,
	input lc3b_control_word incoming_control_word,
	input lc3b_control_word outgoing_control_word,
	input branch_enable,
	input incoming_valid_branch,
	input outgoing_valid_branch,
	input logic [1:0] outgoing_pcmux_sel,
	
	output lc3b_control_word if_control_word,
	output logic [1:0] pcmux_sel,
	output logic flush,
	output logic bp_miss,
	output logic stall
);



always_comb begin
	flush = 0;
	pcmux_sel = outgoing_pcmux_sel;
	stall = 0;
	bp_miss = 0;
	if_control_word = incoming_control_word;

	/* make initial guess based on incoming word */
	case(incoming_control_word.opcode) 
	
		op_br: begin
			pcmux_sel = 2'b00; // predict not taken
			if_control_word.predicted_branch = 1'b0;
		end 
	
		op_jsr: begin
			pcmux_sel = 2'b00; // predict not taken
			stall = 1;
			if_control_word.predicted_branch = 1'b0;
		end 
	
		op_jmp: begin
			pcmux_sel = 2'b00; // predict not taken
			stall = 1;
			if_control_word.predicted_branch = 1'b0;
		end 
		
		op_trap: begin
			pcmux_sel = 2'b00; // predict not taken
			stall = 1;
			if_control_word.predicted_branch = 1'b0;
		end 
		
		default: begin
			pcmux_sel = outgoing_pcmux_sel;
			stall = 0;
			flush = 0;
			bp_miss = 0;
		end 
		
	endcase 
	
	/* after initial assumptions and predictions made, final decision by outgoing word */
	case(outgoing_control_word.opcode)
		op_br: begin
			if(branch_enable && !outgoing_control_word.predicted_branch && outgoing_valid_branch) begin // made wrong guess 
				pcmux_sel = outgoing_pcmux_sel;
				flush = 1;
				bp_miss = 1;
			end 
			else begin
				pcmux_sel = pcmux_sel; // let the predictor above decide 
			end
		end 
		
		op_jsr: begin
			pcmux_sel = outgoing_pcmux_sel;
			flush = 1;
			bp_miss = 1;
		end 
		
		op_jmp: begin
			pcmux_sel = outgoing_pcmux_sel;
			flush = 1;
			bp_miss = 1;
		end 
		
		op_trap: begin
			pcmux_sel = outgoing_pcmux_sel;
			flush = 1;
			bp_miss = 1;
		end
		
		default: begin
			pcmux_sel = outgoing_pcmux_sel;
			stall = 0;
			flush = 0;
			bp_miss = 0;
		end 
		
	endcase 
	
end 


endmodule : bp