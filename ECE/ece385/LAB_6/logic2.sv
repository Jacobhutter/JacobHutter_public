module logic2(input [2:0] IR, NZP,
				  output logic BEN_Data);
			always_comb  
				begin
			BEN_Data = (IR[2]&NZP[0]) | (IR[1]&NZP[1]) | (IR[0] & NZP[2]);	
				end							  
endmodule 