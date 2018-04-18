import lc3b_types::*;
/****************************************************************/
/*								Performence_counter							 */
/*		This module is used to measure performence of certain		 */
/* components in our MP3 system. The counter has 3 different	 */
/*	modes to operate in: Cache hits and misses, Branches in pred */
/*	-ictor, and Stalls in stages of the pipelined PC. The module */
/* contains 2 counters and internal_counter for control.			 */
/*																					 */
/*																					 */
/*																					 */
/*																					 */
/*																					 */
/****************************************************************/
module performence_counter(
	input logic clk,
	input logic trigger, // Some signal we want to base our counter on
	input lc3b_word pc_in,
	input lc3b_opcode opcode,
	input lc3b_word thresh,
	input cont,
	input logic reset,

	output lc3b_word count
);

logic [3:0] internal_count;
lc3b_word prev_pc;
logic update;

initial begin
	count <= 0;
	internal_count <= 0;
	prev_pc <= 0;
	update <= 0;
end

always_ff @(posedge clk) begin
	// Determine when a stall occurs, STB is high for more than 2 cycles
	// When stall occurs, increment counter
	if(reset) begin
		internal_count <= 0;
		count <= 0;
		update <= 0;
		prev_pc <= 0;
	end
	
	else if((trigger == 1) & (internal_count != thresh))
		internal_count <= internal_count + 4'b1;
		
	else if (trigger == 0) begin
		internal_count <= 0;
		update <= 0;
	end
	
	else if((internal_count == thresh) & ((!update) | (cont))) begin
		count <= count + 1;
		update <= 1;
	end
	
	prev_pc <= pc_in;
	
end
endmodule : performence_counter