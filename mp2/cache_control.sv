import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module cache_control
(
	input clk
);

enum int unsigned {
    fetch1,
	 fetch2,
	 fetch3,
	 decode
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
	 load_pc = 1'b0;

	 case(state)
		fetch1: begin
			/* MAR <= PC */
			marmux_sel = 2'b01;
			load_mar = 1;

			/* PC <= PC + 2 */
			pcmux_sel = 2'b00;
			load_pc = 1;
		end

		fetch2: begin
			/* Read memory */
			mem_read = 1;
			mdrmux_sel = 2'b01;
			load_mdr = 1;
		end

		fetch3: begin
			/* Load IR */
			load_ir = 1;
		end

		decode: /* Do nothing */;

		default: /* Do nothing */;

	endcase

end

always_comb
begin : next_state_logic

	unique case(state)

		fetch1 : begin
			next_state <= fetch2;
		end

		fetch2: begin
			if(mem_resp == 0)
				next_state <= fetch2;
			else
				next_state <= fetch3;
		end

		fetch3: begin
			next_state <= decode;
		end

		decode: begin

			case(opcode)

				op_add: begin
					next_state <= s_add_decide;
				end

				default:
					next_state <= fetch1;

			endcase

		end

		default:
			next_state <= fetch1;

	endcase

end

always_ff @(posedge clk)
begin: next_state_assignment
    state <= next_state;
end

endmodule : cache_control
