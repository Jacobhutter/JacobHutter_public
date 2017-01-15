module two_mux(input logic [15:0] D1,D2,
					input logic select,
					output logic [15:0] Z);

				always_comb
					begin
						if(select)
							Z = D2;
						else
							Z = D1;
					end

		endmodule
