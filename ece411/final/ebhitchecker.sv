import lc3b_types::*;

module ebhitchecker
(
    input lc3b_address orig_address,
    input lc3b_address buf_address,
    input buf_valid,
    output logic hit_detect
);

always_comb
begin
    hit_detect = 0;
    if(buf_valid && orig_address == buf_address)
        hit_detect = 1;
end


endmodule : ebhitchecker
