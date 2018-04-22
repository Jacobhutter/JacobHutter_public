import lc3b_types::*;

module MMIO_counters
(
	input reg[31:0] i_cache_hits,
	input reg[31:0] i_cache_misses,
	input reg[31:0] d_cache_hits,
	input reg[31:0] d_cache_misses,
	input reg[31:0] l2_cache_hits,
	input reg[31:0] l2_cache_misses,
	input reg[31:0] total_branches,
	input reg[31:0] mispredictions,
	input reg[31:0] total_stalls,
	input lc3b_opcode opcode,
	input lc3b_word mem_address,
	input lc3b_word mem_rdata_in,
	
	output logic reset_i_cache_hits,
	output logic reset_i_cache_misses,
	output logic reset_d_cache_hits,
	output logic reset_d_cache_misses,
	output logic reset_l2_cache_hits,
	output logic reset_l2_cache_misses,
	output logic reset_total_branchs,
	output logic reset_mispredictions,
	output logic reset_stalls,
	output lc3b_word mem_rdata_out
);

always_comb begin
	reset_i_cache_hits = 0;
	reset_i_cache_misses = 0;
	reset_d_cache_hits = 0;
	reset_d_cache_misses = 0;
	reset_l2_cache_hits = 0;
	reset_l2_cache_misses = 0;
	reset_total_branchs = 0;
	reset_mispredictions = 0;
	reset_stalls = 0;
	mem_rdata_out = mem_rdata_in;
	
	
	if(opcode == op_sti) begin
		case(mem_address)
			16'hFFFF:
				reset_i_cache_hits = 1;
			
			16'hFFFE:
				reset_i_cache_misses = 1;

			16'hFFFD:
				reset_d_cache_hits = 1;

			16'hFFFC:
				reset_d_cache_misses = 1;
			
			16'hFFFB:
				reset_l2_cache_hits = 1;

			16'hFFFA:
				reset_l2_cache_misses = 1;

			16'hFFF9:
				reset_total_branchs = 1;

			16'hFFF8:
				reset_mispredictions = 1;

			16'hFFF7:
				reset_stalls = 1;
							
			default: begin
			end
		endcase
	end
	
	else if(opcode == op_ldi) begin
		case(mem_address)
			16'hFFFF:
				mem_rdata_out = i_cache_hits[15:0];
			
			16'hFFFE:
				mem_rdata_out = i_cache_misses[15:0];

			16'hFFFD:
				mem_rdata_out = d_cache_hits[15:0];

			16'hFFFC:
				mem_rdata_out = d_cache_misses[15:0];
			
			16'hFFFB:
				mem_rdata_out = l2_cache_hits[15:0];

			16'hFFFA:
				mem_rdata_out = l2_cache_misses[15:0];

			16'hFFF9:
				mem_rdata_out = total_branches[15:0];

			16'hFFF8:
				mem_rdata_out = mispredictions[15:0];

			16'hFFF7:
				mem_rdata_out = total_stalls[15:0];
			default: begin
			end
		endcase
	
	end	
end

endmodule : MMIO_counters