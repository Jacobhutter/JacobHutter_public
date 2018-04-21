library verilog;
use verilog.vl_types.all;
entity btb is
    port(
        clk             : in     vl_logic;
        target_addr     : in     vl_logic_vector(15 downto 0);
        new_branch_address: in     vl_logic_vector(15 downto 0);
        we              : in     vl_logic;
        branch_address  : out    vl_logic_vector(15 downto 0);
        miss            : out    vl_logic
    );
end btb;
