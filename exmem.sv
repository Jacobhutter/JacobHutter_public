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
    input lc3b_word offset11_in,
    input lc3b_word trapvect8_in,
    input lc3b_control_word ctrl_word_in,
	 input flush,

    output lc3b_word pc,
    output lc3b_word ex_alu_out,
    output lc3b_word source_data_out,
    output lc3b_reg dest_out,
    output lc3b_word offset9_out,
    output lc3b_word offset11_out,
    output lc3b_word trapvect8_out,
    output lc3b_control_word ctrl_word_out,
    output logic ready
);

initial
begin
    ready = 1;
    pc = 0;
    ex_alu_out = 0;
    dest_out = 0;
    offset9_out = 0;
    offset11_out = 0;
    trapvect8_out = 0;
    ctrl_word_out = 0;
    source_data_out = 0;
end

always_ff @(posedge clk)
begin
    if(flush) begin
      ready = 1;
      pc = 0;
      ex_alu_out = 0;
      dest_out = 0;
      offset9_out = 0;
      offset11_out = 0;
      trapvect8_out = 0;
      ctrl_word_out = 0;
      source_data_out = 0;
    end
    else if (advance == 1)
    begin  
      ready = 0;
      pc = pc_in;
      ex_alu_out = ex_alu_in;
      dest_out = dest_in;
      offset9_out = offset9_in;
      offset11_out = offset11_in;
      trapvect8_out = trapvect8_in;
      ctrl_word_out = ctrl_word_in;
      source_data_out = source_data_in;
		  
    end
    else begin
        ready = 1;
        pc = pc;
        ex_alu_out = ex_alu_out;
        dest_out = dest_out;
        offset9_out = offset9_out;
        offset11_out = offset11_out;
        trapvect8_out = trapvect8_out;
        ctrl_word_out = ctrl_word_out;
		  source_data_out = source_data_out;
    end
end

endmodule : exmem
