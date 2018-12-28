module four_mux(input logic [15:0] D1, // pc +1
				input logic [15:0] D2, // marmux
				input logic [15:0] D3, // Bus
				input logic [15:0] D4, // h0000
				input logic [1:0] select,
				output logic [15:0] Z);
			always_comb
				begin
					case(select)
						2'b00 : Z = D1;
						2'b01 : Z = D2;
						2'b10 : Z = D3;
						2'b11 : Z = D4; // zero out
					endcase
				end
		endmodule
