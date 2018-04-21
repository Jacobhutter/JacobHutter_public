library verilog;
use verilog.vl_types.all;
entity cache_datapath is
    port(
        clk             : in     vl_logic;
        ctrl_reload     : in     vl_logic;
        ctrl_write      : in     vl_logic;
        ctrl_hit        : in     vl_logic;
        lru_out         : out    vl_logic;
        dirty_out       : out    vl_logic_vector(1 downto 0);
        cpu_address     : in     vl_logic_vector(15 downto 0);
        cpu_sel         : in     vl_logic_vector(15 downto 0);
        cpu_datain      : in     vl_logic_vector(127 downto 0);
        cpu_read        : in     vl_logic;
        cpu_write       : in     vl_logic;
        cpu_resp        : out    vl_logic;
        cpu_dataout     : out    vl_logic_vector(127 downto 0);
        mem_datain      : in     vl_logic_vector(127 downto 0);
        mem_resp        : in     vl_logic;
        mem_address     : out    vl_logic_vector(15 downto 0);
        mem_dataout     : out    vl_logic_vector(127 downto 0)
    );
end cache_datapath;
