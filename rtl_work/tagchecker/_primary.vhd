library verilog;
use verilog.vl_types.all;
entity tagchecker is
    port(
        valid0          : in     vl_logic;
        valid1          : in     vl_logic;
        tag0            : in     vl_logic_vector(8 downto 0);
        tag1            : in     vl_logic_vector(8 downto 0);
        addr_tag        : in     vl_logic_vector(8 downto 0);
        match0          : out    vl_logic;
        match1          : out    vl_logic;
        cpu_resp        : out    vl_logic
    );
end tagchecker;
