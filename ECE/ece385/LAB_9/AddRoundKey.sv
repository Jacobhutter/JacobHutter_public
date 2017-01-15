module AddRoundKey(
             input [127:0] state,
						 input [3:0] progress,
						 input [1407:0] KeySchedule,
						 output logic [127:0] state2);

/*
void AddRoundKey(uint8_t * state, uint32_t  * word, int progress){
	uint8_t roundkey[16];
	for(int i = 0; i < 4; i++){
		roundkey[4 * i] = word[i + 4 * progress] >> 24;
		roundkey[4 * i + 1] = word[i + 4 * progress] >> 16;
		roundkey[4 * i + 2] = word[i + 4 * progress] >> 8;
		roundkey[4 * i + 3] = word[i + 4 * progress];
	}
	for(int i = 0; i < 16; i++){
		state[i] = roundkey[i] ^ state[i];
	}

}
*/
logic [127:0] roundkey0;
logic [127:0] roundkey1;
logic [127:0] roundkey2;
logic [127:0] roundkey3;
logic [127:0] roundkey4;
logic [127:0] roundkey5;
logic [127:0] roundkey6;
logic [127:0] roundkey7;
logic [127:0] roundkey8;
logic [127:0] roundkey9;
logic [127:0] roundkey10;
always_comb begin
	roundkey0 = KeySchedule[127:0];
		roundkey1 = KeySchedule[255:128];
			roundkey2 = KeySchedule[383:256];
				roundkey3 = KeySchedule[511:384];
					roundkey4 = KeySchedule[639:512];
						roundkey5 = KeySchedule[767:640];
							roundkey6 = KeySchedule[895:768];
								roundkey7 = KeySchedule[1023:896];
									roundkey8 = KeySchedule[1151:1024];
										roundkey9 = KeySchedule[1279:1152];
											roundkey10 = KeySchedule[1407:1280];
end
always_comb begin
case(progress)
	4'd0 : begin
	state2 = roundkey0 ^ state;
	end
	4'd1 : begin
	state2 = roundkey1 ^ state;
	end
	4'd2 : begin
	state2 = roundkey2 ^ state;
	end
	4'd3 : begin
	state2 = roundkey3 ^ state;
	end
	4'd4 : begin
	state2 = roundkey4 ^ state;
	end
	4'd5 : begin
	state2 = roundkey5 ^ state;
	end
	4'd6 : begin
	state2 = roundkey6 ^ state;
	end
	4'd7 : begin
	state2 = roundkey7 ^ state;
	end
	4'd8 : begin
	state2 = roundkey8 ^ state;
	end
	4'd9 : begin
	state2 = roundkey9 ^ state;
	end
	4'd10 : begin
	state2 = roundkey10 ^ state;
	end
	default : begin
	state2 = 128'bz;
	end
endcase

end
endmodule
