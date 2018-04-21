library verilog;
use verilog.vl_types.all;
entity tagwrite4 is
    port(
        lru_sel         : in     vl_logic;
        ctrl_reload     : in     vl_logic;
        mem_resp        : in     vl_logic;
        write           : out    vl_logic
    );
end tagwrite4;
