import lc3b_types::*;

module mux8 #(parameter width = 16) 
(
	input lc3b_sel sel, 
	input [width-1:0] a, b, c, d, e, g, h, i, 
	output logic [width-1:0] f 
);

always_comb 
begin 
	if (sel == 2'b00) 
		f = a; 
	else if(sel == 2'b01) 
		f = b; 
	else if(sel == 2'b10) 
		f = c; 
	else
		f = d; 
end
endmodule : mux4
