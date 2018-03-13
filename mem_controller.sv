import lc3b_types::*;

module mem_controller (
    input clk,
    input data_response,
    input lc3b_control_word ctrl_word_in,

    output lc3b_control_word ctrl_word_out
);

enum int unsigned {
	s_ldi_1, s_ldi_2, s_sti_1, s_sti_2
} state, next_state;

always_comb
begin : state_actions
	ctrl_hit = 1'b0;
	ctrl_write = 1'b0;
	ctrl_reload = 1'b0;
	mem_we = 1'b0;
	mem_strobe = 1'b0;

	case(state)
        s_ldi_1: begin
        end

        s_ldi_2: begin
        end

        s_sti_1: begin
        end

        s_sti_2: begin
        end

		default : ;
	endcase
end

always_comb
begin : next_state_logic
	next_state = state;
	case(state)

		default : ;
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
	/* Assignment of next state on clock edge */
	 state <= next_state;
end

endmodule : mem_controller
