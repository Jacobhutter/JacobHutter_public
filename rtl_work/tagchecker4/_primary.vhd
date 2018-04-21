library verilog;
use verilog.vl_types.all;
entity tagchecker4 is
    port(
        valid           : in     vl_logic;
        cache_tag       : in     vl_logic_vector(8 downto 0);
        addr_tag        : in     vl_logic_vector(8 downto 0);
        match           : out    vl_logic
    );
end tagchecker4;
