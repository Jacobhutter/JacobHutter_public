module ALUK(input [15:0] A,B,
				input [1:0] select,
				output logic [15:0] Z);
			always_comb
				begin
				if(select == 2'b00)
					Z = A+B;
				else if(select == 2'b01)
					Z = ~A;
				else if(select == 2'b10)
					Z = A & B;
				else
					Z =  A;
				end

endmodule
