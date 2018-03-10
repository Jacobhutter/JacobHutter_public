import lc3b_types::*;

module cpu(
    wishbone.master ifetch, // instruction fetch stage, assumed to never write
    wishbone.master memory // memory stage
);

logic [3:0] instruction_offset;
logic [3:0] data_offset;
logic instruction_request, write_enable, data_request;
lc3b_word instr, mem_rdata, write_data, mem_address;

assign ifetch.STB = instruction_request;
assign ifetch.CYC = instruction_request;
assign ifetch.WE = 0;
assign ifetch.DAT_M = 128'd0;
wishbone_intereface instr_interface
(
    .cpu_address(instruction_address),
    .mem_rdata_line(ifetch.DAT_S),
    .write_data_cpu(16'd0),
    .mem_address(ifetch.ADR),
    .mem_rdata(instr)
    .write_data_mem(),
    .offset(instruction_offset),
    .select(ifetch.SEL)
);

assign memory.STB = data_request;
assign memory.CYC = data_request;
assign memory.WE = write_enable;
wishbone_intereface data_interface
(
  .cpu_address(mem_address),
  .mem_rdata_line(memory.DAT_S),
  .write_data_cpu(write_data),
  .mem_address(memory.ADR),
  .mem_rdata,
  .write_data_mem(memory.DAT_M),
  .offset(data_offset),
  .select(memory.SEL)
);

cpu_datapath cd
(
  .clk(ifetch.CLK),
  .instr,
  .instruction_response(ifetch.ACK),
  .mem_rdata,
  .data_response(memory.ACK),
  .instruction_address,
  .mem_address,
  .write_data,
  .instruction_request,
  .data_request,
  .write_enable
);

endmodule : cpu
