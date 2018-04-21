library verilog;
use verilog.vl_types.all;
entity swapaddress4 is
    port(
        ctrl_write      : in     vl_logic;
        cpu_addr        : in     vl_logic_vector(15 downto 0);
        lru_sel         : in     vl_logic;
        tag             : in     vl_logic_vector(8 downto 0);
        mem_addr        : out    vl_logic_vector(15 downto 0)
    );
end swapaddress4;
