import lc3b_types::*;

module mem_control
(
    input clk,
    input advance,
    input lc3b_control_word mem_control_word,
    input lc3b_word src_data,
    input lc3b_word alu_data,
    input lc3b_word trapvect8,
    input lc3b_word mem_rdata,
    input data_response,
    
    output lc3b_word mem_wdata,
    output logic [1:0] mem_byte_enable,
    output logic data_request,
    output lc3b_word mem_address,
    output lc3b_word mem_output,
    output logic write_enable,
    output logic ready
);

logic get_rdata, need_second;
lc3b_word last_data_out;

assign need_second = (mem_control_word.opcode == op_sti) || (mem_control_word.opcode == op_ldi); 

enum int unsigned {
    first_hit, second_hit
} state, next_state;

register last_data
(
    .clk,
    .load(get_rdata),
    .in(mem_rdata),
    .out(last_data_out)
);

always_comb
begin : state_actions
    mem_wdata = 0;
    mem_output = 0;
    mem_byte_enable = 2'b11;
    data_request = 0;
    mem_address = 0;
    write_enable = 0;
    ready = 1;
    get_rdata = 0;
    case(state)
        first_hit: begin
            case(mem_control_word.opcode)
                op_ldb: begin
                    mem_address = alu_data;
                    ready = data_response;
                    data_request = 1;
                    
                    mem_output = {8'd0, mem_rdata[7:0]};
                    if(alu_data[0])
                        mem_output = {8'd0, mem_rdata[15:8]};
                end 
                op_ldi: begin
                    mem_address = alu_data;
                    ready = 0;
                    data_request = 1;
                    get_rdata = 1;
                end
                op_ldr: begin
                    mem_address = alu_data;
                    ready = data_response;
                    data_request = 1;
                    mem_output = mem_rdata;
                end
                op_stb: begin
                    mem_address = alu_data;
                    ready = data_response;
                    data_request = 1;
                    write_enable = 1;
                    
                    mem_wdata = {8'd0, src_data[7:0]};
                    mem_byte_enable = 2'b01;
                    if(alu_data[0]) begin
                        mem_wdata = {src_data[15:8], 8'd0};
                        mem_byte_enable = 2'b10;
                    end
                end
                op_sti: begin
                    mem_address = alu_data;
                    ready = 0;
                    data_request = 1;
                    get_rdata = 1;
                end
                op_str: begin
                    mem_address = alu_data;
                    ready = data_response;
                    data_request = 1;
                    write_enable = 1;
                    mem_wdata = src_data;
                end
                op_trap: begin
                    mem_address = trapvect8;
                    ready = data_response;
                    data_request = 1;
                    mem_output = mem_rdata;
                end
                default: ;
            endcase
        end
        second_hit: begin
            case(mem_control_word.opcode)
                op_ldi: begin 
                    mem_address = last_data_out;
                    ready = data_response;
                    data_request = 1;
                    mem_output = mem_rdata;
                end
                op_sti: begin
                    mem_address = last_data_out;
                    ready = data_response;
                    data_request = 1;
                    write_enable = 1;
                    mem_wdata = src_data;
                end
                default: ;
            endcase
        end
    endcase
end

always_comb
begin : next_state_logic
    next_state = state;
    case(state)
        first_hit:
            if(need_second & data_response)
                next_state = second_hit;
        second_hit:
            if(data_response & advance)
                next_state = first_hit;
    endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_state;
end

endmodule : mem_control