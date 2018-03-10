library verilog;
use verilog.vl_types.all;
library work;
entity exmem is
    port(
        clk             : in     vl_logic;
        advance         : in     vl_logic;
        pc_in           : in     vl_logic_vector(15 downto 0);
        ex_alu_in       : in     vl_logic_vector(15 downto 0);
        dest_in         : in     vl_logic_vector(2 downto 0);
        source_data_in  : in     vl_logic_vector(15 downto 0);
        offset9_in      : in     vl_logic_vector(15 downto 0);
        ctrl_word_in    : in     work.lc3b_types.lc3b_control_word;
        pc              : out    vl_logic_vector(15 downto 0);
        ex_alu_out      : out    vl_logic_vector(15 downto 0);
        source_data_out : out    vl_logic_vector(15 downto 0);
        dest_out        : out    vl_logic_vector(2 downto 0);
        offset9_out     : out    vl_logic_vector(15 downto 0);
        ctrl_word_out   : out    work.lc3b_types.lc3b_control_word;
        ready           : out    vl_logic
    );
end exmem;
