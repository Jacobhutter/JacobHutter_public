import lc3b_types::*;

/*
 * SEXT[offset-n << 1]
 */
module adj #(parameter width = 8)
(
    input [width-1:0] in,
    output lc3b_word out,
    output lc3b_word out2
);

assign out = $signed({in, 1'b0});
assign out2 = 16'(signed'(in));

endmodule : adj
