library verilog;
use verilog.vl_types.all;
library work;
entity performence_counter is
    port(
        clk             : in     vl_logic;
        trigger         : in     vl_logic;
        pc_in           : in     vl_logic_vector(15 downto 0);
        opcode          : in     work.lc3b_types.lc3b_opcode;
        thresh          : in     vl_logic_vector(15 downto 0);
        cont            : in     vl_logic;
        reset           : in     vl_logic;
        count           : out    vl_logic_vector(15 downto 0)
    );
end performence_counter;
