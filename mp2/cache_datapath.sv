import lc3b_types::*;

module cache_datapath
(
    input clk
);

/* instantiate 8 128 bit data arrays for way 1 */
arary darray1(
    .clk,
    .write,
    .index,
    .datain,
    .dataout
);

/* instantiate 8 128 bit data arrays for way 2 */
arary darray20();


endmodule : cache_datapath
