import lc3b_types::*;

module ifid
(
    input clk,
    input advance,
    input lc3b_word pc_in,
    input lc3b_word instr,
    input lc3b_control_word ctrl_word_in,
    output lc3b_opcode opcode,
    output lc3b_reg dest, src1, src2,
    output lc3b_offset6 offset6,
    output lc3b_offset9 offset9,
    output lc3b_offset11 offset11,
    output logic [2:0] bits4_5_11,
    output lc3b_word imm4, imm5, ifpc,
    output lc3b_control_word ctrl_word_out,
	output logic ready
);

lc3b_word data;

always_ff @(posedge clk)
begin
    if (advance == 1)
    begin
        ifpc = pc_in;
        ctrl_word_out = ctrl_word_in;
        data = instr;
        ready = 1;
    end
    else
        ready = 0;
end

always_comb
begin
    opcode = lc3b_opcode'(data[15:12]);
    dest = data[11:9];
    src1 = data[8:6];
    src2 = data[2:0];
    offset6 = data[5:0];
    offset9 = data[8:0];
    offset11 = data[10:0]
    bits4_5_11 = 3'({data[4], data[5], data[11]})
	imm5 = 16'(signed'(data[4:0]));
	imm4 = 16'(signed'(data[3:0]));
end

endmodule : ir
