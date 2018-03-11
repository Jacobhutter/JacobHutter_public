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

    output lc3b_reg dest, src1, src2,
    output logic load_pc,
	 output lc3b_word offset6_out,
    output lc3b_word offset9_out,
    output lc3b_offset11 offset11,
    output logic mem_request,
    output lc3b_word imm5, pc,
    output lc3b_control_word ctrl_word_out,
	  output logic ready
);

always_ff @(posedge clk)
begin
    load_pc = 1'b0;                     // pc_plus 2
    if (advance == 1)                   // begin step1: increment pc
    begin
        load_pc = 1;                    // increment pc
        pc = 0;
        ctrl_word_out = 0;
        dest = 3'd0;
        src1 = 3'd0;
        src2 = 3'd0;
        offset6_out = 0;
        offset9_out = 0;
        offset11 = 11'd0;
        imm5 = 5'd0;
        ready = 0;                      // ensures advance = 1 not triggered more than once
        mem_request = 1'b1;             // begin step 2: fetch memory

    end
    else if(mem_resp)
    begin
        load_pc = 0;
        mem_request = 1'b0;
        ready = 1;
        pc = pc_in;
        ctrl_word_out = ctrl_word_in;
        dest = instr[11:9];
        src1 = instr[8:6];
        src2 = instr[2:0];
        offset6_out = offset6_in;
        offset9_out = offset9_in;
        offset11 = instr[10:0];
        imm5 = 16'(signed'(instr[4:0]));
    end
    else begin
        load_pc = 0;
        pc = pc;
        ctrl_word_out = ctrl_word_out;
        ready = ready;
        dest = dest;
        src1 = src1;
        src2 = src2;
        offset6_out = offset6_out;
        offset9_out = offset9_out;
        offset11 = offset11;
        mem_request = mem_request;
        imm5 = imm5;
    end
end

endmodule : ifid
