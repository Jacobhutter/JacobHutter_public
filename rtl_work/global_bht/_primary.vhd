library verilog;
use verilog.vl_types.all;
entity global_bht is
    port(
        clk             : in     vl_logic;
        update          : in     vl_logic;
        pc_in           : in     vl_logic_vector(15 downto 0);
        branch_taken    : in     vl_logic;
        predict         : out    vl_logic
    );
end global_bht;
