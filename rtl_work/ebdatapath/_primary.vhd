library verilog;
use verilog.vl_types.all;
entity ebdatapath is
    port(
        clk             : in     vl_logic;
        orig_address    : in     vl_logic_vector(11 downto 0);
        orig_dataout    : in     vl_logic_vector(127 downto 0);
        dest_dataout    : in     vl_logic_vector(127 downto 0);
        dest_address    : out    vl_logic_vector(11 downto 0);
        orig_datain     : out    vl_logic_vector(127 downto 0);
        dest_datain     : out    vl_logic_vector(127 downto 0);
        dataout_mux     : in     vl_logic;
        datain_mux      : in     vl_logic;
        buffer_write    : in     vl_logic;
        hit_detect      : out    vl_logic
    );
end ebdatapath;
