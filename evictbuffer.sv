module evictbuffer
(
    wishbone.slave wb_orig,
    wishbone.master wb_dest
);

logic datain_mux, dataout_mux, hit_detect, clk;

assign clk = wb_orig.CLK;

ebdatapath eb_datapath
(
    .clk,
    .orig_address(wb_orig.ADR),
    .orig_dataout(wb_orig.DAT_M),
    .dest_dataout(wb_dest.DAT_S),
    
    .dest_address(wb_dest.ADR),
    .orig_datain(wb_orig.DAT_S),
    .dest_datain(wb_orig.DAT_M),
    
    .dataout_mux,
    .datain_mux,
    .buffer_write,
    .hit_detect
);

ebcontrol eb_control
(
    .clk,
    .orig_write(wb_orig.WE),
    .dest_resp(wb_dest.ACK),
    .hit_detect,
    
    .datain_mux,
    .dataout_mux
);


endmodule : evictbuffer
