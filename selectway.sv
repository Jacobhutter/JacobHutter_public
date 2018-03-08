import lc3b_types::*;

module selectway (
    input match0, match1,
    input lc3b_c_line way0, way1,
    output lc3b_c_line out
);

always_comb
begin
    out = 0;
    if(match0)
        out = way0;
    else if(match1)
        out = way1;
end

endmodule : selectway