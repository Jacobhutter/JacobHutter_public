import lc3b_types::*;

module bp(
	input clk,
	input lc3b_opcode incoming_opcode,
	input lc3b_opcode outgoing_opcode,
	input branch_enable,
	input incoming_valid_branch,
	input outgoing_valid_branch,
	input logic [1:0] outgoing_pcmux_sel,
	
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

	case(incoming_opcode) 
	
		op_br: begin
			pcmux_sel = 2'b00; // predict not taken
		end 
	
		op_jsr: begin
			stall = 1;
		end 
	
		op_jmp: begin
			stall = 1;
		end 
		
		op_trap: begin
			stall = 1;
		end 
		
		default: ;
	endcase 
	
	if(outgoing_pcmux_sel == 2'b01 && branch_enable == 0 && outgoing_valid_branch && outgoing_opcode == op_br) begin
		pcmux_sel = outgoing_pcmux_sel;
	end 
	else begin
		pcmux_sel = outgoing_pcmux_sel;
	end

	if(outgoing_valid_branch && outgoing_opcode == op_br && branch_enable == 1) begin
		flush = 1;
		bp_miss = 1;
	end 
	
end 


endmodule : bp