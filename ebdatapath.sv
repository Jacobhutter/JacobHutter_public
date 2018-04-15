import lc3b_types::*;

module ebdatapath
(
    input clk,
    input lc3b_address orig_address,
    input lc3b_c_line orig_dataout,
    input lc3b_c_line dest_dataout,
    
    output lc3b_address dest_address,
    output lc3b_c_line orig_datain,
    output lc3b_c_line dest_datain,
    
    input dataout_mux,
    input datain_mux,
    input buffer_write,
    output hit_detect 
);

lc3b_c_line cline_out;
lc3b_address addr_out;
logic valid_out;

register #(.width($size(lc3b_c_line))) cache_reg
(
    .clk,
    .load(buffer_write),
    .in(orig_dataout),
    .out(cline_out)
);

register #(.width($size(lc3b_address))) addr_reg
(
    .clk,
    .load(buffer_write),
    .in(orig_address),
    .out(addr_out)
);

register #(.width(1)) valid_reg
(
    .clk,
    .load(buffer_write),
    .in(1'b1),
    .out(valid_out)
);

ebhitchecker eb_hit_checker
(
    .orig_address,
    .buf_address(addr_out),
    .buf_valid(valid_out),
    .hit_detect
);

mux2 #(.width($size(lc3b_address))) slave_addr_mux
(
    .sel(dataout_mux),
    .a(orig_address),
    .b(addr_out),
    .f(dest_address)
);

mux2 #(.width($size(lc3b_c_line))) slave_cline_mux
(
    .sel(dataout_mux),
    .a(orig_dataout),
    .b(cline_out),
    .f(dest_datain)
);

mux2 #(.width($size(lc3b_c_line))) master_cline_mux
(
    .sel(datain_mux),
    .a(dest_dataout),
    .b(cline_out),
    .f(orig_datain)
);

endmodule : ebdatapath
