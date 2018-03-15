library verilog;
use verilog.vl_types.all;
entity wishbone_interface is
    port(
        cpu_address     : in     vl_logic_vector(15 downto 0);
        mem_rdata_line  : in     vl_logic_vector(127 downto 0);
        mem_byte_enable : in     vl_logic_vector(1 downto 0);
        write_data_cpu  : in     vl_logic_vector(15 downto 0);
        mem_address     : out    vl_logic_vector(11 downto 0);
        write_data_mem  : out    vl_logic_vector(127 downto 0);
        mem_rdata       : out    vl_logic_vector(15 downto 0);
        offset          : out    vl_logic_vector(3 downto 0);
        \select\        : out    vl_logic_vector(15 downto 0)
    );
end wishbone_interface;
