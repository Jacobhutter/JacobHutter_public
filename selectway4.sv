import lc3b_types::*;

module selectway4 (
    input match,
    input lc3b_c_line way,
    output lc3b_c_line out
);

always_comb
begin
    out = 0;
    if(match)
        out = way;
end

endmodule : selectway4