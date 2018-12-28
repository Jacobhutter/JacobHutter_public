module InvShiftRows( input [127:0] state,
						  output logic [127:0] state_out);
/*
void ShiftRows(uint8_t * state){
		uint8_t temp = state[1];
		state[1] = state[5];
		state[5] = state[9];
		state[9] = state[13];
		state[13] = temp;

		temp = state[2];
		state[2]= state[10];
		state[10] = temp;

		temp = state[6];
		state[6] = state[14];
		state[14] = temp;

		temp = state[3];
		state[3] = state[15];
		state[15] = state[11];
		state[11] = state[7];
		state[7] = temp;

}
*/

/*
 [7:0] , [39:32] , [71:64] , [103:96]
 [15:8] , [47:40] , [79:72] , [111:104]
 [23:16] , [55:48] , [87:80] , [119: 112]
 [31:24] , [63:56] , [95:88] , [127: 120]
*/
always_comb begin
state_out[7:0] = state[7:0];
state_out[15:8] = state[111:104]; // sr 1
state_out[23:16] = state[87:80];  // sr 2
state_out[31:24] = state[63:56]; // sr3
state_out[39:32] = state[39:32]; // hold
state_out[47:40] = state[15:8]; // sr1
state_out[55:48] = state[119:112]; // sr2
state_out[63:56] = state[95:88]; // sr3
state_out[71:64] = state[71:64]; // hold
state_out[79:72] = state[47:40]; // sr1
state_out[87:80] = state[23:16]; // sr2
state_out[95:88] = state[127:120]; // sr3
state_out[103:96] = state[103:96]; // hold
state_out[111:104] = state[79:72]; // sr1
state_out[119:112] = state[55:48]; // sr2
state_out[127:120] = state[31:24]; // sr3
end
endmodule
