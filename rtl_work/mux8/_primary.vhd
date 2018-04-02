library verilog;
use verilog.vl_types.all;
entity mux8 is
    generic(
        width           : integer := 16
    );
    port(
        sel             : in     vl_logic_vector(2 downto 0);
        in0             : in     vl_logic_vector;
        in1             : in     vl_logic_vector;
        in2             : in     vl_logic_vector;
        in3             : in     vl_logic_vector;
        in4             : in     vl_logic_vector;
        in5             : in     vl_logic_vector;
        in6             : in     vl_logic_vector;
        in7             : in     vl_logic_vector;
        f               : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end mux8;
