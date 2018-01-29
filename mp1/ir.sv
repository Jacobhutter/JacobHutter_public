import lc3b_types::*;

module ir
(
    input clk,
    input load,
    input lc3b_word in,
    output lc3b_opcode opcode,
    output lc3b_reg dest, src1, src2,
    output lc3b_offset6 offset6,
    output lc3b_offset9 offset9,
	 output logic immediate,
	 output logic jsr_trigger,
	 output logic a,
	 output logic d,
	 output lc3b_word imm4,
	 output lc3b_word imm5,
	 output lc3b_word trapvect8
);

lc3b_word data;

always_ff @(posedge clk)
begin
    if (load == 1)
    begin
        data = in;
    end
end

always_comb
begin
    opcode = lc3b_opcode'(data[15:12]);

    dest = data[11:9];
    src1 = data[8:6];
    src2 = data[2:0];
	 jsr_trigger = data[11];
    offset6 = data[5:0];
	 a = data[5];
	 d = data[4];
    offset9 = data[8:0];
	 immediate = data[5];
	 imm5 = 16'(signed'(data[4:0]));
	 imm4 = 16'(signed'(data[3:0]));
	 trapvect8[8:1] = data[7:0];
	 trapvect8[15:9] = 7'd0;
	 trapvect8[0] = 0; // do shift and zero extend in one go
end

endmodule : ir
