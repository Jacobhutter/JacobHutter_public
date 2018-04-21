library verilog;
use verilog.vl_types.all;
entity cache4_datapath is
    generic(
        NUM_WAYS        : integer := 4
    );
    port(
        clk             : in     vl_logic;
        ctrl_reload     : in     vl_logic;
        ctrl_write      : in     vl_logic;
        ctrl_hit        : in     vl_logic;
        need_writeback  : out    vl_logic;
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
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM_WAYS : constant is 1;
end cache4_datapath;
