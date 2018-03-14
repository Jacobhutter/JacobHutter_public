module interconnect
(
    wishbone.slave wb_icache,
    wishbone.slave wb_dcache,
    wishbone.master wb_mem
);

enum int unsigned {
    ready, instr, data
} state, next_state;

// State outputs
always_comb 
begin : state_actions
    wb_icache.DAT_S = 0;
    wb_icache.ACK = 0;
    wb_icache.RTY = 0;
    wb_dcache.DAT_S = 0;
    wb_dcache.ACK = 0;
    wb_dcache.RTY = 0;
    
    wb_mem.DAT_M = 0;
    wb_mem.CYC = 0;
    wb_mem.WE = 0;
    wb_mem.SEL = 0;
    wb_mem.ADR = 0;
    wb_mem.STB = 0;
    case(state)
        instr: begin
            wb_icache.DAT_S = wb_mem.DAT_S;
            wb_icache.ACK = wb_mem.ACK;
            wb_icache.RTY = wb_mem.RTY;
            
            wb_mem.DAT_M = wb_icache.DAT_M;
            wb_mem.CYC = wb_icache.CYC;
            wb_mem.WE = wb_icache.WE;
            wb_mem.SEL = wb_icache.SEL;
            wb_mem.ADR = wb_icache.ADR;
            wb_mem.STB = 1;
        end
        data: begin
            wb_dcache.DAT_S = wb_mem.DAT_S;
            wb_dcache.ACK = wb_mem.ACK;
            wb_dcache.RTY = wb_mem.RTY;
            
            wb_mem.DAT_M = wb_dcache.DAT_M;
            wb_mem.CYC = wb_dcache.CYC;
            wb_mem.WE = wb_dcache.WE;
            wb_mem.SEL = wb_dcache.SEL;
            wb_mem.ADR = wb_dcache.ADR;
            wb_mem.STB = 1;
        end
        default: ;
    endcase
end

always_comb
begin : next_state_logic
    next_state = state;
    case(state)
        ready: begin
            if(wb_icache.STB)
                next_state = instr;
            else if(wb_dcache.STB)
                next_state = data;
        end
        instr: begin
            if(!wb_icache.STB)
                next_state = ready;
        end
        data: begin
            if(!wb_dcache.STB)
                next_state = ready;
        end
        default: ;
    endcase
end


always_ff @(posedge wb_icache.CLK)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_state;
end

endmodule : interconnect