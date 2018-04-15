import lc3b_types::*;

module performence_tb();

timeunit 1ns;
timeprecision 1ns;

logic clk;
logic signal;
lc3b_word counter_1;
lc3b_word counter_2;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

performence_counter DUT
(
	.clk,
	.trigger(signal),
	.pc_in(pc),
	.opcode,
	.counter_type(0)
	.count1(counter_1),
	.count2(counter_2)
	
);

initial begin
	#5
	signal = 0;
	#5
	signal = 1;
	#5
	signal = 0;
	#5
	signal = 1;
	#5
	signal = 0;
end

endmodule