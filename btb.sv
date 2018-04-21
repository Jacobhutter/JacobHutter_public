import lc3b_types::*;

module btb(
  input clk,
  input lc3b_word target_addr,
  input lc3b_word new_branch_address,
  input we,

  output lc3b_word branch_address,
  output logic miss
);

logic write1, write2, write3, write4;
logic [2:0] index;
assign index = target_addr[2:0];
logic [15:0] tag1;
logic [15:0] tag2;
logic [15:0] tag3;
logic [15:0] tag4;
logic [15:0] d1;
logic [15:0] d2;
logic [15:0] d3;
logic [15:0] d4;
logic [3:0] hit;
logic [2:0] lru_in;
logic [2:0] lru_out;

always_comb begin
  write1 = 0;
  write2 = 0;
  write3 = 0;
  write4 = 0;
  lru_in = lru_out;

  case(lru_out) // each case is the one to be replaced
    3'b110: begin // A
      write1 = we;
		if(we | hit == 4'b0001) // A
			lru_in = 3'b000;
		else if(hit == 4'b0010) // B
			lru_in = 3'b010;
		else if(hit == 4'b0010) // C
			lru_in = 3'b110;
		else if(hit == 4'b0010) // D
			lru_in = 3'b111;
		else
			lru_in = lru_out;
    end

    3'b111: begin // A
      write1 = we;
		if(we | hit == 4'b0001) // A
			lru_in = 3'b001;
		else if(hit == 4'b0010) // B
			lru_in = 3'b011;
		else if(hit == 4'b0010) // C
			lru_in = 3'b110;
		else if(hit == 4'b0010) // D
			lru_in = 3'b111;
		else
			lru_in = lru_out;
    end

    3'b100: begin // B
      write2 = we;
		if(hit == 4'b0001) // A
			lru_in = 3'b000;
		else if(we | hit == 4'b0010) // B
			lru_in = 3'b010;
		else if(hit == 4'b0010) // C
			lru_in = 3'b100;
		else if(hit == 4'b0010) // D
			lru_in = 3'b101;
		else
			lru_in = lru_out;
    end

    3'b101: begin // B
      write2 = we;
		if(hit == 4'b0001) // A
			lru_in = 3'b001;
		else if(we | hit == 4'b0010) // B
			lru_in = 3'b011;
		else if(hit == 4'b0010) // C
			lru_in = 3'b100;
		else if(hit == 4'b0010) // D
			lru_in = 3'b101;
		else
			lru_in = lru_out;
    end

    3'b001: begin // C
      write3 = we;
		if(hit == 4'b0001) // A
			lru_in = 3'b001;
		else if(hit == 4'b0010) // B
			lru_in = 3'b011;
		else if(we | hit == 4'b0010) // C
			lru_in = 3'b100;
		else if(hit == 4'b0010) // D
			lru_in = 3'b101;
		else
			lru_in = lru_out;
    end

	 3'b011: begin // C
      write3 = we;
		if(hit == 4'b0001) // A
			lru_in = 3'b001;
		else if(hit == 4'b0010) // B
			lru_in = 3'b011;
		else if(we | hit == 4'b0010) // C
			lru_in = 3'b110;
		else if(hit == 4'b0010) // D
			lru_in = 3'b111;
		else
			lru_in = lru_out;
    end

    3'b000: begin // D
      write4 = we;
		if(hit == 4'b0001) // A
			lru_in = 3'b000;
		else if(hit == 4'b0010) // B
			lru_in = 3'b010;
		else if(hit == 4'b0010) // C
			lru_in = 3'b100;
		else if(we | hit == 4'b0010) // D
			lru_in = 3'b101;
		else
			lru_in = lru_out;
    end

	 3'b010: begin // D
      write4 = we;
		if(hit == 4'b0001) // A
			lru_in = 3'b000;
		else if(hit == 4'b0010) // B
			lru_in = 3'b010;
		else if(hit == 4'b0010) // C
			lru_in = 3'b110;
		else if(we | hit == 4'b0010) // D
			lru_in = 3'b111;
		else
			lru_in = lru_out;
    end

    default: begin
		lru_in = lru_out;
	 end

  endcase
end

array #(.width(3)) lru
(
    .clk,
    .write(we | !miss),
    .index,
    .datain(lru_in),
    .dataout(lru_out)
);

always_comb begin
  case(hit)

    4'b0001: begin
      branch_address = d1;
		miss = 0;
    end

    4'b0010: begin
      branch_address = d2;
		miss = 0;
    end

    4'b0100: begin
      branch_address = d3;
		miss = 0;
    end

    4'b1000: begin
      branch_address = d4;
		miss = 0;
    end

    default: begin
		branch_address = 16'd0;
      miss = 1'b1;
    end

  endcase
end

array #(.width(16)) data1
(
    .clk,
    .write(write1),
    .index,
    .datain(new_branch_address),
    .dataout(d1)
);

array #(.width(16)) data2
(
    .clk,
    .write(write2),
    .index,
    .datain(new_branch_address),
    .dataout(d2)
);

array #(.width(16)) data3
(
    .clk,
    .write(write3),
    .index,
    .datain(new_branch_address),
    .dataout(d3)
);

array #(.width(16)) data4
(
    .clk,
    .write(write4),
    .index,
    .datain(new_branch_address),
    .dataout(d4)
);

always_comb begin
  hit[0] = tag1 == target_addr;
  hit[1] = tag2 == target_addr;
  hit[2] = tag3 == target_addr;
  hit[3] = tag4 == target_addr;
end

array #(.width(16)) t1
(
    .clk,
    .write(write1),
    .index,
    .datain(target_addr),
    .dataout(tag1)
);

array #(.width(16)) t2
(
    .clk,
    .write(write2),
    .index,
    .datain(target_addr),
    .dataout(tag2)
);

array #(.width(16)) t3
(
    .clk,
    .write(write3),
    .index,
    .datain(target_addr),
    .dataout(tag3)
);

array #(.width(16)) t4
(
    .clk,
    .write(write4),
    .index,
    .datain(target_addr),
    .dataout(tag4)
);

endmodule : btb
