import lc3b_types::*;

module idex
(
    input clk,
    input advance,
    input lc3b_word pc_in,
    input lc3b_control_word ctrl_word_in,
    input lc3b_reg dest_in,
    input lc3b_word sr1_in,
    input lc3b_word sr2_in,
    input lc3b_word offset6_in,
    input lc3b_word offset9_in,
    input lc3b_word offset11_in,
    input lc3b_word imm5_in,
    input lc3b_word imm4_in,
    input lc3b_word trapvect8_in,
	 input flush,

    output lc3b_word pc,
    output lc3b_reg dest_out,
    output lc3b_word sr1_out,
    output lc3b_word sr2_out,
    output lc3b_word offset6_out,
    output lc3b_word offset9_out,
    output lc3b_word offset11_out,
    output lc3b_word imm5_out,
    output lc3b_word imm4_out,
    output lc3b_word trapvect8_out,
    output lc3b_control_word ctrl_word_out,
    output logic ready
);

initial
begin
    ready = 1;
    pc = 0;
    dest_out = 0;
    sr1_out = 0;
    sr2_out = 0;
    offset6_out = 0;
    offset9_out = 0;
    offset11_out = 0;
    imm5_out = 0;
    imm4_out = 0;
    trapvect8_out = 0;
    ctrl_word_out = 0;
end

always_ff @(posedge clk)
begin
    if (advance == 1)
    begin
		  if(flush) begin
				ready = 0;
				pc = pc_in;
				dest_out = 0;
				sr1_out = 0;
				sr2_out = 0;
				offset6_out = 0;
				offset9_out = 0;
				offset11_out = 0;
				imm5_out = 0;
				imm4_out = 0;
				trapvect8_out = 0;
				ctrl_word_out = 0;
		  end 
		  else begin
				ready = 0;
				pc = pc_in;
				dest_out = dest_in;
				sr1_out = sr1_in;
				sr2_out = sr2_in;
				offset6_out = offset6_in;
				offset9_out = offset9_in;
				offset11_out = offset11_in;
				imm5_out = imm5_in;
				imm4_out = imm4_in;
				trapvect8_out = trapvect8_in;
				ctrl_word_out = ctrl_word_in;
		  end
    end
    else
    begin
        ready = 1;
        pc = pc;
        dest_out = dest_out;
        sr1_out = sr1_out;
        sr2_out = sr2_out;
        offset6_out = offset6_out;
        offset9_out = offset9_out;
        offset11_out = offset11_out;
        imm5_out = imm5_out;
        imm4_out = imm4_out;
        trapvect8_out = trapvect8_out;
        ctrl_word_out = ctrl_word_out;
    end
end

endmodule : idex
