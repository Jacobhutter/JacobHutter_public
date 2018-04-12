library verilog;
use verilog.vl_types.all;
entity swapaddress is
    port(
        ctrl_write      : in     vl_logic;
        cpu_addr        : in     vl_logic_vector(15 downto 0);
        lru_switch      : in     vl_logic;
        tag0            : in     vl_logic_vector(8 downto 0);
        tag1            : in     vl_logic_vector(8 downto 0);
        mem_addr        : out    vl_logic_vector(15 downto 0)
    );
end swapaddress;
