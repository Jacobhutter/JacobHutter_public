import lc3b_types::*;

module cache_datapath (
    input clk,
    /* From control unit */
    input ctrl_reload,
    input ctrl_write,
    input ctrl_hit,
    
    /* To control unit */
    output logic lru_out,
    output logic [1:0] dirty_out,
    
    /* From cpu */
    input lc3b_word cpu_address,
    input lc3b_word cpu_sel,
    input lc3b_c_line cpu_datain,
    input cpu_read,
    input cpu_write,
    
    /* To cpu */
    output cpu_resp,
    output lc3b_c_line cpu_dataout,
    
    /* From memory */
    input lc3b_c_line mem_datain,
    input mem_resp,
    
    /* To memory */
    output lc3b_word mem_address,
    output lc3b_c_line mem_dataout
    
);

lc3b_c_tag cpu_tag;
lc3b_c_index cpu_index;

assign cpu_tag = cpu_address[15:7];
assign cpu_index = cpu_address[6:4];

logic tagwrite_out0, tagwrite_out1;
logic dirty_out0, dirty_out1;
logic valid_out0, valid_out1; 
lc3b_c_tag tag_out0, tag_out1;
logic tag_match0, tag_match1;
logic lruwrite_out, dirtywrite_out0, dirtywrite_out1;
logic datawrite_out0, datawrite_out1;
lc3b_c_line data_out0, data_out1;
lc3b_c_line selway_cache_out, selway_dirty_out, wordswap_out;

assign cpu_dataout = selway_cache_out;
assign mem_dataout = selway_dirty_out;
assign dirty_out = {dirty_out1, dirty_out0};

tagwrite tag_write0
(
    .ctrl_reload,
    .lru_switch(~lru_out),
    .mem_resp,
    .write(tagwrite_out0)
);

array #(.width(1)) valid_arr0 
(
    .clk,
    .write(tagwrite_out0),
    .index(cpu_index),
    .datain(1'b1),
    .dataout(valid_out0)
);

array #(.width(9)) tag_arr0
(
    .clk,
    .write(tagwrite_out0),
    .index(cpu_index),
    .datain(cpu_tag),
    .dataout(tag_out0)
);

tagwrite tag_write1
(
    .ctrl_reload,
    .lru_switch(lru_out),
    .mem_resp,
    .write(tagwrite_out1)
);

array #(.width(1)) valid_arr1 
(
    .clk,
    .write(tagwrite_out1),
    .index(cpu_index),
    .datain(1'b1),
    .dataout(valid_out1)
);

array #(.width(9)) tag_arr1
(
    .clk,
    .write(tagwrite_out1),
    .index(cpu_index),
    .datain(cpu_tag),
    .dataout(tag_out1)
);

tagchecker tag_checker
(
    .valid0(valid_out0),
    .valid1(valid_out1),
    .tag0(tag_out0),
    .tag1(tag_out1),
    .addr_tag(cpu_tag),
    .match0(tag_match0),
    .match1(tag_match1),
    .cpu_resp
);

lruwrite lru_write
(
    .ctrl_hit,
    .match0(tag_match0),
    .match1(tag_match1),
    .write(lruwrite_out)
);

array #(.width(1)) lru_arr
(
    .clk,
    .write(lruwrite_out),
    .index(cpu_index),
    .datain(tag_match0),
    .dataout(lru_out)
);

dirtywrite dirty_write0
(
    .ctrl_hit,
    .ctrl_reload,
    .lru_switch(~lru_out),
    .tag_match(tag_match0),
    .cpu_write,
    .write(dirtywrite_out0)
);

array #(.width(1)) dirty_arr0
(
    .clk,
    .write(dirtywrite_out0),
    .index(cpu_index),
    .datain(~ctrl_reload),
    .dataout(dirty_out0)
);

dirtywrite dirty_write1
(
    .ctrl_hit,
    .ctrl_reload,
    .lru_switch(lru_out),
    .tag_match(tag_match1),
    .cpu_write,
    .write(dirtywrite_out1)
);

array #(.width(1)) dirty_arr1
(
    .clk,
    .write(dirtywrite_out1),
    .index(cpu_index),
    .datain(~ctrl_reload),
    .dataout(dirty_out1)
);

wordswap word_swap
(
    .cpu_sel, 
    .cpu_write,
    .cpu_datain,
    .mem_datain, 
    .cache_line(selway_cache_out),
    .ctrl_reload,
    .out(wordswap_out)
);

datawrite data_write0
(
    .ctrl_hit, 
    .ctrl_reload,
    .cpu_write,
    .lru_switch(~lru_out), 
    .tag_match(tag_match0),
    .write(datawrite_out0)
);

array #(.width(128)) data_arr0
(
    .clk,
    .write(datawrite_out0),
    .index(cpu_index),
    .datain(wordswap_out),
    .dataout(data_out0)
);

datawrite data_write1
(
    .ctrl_hit, 
    .ctrl_reload,
    .cpu_write,
    .lru_switch(lru_out), 
    .tag_match(tag_match1),
    .write(datawrite_out1)
);

array #(.width(128)) data_arr1
(
    .clk,
    .write(datawrite_out1),
    .index(cpu_index),
    .datain(wordswap_out),
    .dataout(data_out1)
);

selectway sel_way_cache
(
    .match0(tag_match0), 
    .match1(tag_match1),
    .way0(data_out0), 
    .way1(data_out1),
    .out(selway_cache_out)
);

selectway sel_way_dirty
(
    .match0(~lru_out), 
    .match1(lru_out),
    .way0(data_out0), 
    .way1(data_out1),
    .out(selway_dirty_out)
);

swapaddress swap_address
(
    .ctrl_write,
    .cpu_addr(cpu_address),
    .lru_switch(lru_out),
    .tag0(tag_out0), 
    .tag1(tag_out1),
    .mem_addr(mem_address)
);

endmodule: cache_datapath
