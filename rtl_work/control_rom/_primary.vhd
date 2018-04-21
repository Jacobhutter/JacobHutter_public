library verilog;
use verilog.vl_types.all;
library work;
entity control_rom is
    port(
        opcode          : in     work.lc3b_types.lc3b_opcode;
        bits4_5_11      : in     vl_logic_vector(2 downto 0);
        ctrl            : out    work.lc3b_types.lc3b_control_word
    );
end control_rom;
