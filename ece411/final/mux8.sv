import lc3b_types::*;

module mux8 #(parameter width = 16) 
(
	input lc3b_sel3 sel, 
	input [width-1:0] in0, in1, in2, in3, in4, in5, in6, in7,
	output logic [width-1:0] f 
);

always_comb
begin
    case(sel)
        3'b000: f = in0;
        3'b001: f = in1;
        3'b010: f = in2;
        3'b011: f = in3;
        3'b100: f = in4;
        3'b101: f = in5;
        3'b110: f = in6;
        3'b111: f = in7;
        default: f = in0;
    endcase
end

endmodule : mux8