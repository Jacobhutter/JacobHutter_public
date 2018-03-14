import lc3b_types::*;

module memwb
(
    input clk,
    input advance,
    input lc3b_word pc_in,
    input lc3b_reg dest_in,
    input lc3b_word offset9_in,
    input lc3b_word offset11_in,
    input lc3b_control_word ctrl_word_in,
	input lc3b_word mem_wdata_in,
    input lc3b_word wb_alu_in,

    output lc3b_reg dest_out,
	output lc3b_word mem_wdata_out,
    output lc3b_word wb_alu_out,
    output lc3b_word pc,
    output lc3b_word offset9_out,
    output lc3b_word offset11_out,
    output lc3b_control_word ctrl_word_out
);

initial
begin
    dest_out = 0;
    mem_wdata_out = 0;
    wb_alu_out = 0;
    pc = 0;
    offset9_out = 0;
    offset11_out = 0;
    ctrl_word_out = 0;
end

always_ff @(posedge clk)
begin
    if (advance == 1)                   // begin step1: increment pc
    begin
        mem_wdata_out = mem_wdata_in;
        dest_out = dest_in;
        wb_alu_out = wb_alu_in;
        pc = pc_in;
        offset9_out = offset9_in;
        offset11_out = offset11_in;
        ctrl_word_out = ctrl_word_in;
    end
    else begin
        dest_out = dest_out;
        mem_wdata_out = mem_wdata_out;
        wb_alu_out = wb_alu_out;
        pc = pc;
        offset9_out = offset9_out;
        offset11_out = offset11_out;
        ctrl_word_out = ctrl_word_out;
	end
end

endmodule : memwb
