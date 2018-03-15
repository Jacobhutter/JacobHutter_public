library verilog;
use verilog.vl_types.all;
entity tagwrite is
    port(
        ctrl_reload     : in     vl_logic;
        lru_switch      : in     vl_logic;
        mem_resp        : in     vl_logic;
        write           : out    vl_logic
    );
end tagwrite;
