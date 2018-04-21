import lc3b_types::*;

module cache_control (
    input clk,
    
    /* From datapath */
    input cpu_resp,
    input cpu_strobe,
    input cache_lru,
    input [1:0] cache_dirty,
    
    /* To datapath */
    output logic ctrl_hit,
    output logic ctrl_write,
    output logic ctrl_reload,
    
    /* From memory */
    input mem_resp,
    
    /* To memory */
    output logic mem_we,
    output logic mem_strobe,
    
    /* From cpu */
    input cpu_write
);

enum int unsigned {
    rw_hit, load_addr, write_back, mem_reset, reload
} state, next_state;

always_comb
begin : state_actions
    ctrl_hit = 1'b0;
    ctrl_write = 1'b0;
    ctrl_reload = 1'b0;
    mem_we = 1'b0;
    mem_strobe = 1'b0;
    case(state)
        rw_hit: begin
            ctrl_hit = 1'b1;
        end
        load_addr: begin
            ctrl_write = 1'b1;
            mem_strobe = 1'b0;
        end
        write_back: begin
            ctrl_write = 1'b1;
            mem_we = 1'b1;
            mem_strobe = 1'b1;
        end
        mem_reset: begin
            mem_strobe = 1'b0;
        end
        reload: begin
            ctrl_reload = 1'b1;
            mem_strobe = 1'b1;
        end
        default : ;
    endcase
end

always_comb
begin : next_state_logic
    next_state = state;
    case(state)
        rw_hit: begin
            if(cpu_strobe && ~cpu_resp) begin
                if((~cache_lru && cache_dirty[0]) || 
                    (cache_lru && cache_dirty[1]))
                    next_state = load_addr;
                else
                    next_state = mem_reset;
            end
        end
        load_addr: begin
            next_state = write_back;
        end
        write_back: begin
            if(mem_resp)
                next_state = mem_reset;
        end
        mem_reset: begin
            next_state = reload;
        end
        reload: begin
            if(mem_resp)
                next_state = rw_hit;
        end
        default : ;
    endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_state;
end

endmodule : cache_control