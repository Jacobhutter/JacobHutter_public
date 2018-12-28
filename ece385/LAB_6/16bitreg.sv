module reg16(input  logic Clk, Reset, Load,
              input  logic [15:0]  D,
              output logic [15:0]  Data_Out);
				  
				  logic [15:0] q;
				  assign Data_Out = q;
always_ff @ (posedge Clk or posedge Reset)
    begin
		
	 	 if (Reset)
			  q <= 16'h0;
		 else if (Load)
			  q <= D;
		 else
			q <= Data_Out;
			
    end

endmodule
