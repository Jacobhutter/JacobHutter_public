library verilog;
use verilog.vl_types.all;
library work;
entity bp is
    port(
        clk             : in     vl_logic;
        incoming_opcode : in     work.lc3b_types.lc3b_opcode;
        outgoing_opcode : in     work.lc3b_types.lc3b_opcode;
        branch_enable   : in     vl_logic;
        incoming_valid_branch: in     vl_logic;
        outgoing_valid_branch: in     vl_logic;
        outgoing_pcmux_sel: in     vl_logic_vector(1 downto 0);
        pcmux_sel       : out    vl_logic_vector(1 downto 0);
        flush           : out    vl_logic;
        bp_miss         : out    vl_logic;
        stall           : out    vl_logic
    );
end bp;
