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
   ctrl.pcmux_sel = 2'b00;
   ctrl.offsetmux_sel = 1'b0;
   ctrl.storemux_sel = 1'b0
   ctrl.mdrslice_sel = 1'b0;
   ctrl.regfilemux_sel = 1'b0;
   ctrl.marmux_sel = 1'b0;
   ctrl.mdrmux_sel = 1'b0;

   case(opcode)
       op_add: begin
           ctrl.aluop = alu_add;
           ctrl.load_cc = 1;
           ctrl.load_regfile = 1;
           if(bits4_5_11[1])
               ctrl.alumux_sel = 1'b1;

       end
       op_and: begin
           ctrl.aluop = alu_and;
           ctrl.load_cc = 1;
           load_regfile = 1;
           if(bits4_5_11[1])
               ctrl.alumux_sel = 1'b1;
       end
       op_not: begin
           ctrl.aluop = alu_not;
           ctrl.load_cc = 1;
           load_regfile = 1;
           if(bits4_5_11[1])
               ctrl.alumux_sel = 1'b1;
       end
       op_ldr: begin
       end
       op_str: begin
       end
       default: begin
           ctrl = 0;
       end
    endcase
end

endmodule : control_rom
