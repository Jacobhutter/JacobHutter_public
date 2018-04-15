import lc3b_types::*;

module ifid
(
    input clk,
    input advance,
    input mem_resp,
    input lc3b_word instr,
    input lc3b_word pc_in,
    input lc3b_control_word ctrl_word_in,
	 input lc3b_word offset6_in,
    input lc3b_word offset9_in,
    input lc3b_word offset11_in,
	 input flush,

    output lc3b_reg dest, src1, src2,
	 output lc3b_word offset6_out,
    output lc3b_word offset9_out,
    output lc3b_word offset11_out,
    output lc3b_word trapvect8,
    output logic mem_request,
    output lc3b_word imm5, pc,
    output lc3b_word imm4,
    output lc3b_control_word ctrl_word_out,
	  output logic ready
);

initial
begin
    mem_request = 1'b1;
    ready = 1'b0;
    pc = 0;
    ctrl_word_out = 0;
    dest = 0;
    src1 = 0;
    src2 = 0;
    offset6_out = 0;
    offset9_out = 0;
    offset11_out = 0;
    imm5 = 0;
    imm4 = 0;
    trapvect8 = 0;
end



always_ff @(posedge clk)
begin
    if (advance == 1)
    begin
		  if(flush) begin
				mem_request = 1'b1;             
				ready = 1'b0;                      
				pc = 0;
				ctrl_word_out = 0;
				dest = 0;
				src1 = 0;
				src2 = 0;
				offset6_out = 0;
				offset9_out = 0;
				offset11_out = 0;
				imm5 = 0;
				imm4 = 0;
				trapvect8 = 0;
		  end
		  else begin
				mem_request = 1'b1;   
				ready = 1'b0;                      
				pc = pc_in + 2;
				if(instr == 16'd0) // detect no op vs branch
					ctrl_word_out = 0;
				else
					ctrl_word_out = ctrl_word_in;
				dest = instr[11:9];
				src1 = instr[8:6];
				src2 = instr[2:0];
				offset6_out = offset6_in;
				offset9_out = offset9_in;
				offset11_out = offset11_in;
				imm5 = 16'(signed'(instr[4:0]));
				imm4 = 16'({12'd0,(instr[3:0])});
				trapvect8 = 16'({7'd0,8'(instr[7:0]),1'b0});
		  end
    end
    else if(mem_resp)
    begin
        mem_request = 1'b1;
        ready = 1'b1;
        pc = pc;
        ctrl_word_out = ctrl_word_out;
        dest = dest;
        src1 = src1;
        src2 = src2;
        offset6_out = offset6_out;
        offset9_out = offset9_out;
        offset11_out = offset11_out;
        imm5 = imm5;
        imm4 = imm4;
        trapvect8 = trapvect8;
    end
    else begin
        mem_request = 1'b1;
        ready = 1'b0;
        pc = pc;
        ctrl_word_out = ctrl_word_out;
        dest = dest;
        src1 = src1;
        src2 = src2;
        offset6_out = offset6_out;
        offset9_out = offset9_out;
        offset11_out = offset11_out;
        imm5 = imm5;
        imm4 = imm4;
        trapvect8 = trapvect8;
    end
end

endmodule : ifid
