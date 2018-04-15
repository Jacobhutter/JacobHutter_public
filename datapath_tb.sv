module datapath_tb();

// Change location of register file in test-o-matic

timeunit 1ns;
timeprecision 1ns;

logic clk;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

wishbone wb_icache(clk);
wishbone wb_dcache(clk);

cpu mp3_cpu (
    .ifetch(wb_icache),
    .memory(wb_dcache)
);

magic_memory magic_mem (
    .ifetch(wb_icache),
    .memory(wb_dcache)
);

endmodule : datapath_tb
