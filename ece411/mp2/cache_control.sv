import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module cache_control
(
	input clk,
	input hit,
	input dirty,
	input stb,
	input ack_in,
	input write_enable,

	output logic cache_in_mux_sel,
	output logic ack_out,
	output logic stb_out,
	output logic cyc_out,
	output logic we_out,
	output logic control_load,
	output logic mem_sel,
	output logic lru_load
);

enum int unsigned {
   fetch,
	 mem_read,
	 mem_write,
	 cache_write,
	 mem_write_reset
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
	 lru_load = 1'b0;
	 mem_sel = 1'b0;

	 case(state)

		fetch: begin
			if(stb & hit) begin // if request from cpu comes, respond with ack immediately if ready
				ack_out = 1'b1;
				lru_load = 1'b1;
			end
		end

		mem_read: begin
			mem_sel = 1'b0;
			we_out = 1'b0;
			stb_out = 1'b1;
			cyc_out = 1'b1;
			cache_in_mux_sel = 1'b1; // read in from mem and force load
			if(ack_in)
				control_load = 1;
		end

		mem_write: begin
			mem_sel = 1'b1;
			we_out = 1'b1;
			stb_out = 1'b1;
			cyc_out = 1'b1;
			if(ack_in) begin
				stb_out = 1'b0; // prep for read
				cyc_out = 1'b0;
			end
		end
		
		mem_write_reset: begin
		end

		cache_write: begin
		end

		default: /* Do nothing */;

	endcase

end

always_comb
begin : next_state_logic

	case(state)

		fetch: begin
			if (stb & ~hit) begin // cache miss
				if(dirty & write_enable)
					next_state <= mem_write; // write back
				else
					next_state <= mem_read; // read
			end
			else
				next_state <= fetch;
		end

		mem_read: begin
			if(!ack_in)
				next_state <= mem_read;
			else
				next_state <= cache_write;
		end

		mem_write: begin
			if(!ack_in)
				next_state <= mem_write;
			else 
				next_state <= mem_write_reset;
		end
		
		mem_write_reset: begin
			next_state <= mem_read;
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
