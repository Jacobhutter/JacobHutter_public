import lc3b_types::*;

module idex
(
    input clk,
    input advance,
    input mem_resp,
    input lc3b_word instr,
    input lc3b_word pc_in
    input lc3b_control_word ctrl_word_in,

    output lc3b_reg dest, src1, src2,
    output lc3b_offset6 offset6,
    output lc3b_offset9 offset9,
    output lc3b_offset11 offset11,
    output logic mem_request,
    output lc3b_word imm4, imm5, pc,
    output lc3b_control_word ctrl_word_out,
	output logic ready
);

lc3b_word data;

always_ff @(posedge clk)
begin
    load_pc = 1'b0;                     // pc_plus 2
    if (advance == 1)                   // begin step1: increment pc
    begin
        ready = 0;                      // ensures advance = 1 not triggered more than once
        pcmux_sel = 2'b00;
        load_pc = 1'b1;                 // pc_plus 2
        mem_request = 1'b1;             // begin step 2: fetch memory
    end
    else if(mem_resp)
    begin
        mem_request = 1'b0;
        ctrl_word_out = ctrl_word_in;   // step3: build new control signal
        data = instr;
        ready = 1;                      // wait for next advance signal
        pc = pc_in;
    end
    else begin
        pc = pc;
        data = data;
        ctrl_word_out = ctrl_word_out;
        ready = ready;
    end
end

always_comb
begin
    dest = data[11:9];
    src1 = data[8:6];
    src2 = data[2:0];
    offset6 = data[5:0];
    offset9 = data[8:0];
    offset11 = data[10:0]
	imm5 = 16'(signed'(data[4:0]));
	imm4 = 16'(signed'(data[3:0]));
end

endmodule : idex
