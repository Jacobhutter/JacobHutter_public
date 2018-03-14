library verilog;
use verilog.vl_types.all;
library work;
entity memwb is
    port(
        clk             : in     vl_logic;
        advance         : in     vl_logic;
        pc_in           : in     vl_logic_vector(15 downto 0);
        dest_in         : in     vl_logic_vector(2 downto 0);
        offset9_in      : in     vl_logic_vector(15 downto 0);
        offset11_in     : in     vl_logic_vector(15 downto 0);
        ctrl_word_in    : in     work.lc3b_types.lc3b_control_word;
        mem_wdata_in    : in     vl_logic_vector(15 downto 0);
        wb_alu_in       : in     vl_logic_vector(15 downto 0);
        data_response   : in     vl_logic;
        dest_out        : out    vl_logic_vector(2 downto 0);
        mem_wdata_out   : out    vl_logic_vector(15 downto 0);
        wb_alu_out      : out    vl_logic_vector(15 downto 0);
        pc              : out    vl_logic_vector(15 downto 0);
        offset9_out     : out    vl_logic_vector(15 downto 0);
        offset11_out    : out    vl_logic_vector(15 downto 0);
        ctrl_word_out   : out    work.lc3b_types.lc3b_control_word;
        second_cycle_request: out    vl_logic;
        ready           : out    vl_logic
    );
end memwb;
