module InvSubBytes(input [127:0] state,
                   input Clk,
                   output logic [127:0] out_state);
InvSBox IB0 (.clk(Clk), .in(state[7:0]), .out(out_state[7:0]));
InvSBox IB1 (.clk(Clk), .in(state[15:8]), .out(out_state[15:8]));
InvSBox IB2 (.clk(Clk), .in(state[23:16]), .out(out_state[23:16]));
InvSBox IB3 (.clk(Clk), .in(state[31:24]), .out(out_state[31:24]));
InvSBox IB4 (.clk(Clk), .in(state[39:32]), .out(out_state[39:32]));
InvSBox IB5 (.clk(Clk), .in(state[47:40]), .out(out_state[47:40]));
InvSBox IB6 (.clk(Clk), .in(state[55:48]), .out(out_state[55:48]));
InvSBox IB7 (.clk(Clk), .in(state[63:56]), .out(out_state[63:56]));
InvSBox IB8 (.clk(Clk), .in(state[71:64]), .out(out_state[71:64]));
InvSBox IB9 (.clk(Clk), .in(state[79:72]), .out(out_state[79:72]));
InvSBox IB10 (.clk(Clk), .in(state[87:80]), .out(out_state[87:80]));
InvSBox IB11 (.clk(Clk), .in(state[95:88]), .out(out_state[95:88]));
InvSBox IB12 (.clk(Clk), .in(state[103:96]), .out(out_state[103:96]));
InvSBox IB13 (.clk(Clk), .in(state[111:104]), .out(out_state[111:104]));
InvSBox IB14 (.clk(Clk), .in(state[119:112]), .out(out_state[119:112]));
InvSBox IB15 (.clk(Clk), .in(state[127:120]), .out(out_state[127:120]));

endmodule
