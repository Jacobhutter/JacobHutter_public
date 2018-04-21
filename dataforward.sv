import lc3b_types::*;

module dataforward
(
    input lc3b_reg ex_dest,
    input lc3b_reg wb_dest,
    input lc3b_reg mem_dest,
    input lc3b_reg ex_src1,
    input lc3b_reg ex_src2,
    
    input mem_valid_dest,
    input wb_valid_dest,
    input mem_access,
    
    output logic [1:0] ex_sel1,
    output logic [1:0] ex_sel2,
    output logic [1:0] ex_storesel
);

always_comb
begin
    ex_sel1 = 0;
    if(mem_valid_dest && mem_dest == ex_src1 && !mem_access)
        ex_sel1 = 1;
    else if(mem_valid_dest && mem_dest == ex_src1)
        ex_sel1 = 2;
    else if(wb_valid_dest && wb_dest == ex_src1)
        ex_sel1 = 3;
    
    ex_sel2 = 0;
    if(mem_valid_dest && mem_dest == ex_src2 && !mem_access)
        ex_sel2 = 1;
    else if(mem_valid_dest && mem_dest == ex_src2)
        ex_sel2 = 2;
    else if(wb_valid_dest && wb_dest == ex_src2)
        ex_sel2 = 3;
    
    ex_storesel = 0;
    if(mem_valid_dest && mem_dest == ex_dest && !mem_access)
        ex_storesel = 1;
    else if(mem_valid_dest && mem_dest == ex_dest)
        ex_storesel = 2;
    else if(wb_valid_dest && wb_dest == ex_dest)
        ex_storesel = 3;
    

end

endmodule : dataforward
