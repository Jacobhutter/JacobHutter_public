import lc3b_types::*;

module exmem
(
    input clk,
    input advance,
    input lc3b_word pc_in,
    input lc3b_word ex_alu_in,
    input lc3b_reg dest_in,
    input lc3b_word source_data_in,
    input lc3b_word offset9_in,
    input lc3b_control_word ctrl_word_in,

    output lc3b_word pc,
    output lc3b_word ex_alu_out,
    output lc3b_word source_data_out,
    output lc3b_reg dest_out,
    output lc3b_word offset9_out,
    output lc3b_control_word ctrl_word_out,
    output logic ready
);


always_ff @(posedge clk)
begin
    if (advance == 1)
    begin
        ready = 0;
        pc = pc_in;
        ex_alu_out = ex_alu_in;
        dest_out = dest_in;
        offset9_out = offset9_in;
        ctrl_word_out = ctrl_word_in;
		  source_data_out = source_data_in;
    end
    else begin
        ready = 1;
        pc = pc;
        ex_alu_out = ex_alu_out;
        dest_out = dest_out;
        offset9_out = offset9_out;
        ctrl_word_out = ctrl_word_out;
		  source_data_out = source_data_out;
    end
end

endmodule : exmem
