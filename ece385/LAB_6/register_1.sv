module register_1(input D, Load, Clk, Reset,
						output logic Z);
		always_ff @ (posedge Clk or posedge Reset)
			begin
				if(Reset)
					Z <= 1'b0;
				else if (Load)
					Z <= D;	
				else
					Z <= Z;
			
			end			
endmodule
