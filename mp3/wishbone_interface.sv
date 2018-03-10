import lc3b_types::*;

module wishbone_interface
(
  input logic [15:0] cpu_address,
  input lc3b_line mem_rdata_line,
  input lc3b_word write_data_cpu,

  output lc3b_address mem_address,
  output lc3b_line write_data_mem,
  output lc3b_word mem_rdata,
  output logic [3:0] offset,
  output lc3b_word select
);

logic [127:0] raw_data;
always_comb begin
  mem_address = cpu_address[15:4];
  offset = cpu_address[3:0];
  select = 16'({14'd0,2'b11} << offset[3:0]);
  raw_data = (mem_rdata_line >> (8 * offset[3:0]));
  mem_rdata = raw_data[15:0];
  write_data_mem = 128'({112'd0, write_data_cpu }) << (8 * offset[3:0]);
end

endmodule : wishbone_interface
