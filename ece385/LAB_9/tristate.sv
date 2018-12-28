module tristate(input [1407:0] D,
                input select,
                output logic [1407:0]  OUT );
          always_comb begin
            if(select)
              OUT = D;
            else
              OUT = 1408'bz;
          end


endmodule
