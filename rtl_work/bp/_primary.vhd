library verilog;
use verilog.vl_types.all;
library work;
entity bp is
    port(
        clk             : in     vl_logic;
        incoming_pc     : in     vl_logic_vector(15 downto 0);
        outgoing_pc     : in     vl_logic_vector(15 downto 0);
        br_add_out      : in     vl_logic_vector(15 downto 0);
        incoming_control_word: in     work.lc3b_types.lc3b_control_word;
        outgoing_control_word: in     work.lc3b_types.lc3b_control_word;
        branch_enable   : in     vl_logic;
        incoming_valid_branch: in     vl_logic;
        outgoing_valid_branch: in     vl_logic;
        outgoing_pcmux_sel: in     vl_logic_vector(2 downto 0);
        if_control_word : out    work.lc3b_types.lc3b_control_word;
        predicted_pc    : out    vl_logic_vector(15 downto 0);
        pcmux_sel       : out    vl_logic_vector(2 downto 0);
        flush           : out    vl_logic;
        bp_miss         : out    vl_logic;
        stall           : out    vl_logic
    );
end bp;
