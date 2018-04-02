library verilog;
use verilog.vl_types.all;
entity datawrite is
    port(
        ctrl_hit        : in     vl_logic;
        ctrl_reload     : in     vl_logic;
        cpu_write       : in     vl_logic;
        lru_switch      : in     vl_logic;
        tag_match       : in     vl_logic;
        write           : out    vl_logic
    );
end datawrite;
