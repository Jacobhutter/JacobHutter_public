import lc3b_types::*;

module cachelru4 (
    input clk,
    input [3:0] tagmatches, // One-hot encoding of matching tags
    input lc3b_c_index index,
    input ctrl_hit,
    output [3:0] lru_sel // One-hot encoding of least-recently-used way
);

logic lru_write;
logic [2:0] lru_in, lru_out; 
logic [1:0] tag_decode, lru_decode;
assign lru_write = ctrl_hit && (tagmatches != 0);

// Pseudo LRU should track most-recently accessed elements, like in lecture slides
array #(.width(3)) lru_arr (
    .clk,
    .write(lru_write),
    .index,
    .datain(lru_in),
    .dataout(lru_out)
);

always_comb
begin
    tag_decode = 0;
    case(tagmatches)
        4'b0001: tag_decode = 0;
        4'b0010: tag_decode = 1;
        4'b0100: tag_decode = 2;
        4'b1000: tag_decode = 3;
        default : ;
    endcase
    // Maybe put this in a for loop later for >4 ways...
    lru_in = lru_out;
    lru_in[2] = tag_decode[1];
    if(tag_decode[1])
        lru_in[0] = tag_decode[0];
    else
        lru_in[1] = tag_decode[0];
    
    lru_decode = ~lru_out[2:1];
    if(~lru_out[2])
        lru_decode[0] = ~lru_out[0]; 
end

assign lru_sel = 1 << lru_decode;



endmodule : cachelru4

    