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
    .in(1),
    .out(valid_out)
);

hitchecker hit_checker
(
    .orig_address,
    .orig_datain,
    .buf_cache(cline_out),
    .buf_address(addr_out),
    .buf_valid(valid_out)
);

mux2 #(.width($size(lc3b_address))) slave_addr_mux
(
    .sel(dataout_mux),
    .a(orig_dataout),
    .b(cline_out),
    .f(dest_address)
);

mux2 #(.width($size(lc3b_c_line))) slave_cline_mux
(
    .sel(dataout_mux),
    .a(orig_address),
    .b(addr_out),
    .f(dest_datain)
);



endmodule : ebdatapath
