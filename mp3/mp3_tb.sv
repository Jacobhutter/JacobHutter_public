module mp3_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

wishbone i(clk);
wishbone d(clk);

cpu dut(
  .ifetch(i),
  .memory(d)
);

magic_memory memory(
  .ifetch(i),
  .memory(d)
);

endmodule : mp3_tb
