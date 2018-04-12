library verilog;
use verilog.vl_types.all;
entity lruwrite is
    port(
        ctrl_hit        : in     vl_logic;
        match0          : in     vl_logic;
        match1          : in     vl_logic;
        write           : out    vl_logic
    );
end lruwrite;
