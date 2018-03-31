import lc3b_types::*;

module dataforward
(
    input clk,
    input logic wb_mem_required,
    input lc3b_reg wb_dest,
    input lc3b_reg ex_dest,
    input lc3b_reg ex_src1,
    input lc3b_reg ex_src2,

    output logic ex_sel1,
    output logic ex_sel2,
    output logic mem_sel
);


always_ff @(posedge clk)
begin

    if(wb_mem_required) begin // if instruction is something like ldr str, forward from wb
        if (wb_dest == ex_dest) // if source reg data is outdated
            mem_sel = 1;
        else
            mem_sel = 0;

        if (wb_dest == ex_src1) // if alu data is outdated
            ex_sel1 = 1;
        else
            ex_sel1 = 0;

        if (wb_dest == ex_src2)
            ex_sel2 = 1;
        else
            ex_sel2 = 0;
    end
    else begin // else forward from mem stage
        if (ex_dest == ex_src1) // forward back computation data
            ex_sel1 = 2; // 2 for ex_alu_out
        else
            ex_sel1 = 0;

        if (ex_dest == ex_src2)
            ex_sel2 = 2;
        else
            ex_sel2 = 0;
    end
end

endmodule : dataforward
