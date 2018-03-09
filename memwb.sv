import lc3b_types::*;

module memwb
(
    input clk,
    input advance,
    input lc3b_word pcin,
    input lc3b_reg dest_in,
    input lc3b_word offset9_in,
    input lc3b_control_word ctrl_word_in,
    input lc3cb_word wb_alu_in,
    input data_response,
    input lc3b_word read_data,

    output logic data_request,
    output logic load_mar,
    output logic load_mdr,
    output lc3b_reg dest_out,
    output lc3b_word wb_alu_out,
    output lc3b_word pc,
    output lc3b_word offset9_out,
    output lc3b_control_word ctrl_word_out,
    output logic ready
);

assign mem_required = ctrl_word_in.mem_read | ctrl_word_in.mem_write;
always_ff @(posedge clk)
begin
    if (advance == 1)                   // begin step1: increment pc
    begin
        if(mem_required)
        begin
            load_mar = 1;
            load_mdr = ctrl_word_in.mem_write;
            data_request = 0;
            dest_out = dest_out;
            wb_alu_out = wb_alu_out;
            pc = pc;
            offset9_out = offset9_out;
            ctrl_word_out = ctrl_word_out;
            ready = 0;
        end
        else
        begin
            load_mar = 0;
            load_mdr = 0;
            data_request = 0;
            dest_out = dest_in;
            wb_alu_out = wb_alu_in;
            pc = pc_in;
            offset9_out = offset9_in;
            ctrl_word_out = ctrl_word_in;
            ready = 1;
        end
    end
    else if(mem_resp)
    begin
        load_mar = 0;
        load_mdr = ctrl_word_in.read;
        data_request = 0;
        dest_out = dest_in;
        wb_alu_out = wb_alu_in;
        pc = pc_in;
        offset9_out = offset9_in;
        ctrl_word_out = ctrl_word_in;
        ready = 1;
    end
    else begin // hold
        load_mar = 0;
        load_mdr = 0;
        data_request = data_request;
        dest_out = dest_out;
        wb_alu_out = wb_alu_out;
        pc = pc;
        offset9_out = offset9_out;
        ctrl_word_out = ctrl_word_out;
        ready = ready;
    end
end

endmodule : memwb
