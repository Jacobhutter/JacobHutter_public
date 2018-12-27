import lc3b_types::*;

module mem_controller (
    input clk,
    input data_response,
    input lc3b_control_word ctrl_word_in,

    output lc3b_control_word ctrl_word_out
);

enum int unsigned {
	decode, s_ldi_1, s_ldi_2, s_sti_1, s_sti_2
} state, next_state;

always_comb
begin : state_actions
	ctrl_word_out = ctrl_word_in;

	case(state)
		  decode: ;
		  
        s_ldi_1: ; // use given control word

        s_ldi_2: begin
				ctrl_word_out = ctrl_word_in;
				ctrl_word_out.marmux_sel = 2'b10; // select read data as new address
        end

        s_sti_1: ; // use given control word

        s_sti_2: begin
				ctrl_word_out = ctrl_word_in;
				ctrl_word_out.mem_read = 0; // change read to write 
				ctrl_word_out.mem_write = 1;
				ctrl_word_out.marmux_sel = 2'b10; // select read data as new address
				ctrl_word_out.mdrmux_sel = 2'b00; // sel write data into mdr to write 
        end

		default : ; 
	endcase
end

always_comb
begin : next_state_logic
	next_state = state;
	case(state)
	
		decode: begin
			case (ctrl_word_in.opcode)
				op_ldi: begin
					next_state <= s_ldi_1;
				end
				
				op_sti: begin
					next_state <= s_sti_1;
				end
				
				default: begin
					next_state <= decode;
				end
			endcase 
		end
		
		s_ldi_1: begin
			if(data_response == 0)
				next_state <= s_ldi_1;
			else 
				next_state <= s_ldi_2;
		end
		
		s_ldi_2: begin
			if(data_response == 0)
				next_state <= s_ldi_2;
			else 
				next_state <= decode;
		end

		s_sti_1: begin
			if(data_response == 0)
				next_state <= s_sti_1;
			else 
				next_state <= s_sti_2;
		end
		
		s_sti_2: begin
			if(data_response == 0)
				next_state <= s_sti_2;
			else 
				next_state <= decode;
		end

		default : ;
		
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
	/* Assignment of next state on clock edge */
	 state <= next_state;
end

endmodule : mem_controller
