/*---------------------------------------------------------------------------
  --      AES.sv                                                           --
  --      Joe Meng                                                         --
  --      Fall 2013                                                        --
  --                                                                       --
  --      For use with ECE 298 Experiment 9                                --
  --      UIUC ECE Department                                              --
  ---------------------------------------------------------------------------*/

 //AES module interface with all ports, commented for Week 1
 module  AES ( input  [127:0]  Plaintext,
                               Cipherkey,
               input           Clk,
                               Reset,
                               LD_PL, LD_KS,
		 	  				               Run,
                               tri_state,
               input           [2:0] select,
               input           [3:0] Progress,
               output logic [127:0]  Ciphertext,
              output    logic      Ready  );

// Partial interface for Week 1
// Splitting the signals into 32-bit ones for compatibility with ModelSim
	/*module  AES ( input clk,
			  input  [0:31]  Cipherkey_0, Cipherkey_1, Cipherkey_2, Cipherkey_3,
              output [0:31]  keyschedule_out_0, keyschedule_out_1, keyschedule_out_2, keyschedule_out_3 );		*/




              logic [127:0] state2;
              logic [127:0] state_out;
              logic [127:0] out_state;
              logic [127:0] Data_Out;
              logic [127:0] Data_Out0;
              logic [127:0] Data_Out1;
              logic [127:0] Data_Out2;
              assign Data_Out = Ciphertext;
              assign Data_Out0 = Data_Out;
              assign Data_Out1 = Data_Out;
              assign Data_Out2 = Data_Out;
              logic [127:0] out;
              logic [1407:0] keyschedule;
              logic [1407:0] tri_state_in;
              logic [1407:0] tri_state_out;
              logic [127:0] mux_to_plaintext;
	KeyExpansion keyexpansion_0( // key expansion
	.*, .clk(Clk),.Cipherkey(Cipherkey),
	.KeySchedule(tri_state_in));

  tristate ts(.D(tri_state_in),.select(tri_state),.OUT(tri_state_out));

	AddRoundKey AR(.state(Data_Out0),.progress(Progress),.KeySchedule(keyschedule),.state2(state2));

	InvShiftRows ISR(.state(Data_Out1),.state_out(state_out));

	InvSubBytes ISB(.Clk(Clk),.state(Data_Out2),.out_state(out_state));

	InvMixColumns IMC0 (.in(Data_Out[31:0]),.out(out[31:0]));
  InvMixColumns IMC1 (.in(Data_Out[63:32]),.out(out[63:32]));
  InvMixColumns IMC2 (.in(Data_Out[95:64]),.out(out[95:64]));
  InvMixColumns IMC3 (.in(Data_Out[127:96]),.out(out[127:96]));

  BigReg Keyschedule(.Clk(Clk),.Reset(Reset),.Load(LD_KS),.D(tri_state_out),.Data_Out(keyschedule));

  SmallReg state(.Clk(Clk),.Reset(Reset),.Load(LD_PL),.D(mux_to_plaintext),.Data_Out(Ciphertext));


  mux four_to_one(.D1(state2),.D2(state_out),.D3(out_state),.D4(out),.D5(Plaintext),.select(select),.Z(mux_to_plaintext));


	//assign {keyschedule_out_0, keyschedule_out_1, keyschedule_out_2, keyschedule_out_3} = keyschedule[1280:1407];

endmodule
