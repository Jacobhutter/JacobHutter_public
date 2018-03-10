library verilog;
use verilog.vl_types.all;
entity cpu_datapath is
    port(
        clk             : in     vl_logic;
        instr           : in     vl_logic_vector(15 downto 0);
        instruction_response: in     vl_logic;
        mem_rdata       : in     vl_logic_vector(15 downto 0);
        data_response   : in     vl_logic;
        instruction_address: out    vl_logic_vector(15 downto 0);
        mem_address     : out    vl_logic_vector(15 downto 0);
        write_data      : out    vl_logic_vector(15 downto 0);
        instruction_request: out    vl_logic;
        data_request    : out    vl_logic;
        write_enable    : out    vl_logic
    );
end cpu_datapath;
