library verilog;
use verilog.vl_types.all;
entity ebcontrol is
    port(
        clk             : in     vl_logic;
        orig_strobe     : in     vl_logic;
        orig_write      : in     vl_logic;
        dest_resp       : in     vl_logic;
        hit_detect      : in     vl_logic;
        datain_mux      : out    vl_logic;
        dataout_mux     : out    vl_logic;
        buffer_write    : out    vl_logic;
        dest_strobe     : out    vl_logic;
        dest_write      : out    vl_logic;
        orig_resp       : out    vl_logic
    );
end ebcontrol;
