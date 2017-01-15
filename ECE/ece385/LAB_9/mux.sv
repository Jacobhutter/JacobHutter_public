module mux(input [127:0] D1, D2, D3, D4, D5,
             input [2:0] select,
             output logic [127:0] Z);


             always_comb
              begin
               if(select == 0)
                Z = D1;
               else if(select == 1)
                Z = D2;
               else if(select == 2)
                 Z = D3;
              else if(select == 3)
                 Z = D4;
              else if(select == 4)
                Z = D5;
              else
                Z = 127'bz;
              end

endmodule
