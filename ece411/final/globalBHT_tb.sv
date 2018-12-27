import lc3b_types::*;

module globalBHT_tb();

timeunit 1ns;
timeprecision 1ns;

/* signals used */
logic clk;
logic signal;
lc3b_word pc_in;
logic update;
logic predict;

/* Clock generator */
initial clk = 0;
initial signal = 1;
always #1 clk = ~clk;
always #10 signal = ~signal;
global_bht DUT
(
	.clk,
	.update,
	.pc_in,
	.branch_taken(signal),
	
	.predict
	
);

initial begin
	pc_in <= 16'h0000;
	update <= 1;
	#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
	#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
	#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
	#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
		#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
	#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
	#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
	#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
		#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
	#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
	#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
	#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
		#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
	#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
	#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
	#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
		#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
	#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
	#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
	#10
	pc_in <= 16'hFFFF;
	update <= 1;
	#10
	pc_in <= 16'hFFFE;
	update <= 1;
	#10
	pc_in <= 16'hFFFD;
	update <= 1;
	#10
	pc_in <= 16'hFFFC;
	update <= 1;
	#10
	pc_in <= 16'hFFFB;
	update <= 1;
	#10
	pc_in <= 16'hFFFA;
	update <= 1;
	#10
	pc_in <= 16'hFFF9;
	update <= 1;
	#10
	pc_in <= 16'hFFF8;
	update <= 1;
	#10
	pc_in <= 16'hFFF7;
	update <= 1;
end

endmodule