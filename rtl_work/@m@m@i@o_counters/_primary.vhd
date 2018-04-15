library verilog;
use verilog.vl_types.all;
library work;
entity MMIO_counters is
    port(
        i_cache_hits    : in     vl_logic_vector(15 downto 0);
        i_cache_misses  : in     vl_logic_vector(15 downto 0);
        d_cache_hits    : in     vl_logic_vector(15 downto 0);
        d_cache_misses  : in     vl_logic_vector(15 downto 0);
        l2_cache_hits   : in     vl_logic_vector(15 downto 0);
        l2_cache_misses : in     vl_logic_vector(15 downto 0);
        total_branches  : in     vl_logic_vector(15 downto 0);
        mispredictions  : in     vl_logic_vector(15 downto 0);
        total_stalls    : in     vl_logic_vector(15 downto 0);
        opcode          : in     work.lc3b_types.lc3b_opcode;
        mem_address     : in     vl_logic_vector(15 downto 0);
        mem_rdata_in    : in     vl_logic_vector(15 downto 0);
        reset_i_cache_hits: out    vl_logic;
        reset_i_cache_misses: out    vl_logic;
        reset_d_cache_hits: out    vl_logic;
        reset_d_cache_misses: out    vl_logic;
        reset_l2_cache_hits: out    vl_logic;
        reset_l2_cache_misses: out    vl_logic;
        reset_total_branchs: out    vl_logic;
        reset_mispredictions: out    vl_logic;
        reset_stalls    : out    vl_logic;
        mem_rdata_out   : out    vl_logic_vector(15 downto 0)
    );
end MMIO_counters;
