library verilog;
use verilog.vl_types.all;
entity prediction_history_table is
    port(
        clk             : in     vl_logic;
        branch_taken    : in     vl_logic;
        current_state   : in     vl_logic_vector(1 downto 0);
        new_state       : out    vl_logic_vector(1 downto 0);
        predict         : out    vl_logic
    );
end prediction_history_table;
