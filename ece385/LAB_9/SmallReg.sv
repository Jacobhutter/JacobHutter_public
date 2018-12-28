module SmallReg(input  logic Clk, Reset, Load,
              input  logic [127:0]  D,
              output logic [127:0]  Data_Out);

				  logic [127:0] q;
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
