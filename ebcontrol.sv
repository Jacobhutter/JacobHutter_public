import lc3b_types::*;

module ebcontrol
(
    input clk,
    input lc3b_address orig_address,
    input lc3b_c_line orig_dataout,
    input lc3b_c_line dest_dataout,
    
    output lc3b_address dest_address,
    output lc3b_c_line orig_datain,
    output lc3b_c_line dest_datain,
    
    input dataout_mux,
    input datain_mux,
    input hit_detect
);



endmodule : ebcontrol