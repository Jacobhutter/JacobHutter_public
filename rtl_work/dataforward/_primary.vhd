library verilog;
use verilog.vl_types.all;
entity dataforward is
    port(
        ex_dest         : in     vl_logic_vector(2 downto 0);
        wb_dest         : in     vl_logic_vector(2 downto 0);
        mem_dest        : in     vl_logic_vector(2 downto 0);
        ex_src1         : in     vl_logic_vector(2 downto 0);
        ex_src2         : in     vl_logic_vector(2 downto 0);
        mem_valid_dest  : in     vl_logic;
        wb_valid_dest   : in     vl_logic;
        mem_access      : in     vl_logic;
        ex_sel1         : out    vl_logic_vector(1 downto 0);
        ex_sel2         : out    vl_logic_vector(1 downto 0);
        ex_storesel     : out    vl_logic_vector(1 downto 0)
    );
end dataforward;
