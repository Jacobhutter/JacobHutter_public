import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module control
(
	input clk,
	/* Datapath controls */
	input lc3b_opcode opcode, 
	input  immediate,
	input lc3b_reg base_r,
	output logic load_pc, 
	output logic load_ir, 
	output logic load_regfile, 
	output lc3b_aluop aluop, 
	output logic load_mar,
	output logic load_mdr,
	output logic load_cc,
	output lc3b_sel pcmux_sel,
	output logic storemux_sel,
	output logic destmux_sel,
	output lc3b_sel alumux_sel,
	output lc3b_sel regfilemux_sel,
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
	 s_add_decide,
	 s_add,
	 s_add_i,
	 s_and_decide,
	 s_and,
	 s_and_i,
	 s_not,
	 s_calc_addr,
	 s_ldr1,
	 s_ldr2,
	 s_str1,
	 s_str2,
	 s_br,
	 s_br_taken,
	 s_jmp,
	 s_jmp2,
	 s_ret
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
	 pcmux_sel = 2'b00;
	 storemux_sel = 1'b0;
	 alumux_sel = 2'b00;
	 regfilemux_sel = 2'b00;
	 destmux_sel = 1'b0;
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
			pcmux_sel = 2'b00; 
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
		
		s_add_decide: /* Do nothing */;
		
		s_add: begin 
			/* DR <= SRA + SRB */ 
			aluop = alu_add; 
			load_regfile = 1; 
			regfilemux_sel = 2'b00; 
			load_cc = 1; 
		end
		
		s_add_i: begin
			aluop = alu_add;
			load_regfile = 1;
			regfilemux_sel = 2'b00;
			load_cc = 1;
			alumux_sel = 2'b10; // select the imm5 from ir 
		end
		
		s_and_decide: /* Do Nothing */;
		
		s_and: begin
			aluop = alu_and;
			load_regfile = 1;
			load_cc = 1;
			alumux_sel = 2'b00;
		end
		
		s_and_i: begin
			aluop = alu_and;
			load_regfile = 1;
			load_cc = 1;
			alumux_sel = 2'b10;
		end
		
		s_not: begin
			aluop = alu_not;
			load_regfile = 1;
			load_cc = 1;
		end
		
		s_calc_addr: begin
			alumux_sel = 2'b01;
			aluop = alu_add;
			load_mar = 1;
		end
		
		s_ldr1: begin
			mdrmux_sel = 1;
			load_mdr = 1;
			mem_read = 1;
		end
		
		s_ldr2: begin
			regfilemux_sel = 2'b01;
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
			pcmux_sel = 2'b01;
			load_pc = 1;
		end
		
		s_jmp: begin
			regfilemux_sel = 2'b10; 
			destmux_sel = 1; // load r7 with pc 
		end
		
		s_jmp2: begin
			aluop = alu_pass;
			pcmux_sel = 2'b10;
			load_pc = 1; // load pc with register value
		end
		
		s_ret: begin
			aluop = alu_pass;
			pcmux_sel = 2'b10;
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
					next_state <= s_add_decide;
				end
				
				op_and: begin
					next_state <= s_and_decide;
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
				
				op_jmp: begin
					if base_r == 3'b111
						next_state <= s_ret;
					else
						next_state <= s_jmp;
				end
				
				default: 
					next_state <= fetch1;
				
			endcase 
			
		end 
		
		s_add_decide: begin
			if(immediate)
				next_state <= s_add_i;
			else
				next_state <= s_add;
		end
		
		s_add: begin
			next_state <= fetch1;
		end
		
		s_add_i: begin 
			next_state <= fetch1;
		end
		
		s_and_decide: begin
			if(immediate)
				next_state <= s_and_i;
			else
				next_state <= s_and;
		end
		
		s_and: begin
			next_state <= fetch1;
		end
		
		s_and_i: begin
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
		
		s_jmp: begin
			next_state <= s_jmp2;
		end 
		
		s_jmp2: begin
			next_state <= fetch1;
		end
		
		s_ret: begin
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
