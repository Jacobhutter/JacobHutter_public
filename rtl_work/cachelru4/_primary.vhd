library verilog;
use verilog.vl_types.all;
entity cachelru4 is
    port(
        clk             : in     vl_logic;
        tagmatches      : in     vl_logic_vector(3 downto 0);
        index           : in     vl_logic_vector(2 downto 0);
        ctrl_hit        : in     vl_logic;
        lru_sel         : out    vl_logic_vector(3 downto 0)
    );
end cachelru4;
