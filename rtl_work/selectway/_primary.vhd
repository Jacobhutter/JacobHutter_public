library verilog;
use verilog.vl_types.all;
entity selectway is
    port(
        match0          : in     vl_logic;
        match1          : in     vl_logic;
        way0            : in     vl_logic_vector(127 downto 0);
        way1            : in     vl_logic_vector(127 downto 0);
        \out\           : out    vl_logic_vector(127 downto 0)
    );
end selectway;
