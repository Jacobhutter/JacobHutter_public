//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//------------------------------------------------------------------------------


module ISDU ( 	input	Clk,
                        Reset,
						Run,
						Continue,
						ContinueIR,
        input [15:0] IR,
				input [3:0]  Opcode,
				input        IR_5, BEN, IR_11,

				output logic 	LD_MAR,
								LD_MDR,
								LD_IR,
								LD_BEN,
								LD_CC,
								LD_REG,
								LD_PC,

				output logic 	GatePC,
								GateMDR,
								GateALU,
								GateMARMUX,

				output logic [1:0] 	PCMUX,
				output logic 		SR2MUX, SR1MUX, DRMUX,
									ADDR1MUX,
				output logic [1:0] 	ADDR2MUX,
				output logic 		MARMUX,
        output logic [2:0]  SR2,
				output logic [1:0] 	ALUK,

				output logic 		Mem_CE,
									Mem_UB,
									Mem_LB,
									Mem_OE,
									Mem_WE
				);

    enum logic [4:0] {Halted, S_18, S_33_1, S_33_2, S_33_3, S_33_4, S_35, S_32, S_01, S_05,
							S_09, S_06, S_25_1, S_25_2, S_27, S_07, S_23, S_16_1, S_16_2, S_16_3, S_16_4, S_04, S_21,
							S_12, S_00, S_22, S_131, S_132}   State, Next_state;   // Internal state logic

    always_ff @ (posedge Clk or posedge Reset )
    begin : Assign_Next_State
        if (Reset)
            State <= Halted;
        else
            State <= Next_state;
    end

	always_comb
    begin
	    Next_state  <= State;

        unique case (State)
            Halted :
	            if (Run)
					Next_state <= S_18;
            S_18 :
                Next_state <= S_33_1;
            S_33_1 :
                Next_state <= S_33_2;
            S_33_2 :
                Next_state <= S_33_3;
			   S_33_3 :
                Next_state <= S_33_4;
            S_33_4 :
                Next_state <= S_35;
            S_35 :
                Next_state <= S_32;
 
            S_32 :
				case (Opcode)
					4'b0001 : // add
					    Next_state <= S_01;
					4'b0101 : // AND
						 Next_state <= S_05;
					4'b1001 : // NOT
					    Next_state <= S_09;
					4'b0000 : // BR
					    Next_state <= S_00;
					4'b1100 : // JMP
					    Next_state <= S_12;
					4'b0100 : // JSR
					    Next_state <= S_04;
					4'b0110 : // LDR
					    Next_state <= S_06;
					4'b0111 : // STR
					    Next_state <= S_07;
					4'b1101 : // Pause
						 Next_state <= S_131;
					default :
					    Next_state <= S_18;
				endcase
            S_01 :
				Next_state <= S_18;
				S_05 :
				Next_state <= S_18;
				S_06 :
				Next_state <= S_25_1;
				S_25_1: 
				Next_state <= S_25_2;
				S_25_2:
				Next_state <= S_27;
				S_27 :
				Next_state <= S_18;
				S_09 :
				Next_state <= S_18;
				S_00 :
					if(~BEN)
						Next_state <= S_18;
					else
						Next_state <= S_22;
				S_22 :
				Next_state <= S_18;
				S_12 :
				Next_state <= S_18;
        S_04 :
        Next_state <= S_21;
        S_21 :
        Next_state <= S_18;
        S_07 :
        Next_state <= S_23;
        S_23 :
        Next_state <= S_16_1;
        S_16_1 : // add more wait states??????????????????????
        Next_state <= S_16_2;
        S_16_2 :
        Next_state <= S_16_3;
        S_16_3 :
        Next_state <= S_16_4;     
        S_16_4 :
        Next_state <= S_18;
        S_131 :
          if(~Continue)
            Next_state <= S_131;
          else
            Next_state <= S_132;
        S_132 :
          if(Continue)
            Next_state <= S_132;
          else
            Next_state <= S_18;

			default : ;

	     endcase
    end

    always_comb
    begin
        //default controls signal values; within a process, these can be
        //overridden further down (in the case statement, in this case)
	    LD_MAR = 1'b0;
	    LD_MDR = 1'b0;
	    LD_IR = 1'b0;
	    LD_BEN = 1'b0;
	    LD_CC = 1'b0;
	    LD_REG = 1'b0;
	    LD_PC = 1'b0;
      SR2 = 3'b000;
	    GatePC = 1'b0;
	    GateMDR = 1'b0;
	    GateALU = 1'b0;
	    GateMARMUX = 1'b0;

		ALUK = 2'b00;

	    PCMUX = 2'b00;
	    DRMUX = 1'b0;
	    SR1MUX = 1'b0;
	    SR2MUX = 1'b0;
	    ADDR1MUX = 1'b0;
	    ADDR2MUX = 2'b00;
	    MARMUX = 1'b0;

	    Mem_OE = 1'b1;
	    Mem_WE = 1'b1;

	    case (State)
			Halted: ;
			S_18 :
				begin
					GatePC = 1'b1;
					LD_MAR = 1'b1;
					PCMUX = 2'b00;
					LD_PC = 1'b1;
				end
			S_33_1 :
				Mem_OE = 1'b0;
			S_33_2 :
				begin
					Mem_OE = 1'b0;
					LD_MDR = 1'b1;
                end
            S_35 :
                begin
					GateMDR = 1'b1;
					LD_IR = 1'b1;
                end
            S_32 :
                LD_BEN = 1'b1;
            S_01 : // add
                begin
               SR2 = IR[2:0];
					SR2MUX = IR_5; // pick reg
					SR1MUX = 1'b0; // pick mux choose of sr1 mux 6-8
					DRMUX = 1'b0; // pick destination register
					ALUK = 2'b00;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					LD_CC = 1'b1; // set cc
                end
				S_05 : // and
					begin
               SR2 = IR[2:0]; // pick reg
					SR2MUX = IR_5; // get source register 2 from reg file
					SR1MUX = 1'b0; // ir 6-8
					DRMUX = 1'b0;
					ALUK = 2'b10; // 10 is code for A&B;
					GateALU = 1'b1; // load data onto the bus
					LD_REG = 1'b1; // load bus data into the dr
					LD_CC = 1'b1; // set cc
					/*
					
					*/
					end
				S_06 : //LDR
					begin
					ADDR1MUX = 1'b1;
					ADDR2MUX = 2'b01;
					GateMARMUX = 1'b1;
					LD_MAR = 1'b1;
					end
				S_25_1 :
					begin
					Mem_OE = 1'b0;
					end
			
			   S_25_2 :
				  begin
					Mem_OE = 1'b0;
					LD_MDR = 1'b1;
				  end
				S_27 :
				begin
					GateMDR = 1'b1;
					LD_REG = 1'b1;
					LD_CC = 1'b1;
				end
				  
				S_09 : // not
					begin
					SR2MUX = 1'b1; // basically don't care
					SR1MUX = 1'b0; // 6-8 sr
					DRMUX = 1'b0; // storing
					ALUK = 2'b01; // 01 code for ~A
					GateALU = 1'b1; // put data on bus
					LD_REG = 1'b1; // load data
					LD_CC = 1'b1; // set cc
					end
				S_00 : ; // no outputs in state 0

				S_22 : // pc = pc + offset
					begin
					LD_PC = 1'b1; // load pc with new data;
					PCMUX = 2'b01; // select marmux for offset for pc
					ADDR1MUX = 1'b0;
					ADDR2MUX = 2'b10;
					end
				S_12 :
					begin
					SR1MUX = 1'b0; // get ir 6-8 as the base register
					ADDR1MUX = 1'b1; // get the data from that reg
					ADDR2MUX = 2'b00; // select 00000000000
					PCMUX = 2'b01; // pass data from reg into pc
					LD_PC = 1'b1;	// load data
					end
        S_04 :
          begin
          GatePC = 1'b1; // put pc onto the bus
          LD_REG = 1'b1; // prep allow register to load val from bus
          DRMUX = 1'b1; // quick select register 7
          end
        S_21 :
          begin
          ADDR2MUX = 2'b11; // take sext(IR[10:0])
          ADDR1MUX = 1'b0; // get previous pc
          PCMUX = 2'b01;  // select marmux data
          LD_PC  = 1'b1; // Load in pc
          end
        S_07 :
          begin
          ADDR1MUX = 1'b1; // add register to 5:0 IR
          ADDR2MUX = 2'b01; //
          GateMARMUX = 1'b1;
          SR1MUX = 1'b0; // get base register data
          LD_MAR = 1'b1; // mar gets the addition
          end
        //////////////////////////////////////////
        S_23 :
          begin
          // assume mio.en mux will pass bus data
          LD_MDR = 1'b1;
          SR1MUX = 1'b1; // get ir[11:9]
          ALUK = 2'b11; // use alu pass A ability
          GateALU = 1'b1; // put SR data onto bus where it is loaded into mdr
          end
        S_16_1:
          begin
          Mem_WE = 1'b0; // write to memory?
          end
        S_16_2:
          begin
          Mem_WE = 1'b0; // continue to write
          end
        S_16_3:
          begin
          Mem_WE = 1'b0; // continue to write
          end
        S_16_4:
          begin
          Mem_WE = 1'b0; // continue to write
          end

            default : ;
           endcase
       end

	assign Mem_CE = 1'b0;
	assign Mem_UB = 1'b0;
	assign Mem_LB = 1'b0;

endmodule
