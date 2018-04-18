import lc3b_types::*;
module control_rom
(
    input lc3b_opcode opcode,
    input logic [2:0] bits4_5_11,
    output lc3b_control_word ctrl
);

always_comb
begin
   ctrl.opcode = opcode;
   ctrl.aluop = alu_add;
   ctrl.load_cc = 1'b0;
   ctrl.load_pc = 1'b0;
   ctrl.load_regfile = 1'b0;
   ctrl.alumux_sel = 3'b000;
   ctrl.pcmux_sel = 2'b00;
   ctrl.mem_read = 1'b0;
   ctrl.mem_write = 1'b0;
   ctrl.offsetmux_sel = 1'b0;
   ctrl.storemux_sel = 1'b0;
   ctrl.destmux_sel = 1'b0;
   ctrl.regfilemux_sel = 2'b00;
   ctrl.marmux_sel = 2'b00;
   ctrl.mdrmux_sel = 2'b00;
   ctrl.wordinmux_sel = 1'b0;
   ctrl.offset6mux_sel = 1'b0;
   ctrl.valid_branch = 1'b0;
   ctrl.valid_dest = 1'b0;
   ctrl.alubasemux_sel = 1'b0;
	ctrl.predicted_branch = 1'b0; // track predicted branch value
    ctrl.reg_mode = 1'b0;
    
   case(opcode)
       op_add: begin
           
           if(bits4_5_11[1]) begin
                ctrl.alumux_sel = 3'b011; // select immediate add
           end
           else begin
                ctrl.alumux_sel = 3'b000;
           end
           ctrl.aluop = alu_add;
           ctrl.load_cc = 1;
           ctrl.load_regfile = 1;
           ctrl.valid_dest = 1'b1;
       end

       op_and: begin
           if(bits4_5_11[1]) begin
                ctrl.alumux_sel = 3'b011; // select immediate and
           end
           else begin
                ctrl.alumux_sel = 3'b000;
           end
           ctrl.aluop = alu_and;
           ctrl.load_cc = 1;
           ctrl.load_regfile = 1;
           ctrl.valid_dest = 1'b1;
       end

       op_jmp: begin // also ret
            ctrl.aluop = alu_pass;
            ctrl.pcmux_sel = 2'b10;
				ctrl.valid_branch = 1'b1;
       end

       op_jsr: begin
            ctrl.regfilemux_sel = 2'b10; // select pc
            ctrl.load_regfile = 1; // load regfile
            ctrl.destmux_sel = 1; //set dest to 7
				ctrl.valid_branch = 1'b1;
            if(bits4_5_11[2] == 0) begin
                ctrl.aluop = alu_pass; // base reg value
                ctrl.pcmux_sel = 2'b10; // select aluout
            end
            else begin
                ctrl.offsetmux_sel = 1; // seelect offset 11
                 ctrl.pcmux_sel = 2'b01;
            end
            ctrl.reg_mode = bits4_5_11[2];
       end

       op_not: begin
           ctrl.aluop = alu_not;
           ctrl.load_cc = 1;
           ctrl.load_regfile = 1;
           ctrl.valid_dest = 1'b1;
       end

       op_ldi: begin // identical to ldr, state_controller will handle second cycle
          ctrl.aluop = alu_add;
          ctrl.mem_read = 1;
          ctrl.mdrmux_sel = 2'b01; // sel read dat
          ctrl.alumux_sel = 3'b001;
          ctrl.regfilemux_sel = 2'b01; // read data from memory
			 ctrl.load_regfile = 1;
			 ctrl.load_cc = 1;
          ctrl.valid_dest = 1'b1;
       end
		 
		 op_sti: begin  // identical to ldr, get address first and then write
			 ctrl.aluop = alu_add;
          ctrl.mem_write = 1;
          ctrl.mdrmux_sel = 2'b01; // sel read dat
          ctrl.alumux_sel = 3'b001;
          ctrl.regfilemux_sel = 2'b01; // read data from memory
			 ctrl.storemux_sel = 1; // load store data
			 ctrl.load_cc = 1;
		 end

       op_ldr: begin
           ctrl.aluop = alu_add;
           ctrl.mem_read = 1;
           ctrl.mdrmux_sel = 2'b01; // sel read dat
			  ctrl.alumux_sel = 3'b001;
			  ctrl.regfilemux_sel = 2'b01; // read data from memory
           ctrl.load_regfile = 1;
			  ctrl.load_cc = 1;
           ctrl.valid_dest = 1'b1;
       end

       op_lea: begin
            ctrl.alumux_sel = 3'b010;
            ctrl.aluop = alu_add;
            ctrl.regfilemux_sel = 2'b00; // sel br_add_out to load into dest register
            ctrl.load_regfile = 1;
            ctrl.load_cc = 1;
            ctrl.valid_dest = 1'b1;
            ctrl.alubasemux_sel = 1'b1;
       end

       op_ldb: begin
            ctrl.aluop = alu_add;
            ctrl.mem_read = 1;
            ctrl.mdrmux_sel = 2'b01; // sel read dat
            ctrl.alumux_sel = 3'b001;
            ctrl.regfilemux_sel = 2'b01; // read data from memory
            ctrl.load_regfile = 1;
            ctrl.wordinmux_sel = 1; // select half word input
				ctrl.load_cc = 1;
            ctrl.offset6mux_sel = 1'b1;
            ctrl.valid_dest = 1'b1;
       end

       op_stb: begin
           ctrl.aluop = alu_add;
           ctrl.mem_write = 1;
           ctrl.alumux_sel = 3'b001;
           ctrl.mdrmux_sel = 2'b10; // sel half write dat
           ctrl.storemux_sel = 1;
           ctrl.offset6mux_sel = 1'b1;
       end

       op_str: begin
           ctrl.aluop = alu_add;
           ctrl.mem_write = 1;
           ctrl.alumux_sel = 3'b001;
           ctrl.mdrmux_sel = 2'b00; // sel write dat
           ctrl.storemux_sel = 1;
       end

       op_shf: begin
            if(bits4_5_11[0] == 0) begin // d == 0
                ctrl.aluop = alu_sll;
            end
            else if (bits4_5_11[1] == 0)begin // a == 0
                ctrl.aluop = alu_srl;
            end
            else begin
                ctrl.aluop = alu_sra;
            end
            ctrl.load_regfile = 1;
            ctrl.alumux_sel = 3'b100; // select imm4
            ctrl.load_cc = 1;
            ctrl.valid_dest = 1'b1;
       end

		 op_br: begin
              // no need to load pc, just queue up data and let advance do the rest
              ctrl.pcmux_sel = 2'b01; // sel br_add and we compare when needed i.e. when command gets to wb, cc is compare
              ctrl.valid_branch = 1'b1;
         end

       op_trap: begin
           ctrl.regfilemux_sel = 2'b10; // select pc
           ctrl.load_regfile = 1; // load regfile
           ctrl.destmux_sel = 1; //set dest to 7
           ctrl.marmux_sel = 2'b01; // select trap input
           ctrl.mem_read = 1;
           ctrl.mdrmux_sel = 2'b01; // data in mdr = memrdata
           ctrl.pcmux_sel = 2'b11; // put memwdata into pc
			  ctrl.valid_branch = 1'b1;
       end

       default: begin
           ctrl = 0;
       end
    endcase
end

endmodule : control_rom
