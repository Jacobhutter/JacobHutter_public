module logic1(input logic [15:0] BUS_Data,
				  output logic N, Z, P);
				  
				  

				  
				  always_comb
					begin
				  P = 1'b0;
				  Z = 1'b0;
				  N = 1'b0;
				  if( BUS_Data == 16'h0000)
						Z = 1'b1;
				  else if(BUS_Data[15] == 1'b0)
						P = 1'b1;
				  else 
						N = 1'b1;
				  end
				  
			
endmodule 