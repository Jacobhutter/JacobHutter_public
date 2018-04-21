library verilog;
use verilog.vl_types.all;
entity cache4_control is
    port(
        clk             : in     vl_logic;
        cpu_resp        : in     vl_logic;
        cpu_strobe      : in     vl_logic;
        need_writeback  : in     vl_logic;
        ctrl_hit        : out    vl_logic;
        ctrl_write      : out    vl_logic;
        ctrl_reload     : out    vl_logic;
        mem_resp        : in     vl_logic;
        mem_we          : out    vl_logic;
        mem_strobe      : out    vl_logic;
        cpu_write       : in     vl_logic
    );
end cache4_control;
