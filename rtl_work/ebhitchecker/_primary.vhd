library verilog;
use verilog.vl_types.all;
entity ebhitchecker is
    port(
        orig_address    : in     vl_logic_vector(11 downto 0);
        buf_address     : in     vl_logic_vector(11 downto 0);
        buf_valid       : in     vl_logic;
        hit_detect      : out    vl_logic
    );
end ebhitchecker;
