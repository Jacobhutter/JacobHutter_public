import lc3b_types::*;

module cccomp
(
	input lc3b_nzp cc, 
	input lc3b_reg dest,
	output logic branch_enable 
);

always_comb 
begin 
	branch_enable = (dest[2]&cc[0])|(dest[1]&cc[1])|(dest[0]&cc[2]);
end
endmodule : cccomp