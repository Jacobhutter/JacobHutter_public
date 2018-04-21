import lc3b_types::*;

module cache4_datapath (
    input clk,
    /* From control unit */
    input ctrl_reload,
    input ctrl_write,
    input ctrl_hit,
    
    /* To control unit */
    output logic need_writeback,
    
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

parameter NUM_WAYS = 4;

lc3b_c_tag cpu_tag;
lc3b_c_index cpu_index;

assign cpu_tag = cpu_address[15:7];
assign cpu_index = cpu_address[6:4];

logic [NUM_WAYS-1:0] tagwrite_out;
logic [NUM_WAYS-1:0] dirty_out;
logic [NUM_WAYS-1:0] valid_out; 
lc3b_c_tag tag_out[NUM_WAYS];
logic [NUM_WAYS-1:0] tag_match;
logic [NUM_WAYS-1:0] dirtywrite_out;
logic [NUM_WAYS-1:0] datawrite_out;
lc3b_c_line data_out[NUM_WAYS];
lc3b_c_line sel_cache[NUM_WAYS];
lc3b_c_line sel_dirty[NUM_WAYS];
lc3b_c_line selway_cache_out, selway_dirty_out, wordswap_out;
lc3b_word sel_address[NUM_WAYS];

logic [NUM_WAYS-1:0] lru_sel;

assign cpu_dataout = selway_cache_out;
assign mem_dataout = selway_dirty_out;

genvar i;
generate
    for(i = 0; i < NUM_WAYS; i++) begin : gen_tags
        tagwrite4 tag_write
        (
            .lru_sel(lru_sel[i]),
            .ctrl_reload,
            .mem_resp,
            .write(tagwrite_out[i])
        );
        array #(.width(1)) valid_arr 
        (
            .clk,
            .write(tagwrite_out[i]),
            .index(cpu_index),
            .datain(1'b1),
            .dataout(valid_out[i])
        );
        array #(.width(9)) tag_arr
        (
            .clk,
            .write(tagwrite_out[i]),
            .index(cpu_index),
            .datain(cpu_tag),
            .dataout(tag_out[i])
        );
    end
endgenerate

generate 
    for(i = 0; i < NUM_WAYS; i++) begin : gen_tagcheckers
        tagchecker4 tag_checker4 (
            .valid(valid_out[i]),
            .cache_tag(tag_out[i]),
            .addr_tag(cpu_tag),
            .match(tag_match[i])
        );
    end
endgenerate

assign cpu_resp = |tag_match;

cachelru4 cache_lru4(
    .clk,
    .tagmatches(tag_match),
    .index(cpu_index),
    .ctrl_hit,
    .lru_sel 
);

generate
    for(i = 0; i < NUM_WAYS; i++) begin : gen_dirty
        dirtywrite dirty_write
        (
            .ctrl_hit,
            .ctrl_reload,
            .lru_switch(lru_sel[i]),
            .tag_match(tag_match[i]),
            .cpu_write,
            .write(dirtywrite_out[i])
        );
        array #(.width(1)) dirty_arr
        (
            .clk,
            .write(dirtywrite_out[i]),
            .index(cpu_index),
            .datain(~ctrl_reload),
            .dataout(dirty_out[i])
        );
    end
endgenerate

assign need_writeback = |(lru_sel & dirty_out);

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

generate
    for(i = 0; i < NUM_WAYS; i++) begin : gen_data
        datawrite data_write0
        (
            .ctrl_hit, 
            .ctrl_reload,
            .cpu_write,
            .lru_switch(lru_sel[i]), 
            .tag_match(tag_match[i]),
            .write(datawrite_out[i])
        );
        array #(.width(128)) data_arr0
        (
            .clk,
            .write(datawrite_out[i]),
            .index(cpu_index),
            .datain(wordswap_out),
            .dataout(data_out[i])
        );
    end
endgenerate

generate
    for(i = 0; i < NUM_WAYS; i++) begin : gen_selcache
        selectway4 sel_way_cache
        (
            .match(tag_match[i]),
            .way(data_out[i]),
            .out(sel_cache[i])
        );
    end
endgenerate

assign selway_cache_out = sel_cache.or();

generate
    for(i = 0; i < NUM_WAYS; i++) begin : gen_dirtycache
        selectway4 sel_way_cache
        (
            .match(lru_sel[i]),
            .way(data_out[i]),
            .out(sel_dirty[i])
        );
    end
endgenerate

assign selway_dirty_out = sel_dirty.or();

generate
    for(i = 0; i < NUM_WAYS; i++) begin : gen_swapaddress
        swapaddress4 swap_address
        (
            .ctrl_write,
            .cpu_addr(cpu_address),
            .lru_sel(lru_sel[i]),
            .tag(tag_out[i]),
            .mem_addr(sel_address[i])
        );
    end
endgenerate

assign mem_address = sel_address.or();

endmodule: cache4_datapath
