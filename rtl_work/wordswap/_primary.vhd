library verilog;
use verilog.vl_types.all;
entity wordswap is
    port(
        cpu_sel         : in     vl_logic_vector(15 downto 0);
        cpu_write       : in     vl_logic;
        cpu_datain      : in     vl_logic_vector(127 downto 0);
        mem_datain      : in     vl_logic_vector(127 downto 0);
        cache_line      : in     vl_logic_vector(127 downto 0);
        ctrl_reload     : in     vl_logic;
        \out\           : out    vl_logic_vector(127 downto 0)
    );
end wordswap;
