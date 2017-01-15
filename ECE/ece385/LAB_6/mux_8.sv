module mux_8(input [15:0] zero_out, one_out, two_out, three_out, four_out, five_out, six_out, seven_out,
				 input [2:0] select,
				 output logic [15:0] Z);
				 
				 
				 
				always_comb
					begin
					case(select)
							3'b000 : 
							begin
							Z = zero_out;
							end
							3'b001 :
							begin
							Z = one_out;
							end
							3'b010 :							
							begin
							Z = two_out;
							end
							3'b011 :
							begin
							Z = three_out;
							end
							3'b100 :							
							begin
							Z = four_out;
							end
							3'b101 :							
							begin
							Z = five_out;
							end
							3'b110 :							
							begin
							Z = six_out;
							end
							3'b111 :							
							begin
							Z = seven_out;
							end
						endcase
					end
		endmodule 