import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module cache_control
(
	input clk,
	input hit,
	input dirty,
	input stb,
	input ack_in,

	output logic cache_in_mux_sel,
	output logic ack_out,
	output logic stb_out,
	output logic cyc_out,
	output logic we_out,
	output logic control_load
);

enum int unsigned {
   fetch,
	 mem_read,
	 cache_write
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
	 cache_in_mux_sel = 1'b0;
	 ack_out = 1'b0;
	 stb_out = 1'b0;
	 we_out = 1'b0;
	 control_load = 1'b0;
	 cyc_out = 1'b0;

	 case(state)

		fetch: begin
			if(stb & hit) // if request from cpu comes, respond with ack immediately if ready
				ack_out = 1'b1;
		end

		mem_read: begin
			we_out = 1'b0;
			stb_out = 1'b1;
			cyc_out = 1'b1;
		end

		cache_write: begin
			cache_in_mux_sel = 1'b1; // read in from mem and force load
			control_load = 1'b1;
			ack_out = 1'b1; // say to cpu that value is in data port
		end

		default: /* Do nothing */;

	endcase

end

always_comb
begin : next_state_logic

	case(state)

		fetch: begin
			if (stb & ~hit)
				next_state <= mem_read;
			else
				next_state <= fetch;
		end

		mem_read: begin
			if(!ack_in)
				next_state <= mem_read;
			else 
				next_state <= cache_write;
		end

		cache_write: begin
			next_state <= fetch;
		end

		default:
			next_state <= fetch;

	endcase

end

always_ff @(posedge clk)
begin: next_state_assignment
    state <= next_state;
end

endmodule : cache_control
