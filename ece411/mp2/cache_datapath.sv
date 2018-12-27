import lc3b_types::*;

module cache_datapath
(
  input logic clk,
  input [11:0] address,
  input lc3b_c_line data_in,
  input write_enable,
  input control_load,
  input lru_load,

  output logic hit,
  output logic dead_man_walkin,
  output logic [11:0] adr_out,
  output lc3b_c_line data_out,
  output logic dirty
);

logic load_data;
logic dirty1_out;
logic dirty2_out;
logic load_dirty1;
logic load_dirty2;
logic dirty_in;

logic [2:0] index;
logic [8:0] tag;
logic hit1, hit2, lru_out, data1_write, data2_write;
logic [9:0] valid_tag_in1, valid_tag_out1, valid_tag_in2, valid_tag_out2;

lc3b_c_line data1_out;
lc3b_c_line data2_out;

always_comb begin
  hit = hit1 | hit2;
  index = address[2:0];
  tag = address[11:3];
  dirty = dirty1_out | dirty2_out;
  load_data = hit & write_enable | control_load;

  if(control_load)
    dirty_in = 0;
  else
    dirty_in = 1;

  if(hit1) begin
	 adr_out = 12'd0;
    data_out = data1_out;
	 dead_man_walkin = 0;
  end
  else if(hit2) begin
    data_out = data2_out;
	 adr_out = 12'd0;
	 dead_man_walkin = 0;
  end
  else if(write_enable) begin // dead man walkin!
	dead_man_walkin = 1;
	if(!lru_out) begin
		adr_out = 12'({valid_tag_out1[8:0], index});
		data_out = data1_out;
	end
	else begin
		adr_out = 12'({valid_tag_out2[8:0], index});
		data_out = data2_out;
	end
  end
  else begin
	 data_out = 128'd0;
	 adr_out = 12'd0;
	 dead_man_walkin = 0;
  end
end

array #(.width(1)) lru
(
  .clk(clk),
  .write(lru_load),
  .index(index),
  .datain(hit1),
  .dataout(lru_out)
);

always_comb begin

  if(!hit) begin // miss
	if (!lru_out) begin // evict data1 cacheline 
	 load_dirty1 = load_data & write_enable & hit1;
	 load_dirty2 = 0;
    data1_write = load_data;
    data2_write = 0;
	end
	else begin // evict data2 cacheline
	 load_dirty1 = 0;
    load_dirty2 = load_data & write_enable & hit2;
    data1_write = 0;
    data2_write = load_data;
	end
  end
  else begin // hit, load data in correct cacheline when we is high
	 load_dirty1 = load_data & write_enable & hit1;
	 load_dirty2 = load_data & write_enable & hit2;
	 data1_write = load_data & write_enable & hit1;
	 data2_write = load_data & write_enable & hit2;
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