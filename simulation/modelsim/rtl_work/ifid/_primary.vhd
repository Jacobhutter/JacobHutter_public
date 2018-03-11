library verilog;
use verilog.vl_types.all;
library work;
entity ifid is
    port(
        clk             : in     vl_logic;
        advance         : in     vl_logic;
        mem_resp        : in     vl_logic;
        instr           : in     vl_logic_vector(15 downto 0);
        pc_in           : in     vl_logic_vector(15 downto 0);
        ctrl_word_in    : in     work.lc3b_types.lc3b_control_word;
        offset6_in      : in     vl_logic_vector(15 downto 0);
        offset9_in      : in     vl_logic_vector(15 downto 0);
        dest            : out    vl_logic_vector(2 downto 0);
        src1            : out    vl_logic_vector(2 downto 0);
        src2            : out    vl_logic_vector(2 downto 0);
        load_pc         : out    vl_logic;
        offset6_out     : out    vl_logic_vector(15 downto 0);
        offset9_out     : out    vl_logic_vector(15 downto 0);
        offset11        : out    vl_logic_vector(10 downto 0);
        mem_request     : out    vl_logic;
        imm5            : out    vl_logic_vector(15 downto 0);
        pc              : out    vl_logic_vector(15 downto 0);
        ctrl_word_out   : out    work.lc3b_types.lc3b_control_word;
        ready           : out    vl_logic
    );
end ifid;
