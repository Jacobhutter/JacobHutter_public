import lc3b_types::*;

module cache_datapath
(
  input logic clk,
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
logic load_dirty1;
logic load_dirty2;
logic dirty_in;
logic [3:0] offset;
logic [2:0] index;
logic [8:0] tag;
logic hit1;
logic hit2;
logic lru_out;
logic lru_in;
logic data1_write;
logic data2_write;
logic [9:0] valid_tag_in1;
logic [9:0] valid_tag_out1;
logic [9:0] valid_tag_in2;
logic [9:0] valid_tag_out2;

lc3b_c_line data1_out;
lc3b_c_line data2_out;

always_comb begin
  hit = hit1 | hit2;
  lru_in = ~lru_out;
  offset = address[3:0];
  index = address[6:4];
  tag = address[15:7];
  dirty = dirty1_out | dirty2_out;
  load_data = hit & write_enable | control_load;

  if(control_load)
    dirty_in = 0;
  else
    dirty_in = 1;

  if(hit1)
    data_out = data1_out;
  else if(hit2)
    data_out = data2_out;
  else
    data_out = 128'd0;
end

array #(.width(1)) lru
(
  .clk(clk),
  .write(hit),
  .index(index),
  .datain(hit1),
  .dataout(lru_out)
);

always_comb begin
  if (lru_out == 0) begin
    load_dirty1 = load_data & write_enable & hit1;
    data1_write = load_data;
    data2_write = 0;
  end
  else begin
    load_dirty2 = load_data & write_enable & hit2;
    data1_write = 0;
    data2_write = load_data;
  end
end

/* instantiate 8 128 bit data arrays for way 1 */
array data1
(
    .clk(clk),
    .write(data1_write),
    .index(index),
    .datain(data_in),
    .dataout(data1_out)
);

/* instantiate 8 128 bit data arrays for way 2 */
array data2
(
  .clk(clk),
  .write(data2_write),
  .index(index),
  .datain(data_in),
  .dataout(data2_out)
);

always_comb begin
  valid_tag_in1 = 10'({1'b1, tag});
  valid_tag_in2 = 10'({1'b1, tag});
  if (valid_tag_out1 == {1'd1, tag})
	hit1 = 1;
  else
	hit1 = 0;
  if (valid_tag_out2 == {1'd1, tag})
	hit2 = 1;
  else
	hit2 = 0;
end

array #(.width(10)) valid_tag1
(
  .clk(clk),
  .write(data1_write),
  .index(index),
  .datain(valid_tag_in1),
  .dataout(valid_tag_out1)
);

array #(.width(10)) valid_tag2
(
  .clk(clk),
  .write(data2_write),
  .index(index),
  .datain(valid_tag_in2),
  .dataout(valid_tag_out2)
);

array #(.width(1)) dirty1
(
  .clk(clk),
  .write(load_dirty1),
  .index(index),
  .datain(dirty_in),
  .dataout(dirty1_out)
);

array #(.width(1)) dirty2
(
  .clk(clk),
  .write(load_dirty2),
  .index(index),
  .datain(dirty_in),
  .dataout(dirty2_out)
);

endmodule : cache_datapath
