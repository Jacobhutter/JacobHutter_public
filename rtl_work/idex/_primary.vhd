library verilog;
use verilog.vl_types.all;
library work;
entity idex is
    port(
        clk             : in     vl_logic;
        advance         : in     vl_logic;
        pc_in           : in     vl_logic_vector(15 downto 0);
        ctrl_word_in    : in     work.lc3b_types.lc3b_control_word;
        dest_in         : in     vl_logic_vector(2 downto 0);
        src1            : in     vl_logic_vector(2 downto 0);
        src2            : in     vl_logic_vector(2 downto 0);
        sr1_in          : in     vl_logic_vector(15 downto 0);
        sr2_in          : in     vl_logic_vector(15 downto 0);
        offset6_in      : in     vl_logic_vector(15 downto 0);
        offset9_in      : in     vl_logic_vector(15 downto 0);
        offset11_in     : in     vl_logic_vector(15 downto 0);
        imm5_in         : in     vl_logic_vector(15 downto 0);
        imm4_in         : in     vl_logic_vector(15 downto 0);
        trapvect8_in    : in     vl_logic_vector(15 downto 0);
        flush           : in     vl_logic;
        pc              : out    vl_logic_vector(15 downto 0);
        dest_out        : out    vl_logic_vector(2 downto 0);
        sr1_out         : out    vl_logic_vector(15 downto 0);
        sr2_out         : out    vl_logic_vector(15 downto 0);
        offset6_out     : out    vl_logic_vector(15 downto 0);
        offset9_out     : out    vl_logic_vector(15 downto 0);
        offset11_out    : out    vl_logic_vector(15 downto 0);
        imm5_out        : out    vl_logic_vector(15 downto 0);
        imm4_out        : out    vl_logic_vector(15 downto 0);
        src1_out        : out    vl_logic_vector(2 downto 0);
        src2_out        : out    vl_logic_vector(2 downto 0);
        trapvect8_out   : out    vl_logic_vector(15 downto 0);
        ctrl_word_out   : out    work.lc3b_types.lc3b_control_word;
        ready           : out    vl_logic
    );
end idex;
