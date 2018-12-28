module Reg200( input Clk , Reset,
               input [9:0] square1x,square1y,square2x,square2y,square3x,square3y,square4x,square4y,
               output logic [9:0][19:0] game
);
              logic [9:0][19:0] q;
              assign game = q;
              always_ff @ (posedge Clk or posedge Reset)
                begin
                  if(Reset)
                    q <= 200'd0;
                  else begin
                    initial begin
                      fork
                        for(int i = 200; i <400; i = i + 20 ) begin
                          for(int j = 0; j < 400; j = j + 20) begin
                            if((square1x == i && square1y ==j) || (square2x == i && square2y ==j) || square3x == i && square4y ==j || (square4x == i && square4y ==j))
                                q[i/20][j/20] = 1'b1;
                            else
                                q[i/20][j/20] = 1'b0;
                            end
                        end
                      join
                    end
                  end
                end

endmodule
