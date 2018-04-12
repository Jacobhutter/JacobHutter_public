library verilog;
use verilog.vl_types.all;
entity cache_control is
    port(
        clk             : in     vl_logic;
        cpu_resp        : in     vl_logic;
        cpu_strobe      : in     vl_logic;
        cache_lru       : in     vl_logic;
        cache_dirty     : in     vl_logic_vector(1 downto 0);
        ctrl_hit        : out    vl_logic;
        ctrl_write      : out    vl_logic;
        ctrl_reload     : out    vl_logic;
        mem_resp        : in     vl_logic;
        mem_we          : out    vl_logic;
        mem_strobe      : out    vl_logic;
        cpu_write       : in     vl_logic
    );
end cache_control;
