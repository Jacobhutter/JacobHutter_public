module Reg_File(input [2:0] DR, SR1, SR2,
					 input [15:0] BUS,
					 input LDREG, Clk, Reset,
					 output [15:0] SR1_Out, SR2_Out,
					 output logic [15:0] zero_out, one_out, two_out, three_out, four_out, five_out, six_out, seven_out
					);
					
				logic zero,one,two,three,four,five,six,seven;
				

				always_comb 
					begin
             zero = 1'b0;
				 one = 1'b0;
				 two = 1'b0;
				 three = 1'b0;
				 four = 1'b0;
				 five = 1'b0;
				 six = 1'b0;
				 seven = 1'b0;
						case(DR)
							3'b000 : 
							begin
							zero = 1'b1;
							end
							3'b001 :
							begin
							one = 1'b1;
							end
							3'b010 :							
							begin
							two = 1'b1;
							end
							3'b011 :
							begin
							three = 1'b1;
							end
							3'b100 :							
							begin
							four = 1'b1;
							end
							3'b101 :							
							begin
							five = 1'b1;
							end
							3'b110 :							
							begin
							six = 1'b1;
							end
							3'b111 :							
							begin
							seven = 1'b1;
							end
						endcase
					end
				reg16 R0(.*,.Load(LDREG & zero),.D(BUS),.Data_Out(zero_out));	
				
				reg16 R1(.*,.Load(LDREG & one),.D(BUS),.Data_Out(one_out));	
				
				reg16 R2(.*,.Load(LDREG & two),.D(BUS),.Data_Out(two_out));	
				
				reg16 R3(.*,.Load(LDREG & three),.D(BUS),.Data_Out(three_out));	
				
				reg16 R4(.*,.Load(LDREG & four),.D(BUS),.Data_Out(four_out));	
				
				reg16 R5(.*,.Load(LDREG & five),.D(BUS),.Data_Out(five_out));	
				
				reg16 R6(.*,.Load(LDREG & six),.D(BUS),.Data_Out(six_out));	
				
				reg16 R7(.*,.Load(LDREG & seven),.D(BUS),.Data_Out(seven_out));
			
				mux_8 M81(.*,.select(SR1),.Z(SR1_Out));
				mux_8 M82(.*,.select(SR2),.Z(SR2_Out));
endmodule
