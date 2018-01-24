import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module control
(
	input clk,
	/* Datapath controls */
	input lc3b_opcode opcode, 
	output logic load_pc, 
	output logic load_ir, 
	output logic load_regfile, 
	output lc3b_aluop aluop, 
	output logic load_mar,
	output logic load_mdr,
	output logic load_cc,
	output logic pcmux_sel,
	output logic storemux_sel,
	output logic alumux_sel,
	output logic regfilemux_sel,
	output logic marmux_sel,
	output logic mdrmux_sel,
	
	/* Memory signals */ 
	input mem_resp, 
	input branch_enable,
	output logic mem_read, 
	output logic mem_write, 
	output lc3b_mem_wmask mem_byte_enable
);

enum int unsigned {
    fetch1,
	 fetch2,
	 fetch3,
	 decode,
	 s_add,
	 s_and,
	 s_not,
	 s_calc_addr,
	 s_ldr1,
	 s_ldr2,
	 s_str1,
	 s_str2,
	 s_br,
	 s_br_taken
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
	 load_pc = 1'b0; 
	 load_ir = 1'b0; 
	 load_regfile = 1'b0; 
	 load_mar = 1'b0;
	 load_mdr = 1'b0;
	 load_cc = 1'b0;
	 pcmux_sel = 1'b0;
	 storemux_sel = 1'b0;
	 alumux_sel = 1'b0;
	 regfilemux_sel = 1'b0;
	 marmux_sel = 1'b0;
	 mdrmux_sel = 1'b0;
	 aluop = alu_add; 
	 mem_read = 1'b0; 
	 mem_write = 1'b0;
	 mem_byte_enable = 2'b11; 
    /* et cetera (see Appendix E) */
	 
	 case(state) 
		fetch1: begin 
			/* MAR <= PC */ 
			marmux_sel = 1; 
			load_mar = 1;
			
			/* PC <= PC + 2 */ 
			pcmux_sel = 0; 
			load_pc = 1;
		end
		
		fetch2: begin 
			/* Read memory */ 
			mem_read = 1; 
			mdrmux_sel = 1; 
			load_mdr = 1; 
		end
		
		fetch3: begin 
			/* Load IR */ 
			load_ir = 1; 
		end
		
		decode: /* Do nothing */;
		
		s_add: begin 
			/* DR <= SRA + SRB */ 
			aluop = alu_add; 
			load_regfile = 1; 
			regfilemux_sel = 0; 
			load_cc = 1; 
		end
		
		s_and: begin
			aluop = alu_and;
			load_regfile = 1;
			load_cc = 1;
		end
		
		s_not: begin
			aluop = alu_not;
			load_regfile = 1;
			load_cc = 1;
		end
		
		s_calc_addr: begin
			alumux_sel = 1;
			aluop = alu_add;
			load_mar = 1;
		end
		
		s_ldr1: begin
			mdrmux_sel = 1;
			load_mdr = 1;
			mem_read = 1;
		end
		
		s_ldr2: begin
			regfilemux_sel = 1;
			load_regfile = 1;
			load_cc = 1;
		end
		
		s_str1: begin
			storemux_sel = 1;
			aluop = alu_pass;
			load_mdr = 1;
		end
		
		s_str2: begin
			mem_write = 1;
		end
		
		s_br: /* Do Nothing */;
		
		s_br_taken: begin
			pcmux_sel = 1;
			load_pc = 1;
		end
			
		default: /* Do nothing */;
		
	endcase
	
end

always_comb
begin : next_state_logic

	unique case(state)
	
		fetch1 : begin
			next_state <= fetch2;
		end
		
		fetch2: begin
			if(mem_resp == 0)
				next_state <= fetch2;
			else 
				next_state <= fetch3;
		end
		
		fetch3: begin
			next_state <= decode;
		end
		
		decode: begin
		
			case(opcode)
			
				op_add: begin
					next_state <= s_add;
				end
				
				op_and: begin
					next_state <= s_and;
				end
				
				op_not: begin
					next_state <= s_not;
				end
				
				op_ldr: begin
					next_state <= s_calc_addr;
				end
				
				op_str: begin
					next_state <= s_calc_addr;
				end
				
				op_br: begin
					next_state <= s_br;
				end
				
				default: 
					next_state <= fetch1;
				
			endcase 
			
		end 
		
		s_add: begin
			next_state <= fetch1;
		end
		
		s_and: begin
			next_state <= fetch1;
		end
		
		s_not: begin
			next_state <= fetch1;
		end
		
		s_calc_addr: begin
			if(opcode == op_ldr)
				next_state <= s_ldr1;
			else 
				next_state <= s_str1;
		end
		
		s_ldr1: begin
			if(mem_resp == 0)
				next_state <= s_ldr1;
			else 
				next_state <= s_ldr2;
		end
		
		s_ldr2: begin
			next_state <= fetch1;
		end
		
		s_str1: begin	
			next_state <= s_str2;
		end
		
		s_str2: begin
			if(mem_resp == 0)
				next_state <= s_str2;
			else 
				next_state <= fetch1;
		end
		
		s_br: begin
			if(branch_enable == 1)
				next_state <= s_br_taken;
			else 
				next_state <= fetch1;
		end
		
		s_br_taken: begin
			next_state <= fetch1;
		end
		
		default: 
			next_state <= fetch1;
		
	endcase
	
end

always_ff @(posedge clk)
begin: next_state_assignment
    state <= next_state;
end

endmodule : control
