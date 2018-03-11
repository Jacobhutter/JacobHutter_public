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
   ctrl.alumux_sel = 1'b0;
   ctrl.pcmux_sel = 1'b0;
   ctrl.mem_read = 1'b0;
   ctrl.mem_write = 1'b0;
   ctrl.offsetmux_sel = 1'b0;
   ctrl.storemux_sel = 1'b0;
   ctrl.regfilemux_sel = 1'b0;
   ctrl.marmux_sel = 1'b0;
   ctrl.mdrmux_sel = 1'b0;

   case(opcode)
       op_add: begin
           ctrl.aluop = alu_add;
           ctrl.load_cc = 1;
           ctrl.load_regfile = 1;
       end
       op_and: begin
           ctrl.aluop = alu_and;
           ctrl.load_cc = 1;
           ctrl.load_regfile = 1;
       end
       op_not: begin
           ctrl.aluop = alu_not;
           ctrl.load_cc = 1;
           ctrl.load_regfile = 1;
       end
       op_ldr: begin
           ctrl.aluop = alu_add;
           ctrl.mem_read = 1;
           ctrl.mdrmux_sel = 1; // sel read dat
			  ctrl.alumux_sel = 1;
			  ctrl.load_cc = 1;
			  ctrl.regfilemux_sel = 1; // read data from memory
           ctrl.load_regfile = 1;
       end
       op_str: begin
           ctrl.aluop = alu_add;
           ctrl.mem_write = 1;
			  ctrl.alumux_sel = 1;
           ctrl.mdrmux_sel = 0; // sel write dat
           ctrl.load_regfile = 1;
       end
		 
		 op_br: begin
			  ctrl.pcmux_sel = 1; // sel br_add and we compare when needed i.e. when command gets to wb, cc is compared
			  ctrl.load_pc = 0;
		 end 
		 
       default: begin
           ctrl = 0;
       end
    endcase
end

endmodule : control_rom
