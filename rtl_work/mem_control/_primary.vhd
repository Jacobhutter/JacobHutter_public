library verilog;
use verilog.vl_types.all;
library work;
entity mem_control is
    port(
        clk             : in     vl_logic;
        advance         : in     vl_logic;
        mem_control_word: in     work.lc3b_types.lc3b_control_word;
        src_data        : in     vl_logic_vector(15 downto 0);
        alu_data        : in     vl_logic_vector(15 downto 0);
        trapvect8       : in     vl_logic_vector(15 downto 0);
        mem_rdata       : in     vl_logic_vector(15 downto 0);
        data_response   : in     vl_logic;
        flush           : in     vl_logic;
        mem_wdata       : out    vl_logic_vector(15 downto 0);
        mem_byte_enable : out    vl_logic_vector(1 downto 0);
        data_request    : out    vl_logic;
        mem_address     : out    vl_logic_vector(15 downto 0);
        mem_output      : out    vl_logic_vector(15 downto 0);
        write_enable    : out    vl_logic;
        ready           : out    vl_logic
    );
end mem_control;
