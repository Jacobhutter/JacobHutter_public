import lc3b_types::*;

module mp2
(
    input clk,

    /* Memory signals */
    input mem_resp,
    input lc3b_word mem_rdata,
    output logic mem_read,
    output logic mem_write,
    output lc3b_mem_wmask mem_byte_enable,
    output lc3b_word mem_address,
    output lc3b_word mem_wdata
);

cpu Cpu
(
	.clk,
	.mem_resp,
	.mem_rdata,
	.mem_read,
	.mem_write,
	.mem_byte_enable,
	.mem_address,
	.mem_wdata
);

endmodule : mp2
