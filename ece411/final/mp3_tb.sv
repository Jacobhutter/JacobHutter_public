module mp3_tb();

timeunit 1ns;
timeprecision 1ns;

logic clk;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

wishbone wb(clk);

mp3 dut(
	.wb_physmem(wb)
);

physical_memory memory(wb);

endmodule : mp3_tb
