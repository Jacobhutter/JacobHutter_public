import lc3b_types::*;

module cache_datapath
(
  input clk,
  input lc3b_word address,
  input lc3b_c_line data_in,
  input write_enable,
  input control_load,

  output logic hit,
  output lc3b_c_line data_out,
  output logic dirty
);

logic load_data;
logic dirty1_out;
logic dirty2_out;
logic [2:0] offset;
logic [2:0] index;
logic [9:0] tag;
logic hit1;
logic hit2;
logic lru_out;
logic lru_in;
logic data1_write;
logic data2_write;
logic [3:0] valid_tag_in1;
logic [3:0] valid_tag_out1;
logic [3:0] valid_tag_in2;
logic [3:0] valid_tag_out2;

lc3lc3b_c_line data1_out;
lc3lc3b_c_line data2_out;

always_comb begin
  hit = hit1 | hit2;
  lru_in = ~lru_out;
  offset = address[2:0];
  index = address[5:3];
  tag = address[15:6];
  dirty = dirty1 | dirty2;
  load_data = hit & write_enable | control_load;
  if(hit1)
    data_out = data1_out;
  else if(hit2)
    data_out = data2_out;
  else
    data_out = 128'd0;
end

array #(.width(1)) lru
(
  .clk,
  .write(load_data),
  .index,
  .datain(lru_in),
  .dataout(lru_out)
);

always_comb begin
  if lru_out == 0 begin
    data1_write = load_data;
    data2_write = 0;
  end
  else begin
    data1_write = 0;
    data2_write = load_data;
  end
end

/* instantiate 8 128 bit data arrays for way 1 */
array data1
(
    .clk,
    .write(data1_write),
    .index,
    .datain(data_in),
    .dataout(data1_out)
);

/* instantiate 8 128 bit data arrays for way 2 */
array data2
(
  .clk,
  .write(data2_write),
  .index,
  .datain(data_in),
  .dataout(data2_out)
);

always_comb begin
  valid_tag_in1 = 4'{1'b1, tag}
  valid_tag_in2 = 4'{1'b1, tag}
  hit1 = valid_tag_out1 & 4'b{1'b1, tag}
  hit2 = valid_tag_out2 & 4'b{1'b1, tag}
end

array #(.width(4)) valid_tag1
(
  .clk,
  .write(data1_write),
  .index,
  .datain(valid_tag_in1),
  .dataout(valid_tag_out2)
);

array #(.width(4)) valid_tag2
(
  .clk,
  .write(data2_write),
  .index,
  .datain(valid_tag_in1),
  .dataout(valid_tag_out2)
);

array #(.width(1)) dirty1
(
  .clk,
  .write(data1_write),
  .index,
  .datain(1'b1),
  .dataout(dirty1_out)
);

array #(.width(1)) dirty2
(
  .clk,
  .write(data2_write),
  .index,
  .datain(1'b1),
  .dataout(dirty2_out)
);

endmodule : cache_datapath
