library verilog;
use verilog.vl_types.all;
entity selectway4 is
    port(
        match           : in     vl_logic;
        way             : in     vl_logic_vector(127 downto 0);
        \out\           : out    vl_logic_vector(127 downto 0)
    );
end selectway4;
