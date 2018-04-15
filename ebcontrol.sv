import lc3b_types::*;

module ebcontrol
(
    input clk,
    input orig_strobe,
    input orig_write,
    input dest_resp,
    input hit_detect,
    
    output logic datain_mux,
    output logic dataout_mux,
    output logic buffer_write,
    output logic dest_strobe,
    output logic dest_write,
    output logic orig_resp
);

enum int unsigned {
    idle, read, toggle1, write, toggle2
} state, next_state;

always_ff @(posedge clk)
begin
    state <= next_state;
end 

always_comb
begin
    datain_mux = 0;
    dataout_mux = 0;
    buffer_write = 0;
    dest_strobe = 0;
    dest_write = 0;
    orig_resp = 0;
    case(state)
        idle: begin
            if(orig_write) begin
                buffer_write = 1;
                orig_resp = 1;
            end
            else if(hit_detect) begin
                datain_mux = 1;
                orig_resp = 1;
            end
            else begin
                orig_resp = dest_resp;
                dest_strobe = orig_strobe;
                dest_write = 0;
            end
        end
        read: begin
            dest_strobe = orig_strobe;
            dest_write = 0;
            orig_resp = dest_resp;
        end
        toggle1: begin
            if(hit_detect && ~orig_write) begin
                datain_mux = 1;
                orig_resp = 1;
            end
        end
        write: begin
            dest_strobe = 1;
            dest_write = 1;
            dataout_mux = 1;
            if(hit_detect && ~orig_write) begin
                datain_mux = 1;
                orig_resp = 1;
            end
       end
       toggle2: begin
            if(hit_detect && ~orig_write) begin
                datain_mux = 1;
                orig_resp = 1;
            end
        end
    endcase
end

always_comb
begin
    next_state = state;
    case(state)
        idle: 
            if(orig_write && ~hit_detect)
                next_state = read;
        read:
            if(orig_strobe && dest_resp)
                next_state = toggle1;
        toggle1: next_state = write;
        write:
            if(dest_resp)
                next_state = toggle2;
        toggle2: next_state = idle;
    endcase
end



endmodule : ebcontrol