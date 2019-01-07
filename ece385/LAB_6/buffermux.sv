module buffers(input logic MDR_Gate, PC_Gate, GateMARMUX, GateALU,
					input logic [15:0] PC,
					input logic [15:0] MDR,
					input logic [15:0] A3,
					input logic [15:0] ALUK_to_Gate,
					output logic [15:0] Z); // 4:1 mux
					logic [15:0] data_out;
					assign Z = data_out;
		always_comb
			begin
				if(MDR_Gate)
					data_out = MDR;
				else if(PC_Gate)
					data_out = PC;
				else if(GateMARMUX)
					data_out = A3;
				else
					data_out = ALUK_to_Gate;
			end

	endmodule