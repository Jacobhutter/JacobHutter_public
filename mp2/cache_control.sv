import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module cache_control
(
	input clk,
	
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
	 s_ret,
	 s_lea,
	 s_jsr1,
	 s_jsr2,
	 s_jsrr1,
	 s_calc_addr_ldb,
	 s_ldb1,
	 s_ldb2,
	 s_lshf,
	 s_rshf,
	 s_rshfa,
	 s_trap1,
	 s_trap2,
	 s_trap3,
	 s_trap4,
	 s_calc_addr_stb,
	 s_stb1,
	 s_stb2,
	 s_calc_addr_ldi,
	 s_ldi1,
	 s_ldi2,
	 s_ldi3,
	 s_ldi4,
	 s_calc_addr_sti,
	 s_sti1,
	 s_sti2,
	 s_sti3,
	 s_sti4
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
	 adj6mux_sel = 1'b0;
	 alumux_sel = 2'b00;
	 regfilemux_sel = 2'b00;
	 destmux_sel = 1'b0;
	 marmux_sel = 2'b00;
	 mdrmux_sel = 2'b00;
	 aluop = alu_add;
	 mem_read = 1'b0;
	 mem_write = 1'b0;
	 mem_byte_enable = 2'b11;
    /* et cetera (see Appendix E) */

	 case(state)
		fetch1: begin
			/* MAR <= PC */
			marmux_sel = 2'b01;
			load_mar = 1;

			/* PC <= PC + 2 */
			pcmux_sel = 2'b00;
			load_pc = 1;
		end

		fetch2: begin
			/* Read memory */
			mem_read = 1;
			mdrmux_sel = 2'b01;
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
			mdrmux_sel = 2'b01;
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
			aluop = alu_pass;
			pcmux_sel = 2'b10;
			load_pc = 1; // load pc with register value
		end

		s_ret: begin
			aluop = alu_pass;
			pcmux_sel = 2'b10;
			load_pc = 1;
		end

		s_lea: begin
			regfilemux_sel = 2'b11; // push pc + offset9 into regfile in
			load_regfile = 1;
			load_cc = 1;
		end

		s_jsr1: begin
			regfilemux_sel = 2'b10;
			destmux_sel = 1;
			load_regfile = 1; // load r7 with pc
		end

		s_jsr2: begin
			pcmux_sel = 2'b01;
			load_pc = 1; // load pc with PC + (sext(PCoffset9)<<1)
		end

		s_jsrr1: begin
			aluop = alu_pass;
			pcmux_sel = 2'b10;
			load_pc = 1; // pass register value through alu into pcmux and load pc
		end

		s_calc_addr_ldb: begin
			adj6mux_sel = 1; // select adj6 with no shift
			alumux_sel = 2'b01;
			aluop = alu_add;
			load_mar = 1; // find the correct address and put it in mar
		end

		s_ldb1: begin
			mem_read = 1; // receive lower byte from memory? if not it is masked
			mem_byte_enable = 2'b01;
			mdrmux_sel = 2'b11;
			load_mdr = 1;
		end

		s_ldb2: begin
			regfilemux_sel = 2'b01;
			load_regfile = 1;
			load_cc = 1; // place lower byte into dest reg
		end

		s_lshf: begin
			alumux_sel = 2'b11;
			aluop = alu_sll;
			load_regfile = 1;
			load_cc = 1; // logical shift left with condition codes
		end

		s_rshf: begin
			alumux_sel = 2'b11;
			aluop = alu_srl;
			load_regfile = 1;
			load_cc = 1; // logical shift right with condition codes
		end

		s_rshfa: begin
			alumux_sel = 2'b11;
			aluop = alu_sra;
			load_regfile = 1;
			load_cc = 1; // arithmetic shift right with condition codes
		end

		s_trap1: begin 
			regfilemux_sel = 2'b10;
			destmux_sel = 1;
			load_regfile = 1; // load r7 with pc
		end

		s_trap2: begin 
			marmux_sel = 2'b10;
			load_mar = 1; // put value in mar
		end

		s_trap3: begin
			mem_read = 1;
			mdrmux_sel = 2'b01;
			load_mdr = 1; // read memory
		end

		s_trap4: begin
			pcmux_sel = 2'b11;
			load_pc = 1; // put mdr val in pc
		end

		s_calc_addr_stb: begin
			adj6mux_sel = 1'b1;
			alumux_sel = 2'b01;
			aluop = alu_add;
			load_mar = 1; // find the correct address and put it in mar
		end

		s_stb1: begin
			storemux_sel = 1;
			mdrmux_sel = 2'b10; // load only zero extended low byte of alu out
			aluop = alu_pass;
			load_mdr = 1;
		end

		s_stb2: begin
			if(mem_address[0] == 1)
				mem_byte_enable = 2'b10;
			else
				mem_byte_enable = 2'b01;
			mem_write = 1;
		end
		
		s_calc_addr_ldi: begin
			alumux_sel = 2'b01;
			aluop = alu_add;
			load_mar = 1;			
		end
		
		s_ldi1: begin
			mdrmux_sel = 2'b01;
			load_mdr = 1;
			mem_read = 1;
		end
		
		s_ldi2: begin
			marmux_sel = 2'b11; // feed in mdr data back into mar
			load_mar = 1;	
		end
		
		s_ldi3: begin
			mdrmux_sel = 2'b01;
			load_mdr = 1;
			mem_read = 1;
		end
		
		s_ldi4: begin
			regfilemux_sel = 2'b01;
			load_regfile = 1;
			load_cc = 1;
		end
		
		s_calc_addr_sti: begin
			alumux_sel = 2'b01;
			aluop = alu_add;
			load_mar = 1;	
		end
		
		s_sti1: begin
			mdrmux_sel = 2'b01;
			load_mdr = 1;
			mem_read = 1;
		end
		
		s_sti2: begin
			marmux_sel = 2'b11; // feed in mdr data back into mar
			load_mar = 1;	
		end
		
		s_sti3: begin
			storemux_sel = 1;
			aluop = alu_pass;
			load_mdr = 1;
		end
		
		s_sti4: begin
			mem_write = 1;			
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
					if (base_r == 3'b111)
						next_state <= s_ret;
					else
						next_state <= s_jmp;
				end

				op_lea: begin
					next_state <= s_lea;
				end

				op_jsr: begin
					next_state <= s_jsr1;
				end

				op_ldb: begin
					next_state <= s_calc_addr_ldb;
				end

				op_shf: begin
					if(d == 0)
						next_state <= s_lshf;
					else if (a == 0)
						next_state <= s_rshf;
					else
						next_state <= s_rshfa;
				end

				op_trap: begin
					next_state <= s_trap1;
				end

				op_stb: begin
					next_state <= s_calc_addr_stb;
				end
				
				op_ldi: begin
					next_state <= s_calc_addr_ldi;
				end
				
				op_sti: begin
					next_state <= s_calc_addr_sti;
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
			next_state <= fetch1;
		end

		s_ret: begin
			next_state <= fetch1;
		end

		s_lea: begin
			next_state <= fetch1;
		end

		s_jsr1: begin
			if(jsr_trigger == 0)
				next_state <= s_jsrr1;
			else
				next_state <= s_jsr2;
		end

		s_jsr2: begin
			next_state <= fetch1;
		end

		s_jsrr1: begin
			next_state <= fetch1;
		end

		s_calc_addr_ldb: begin
			next_state <= s_ldb1;
		end

		s_ldb1: begin
			if(mem_resp == 0)
				next_state <= s_ldb1;
			else
				next_state <= s_ldb2;
		end

		s_ldb2: begin
			next_state <= fetch1;
		end

		s_lshf: begin
			next_state <= fetch1;
		end

		s_rshf: begin
			next_state <= fetch1;
		end

		s_rshfa: begin
			next_state <= fetch1;
		end

		s_trap1: begin
			next_state <= s_trap2;
		end

		s_trap2: begin
			next_state <= s_trap3;
		end

		s_trap3: begin
			if(mem_resp == 0)
				next_state <= s_trap3;
			else
				next_state <= s_trap4;
		end

		s_trap4: begin
			next_state <= fetch1;
		end

		s_calc_addr_stb: begin
			next_state <= s_stb1;
		end

		s_stb1: begin
			next_state <= s_stb2;
		end

		s_stb2: begin
			if(mem_resp == 0)
				next_state <= s_stb2;
			else
				next_state <= fetch1;
		end
		
		s_calc_addr_ldi: begin
			next_state <= s_ldi1;
		end
		
		s_ldi1: begin
			if(mem_resp == 0)
				next_state <= s_ldi1;
			else
				next_state <= s_ldi2;
		end
		
		s_ldi2: begin
			next_state <= s_ldi3;
		end
		
		s_ldi3: begin
			if(mem_resp == 0)
				next_state <= s_ldi3;
			else
				next_state <= s_ldi4;
		end
		
		s_ldi4: begin
			next_state <= fetch1;
		end
		
		s_calc_addr_sti: begin
			next_state <= s_sti1;
		end
		
		s_sti1: begin
			if(mem_resp == 0)
				next_state <= s_sti1;
			else
				next_state <= s_sti2;
		end
		
		s_sti2: begin
			next_state <= s_sti3;
		end
		
		s_sti3: begin
			next_state <= s_sti4;
		end
		
		s_sti4: begin
			if(mem_resp == 0)
				next_state <= s_sti4;
			else
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

endmodule : cache_control
