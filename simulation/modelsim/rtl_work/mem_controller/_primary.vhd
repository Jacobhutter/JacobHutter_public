library verilog;
use verilog.vl_types.all;
library work;
entity mem_controller is
    port(
        clk             : in     vl_logic;
        data_response   : in     vl_logic;
        ctrl_word_in    : in     work.lc3b_types.lc3b_control_word;
        ctrl_word_out   : out    work.lc3b_types.lc3b_control_word
    );
end mem_controller;
