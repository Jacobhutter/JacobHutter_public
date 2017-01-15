//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:
// Design Name:    ECE 385 Lab 6 Given Code - SLC-3 top-level (External SRAM)
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015
//------------------------------------------------------------------------------

//`include "SLC3_2.sv"
//import SLC3_2::*;

module slc3(
	input logic [15:0] S,
	input logic	Clk, Reset, Run, Continue,
	output logic [11:0] LED,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3,
	output logic CE, UB, LB, OE, WE,
	output logic [19:0] ADDR,
	output logic [15:0] dat,
	output logic [15:0] irdat,
	output logic [15:0] mdrdat,
	output logic ldmdrdat,
	output logic [15:0] bus_dat,
	output logic mioen,
	output logic [15:0] zero_out, one_out, two_out, three_out, four_out, five_out, six_out, seven_out,
	output logic [15:0] mardat,
	output logic neg, zer, pos, ben,
	output logic [3:0] drreg,
	inout wire [15:0] Data //tristate buffers need to be of type wire
	

);

//Declaration of push button active high signals
logic Reset_ah, Continue_ah, Run_ah;


assign Reset_ah = ~Reset;
assign Continue_ah = ~Continue;
assign Run_ah = ~Run;

// An array of 4-bit wires to connect the hex_drivers efficiently to wherever we want
// For Lab 1, they will direclty be connected to the IR register through an always_comb circuit
// For Lab 2, they will be patched into the MEM2IO module so that Memory-mapped IO can take place
logic [3:0] hex_4[3:0];
HexDriver hex_drivers[3:0] (hex_4, {HEX3, HEX2, HEX1, HEX0});
// This works thanks to http://stackoverflow.com/questions/1378159/verilog-can-we-have-an-array-of-custom-modules

// Internal connections
logic LD_MAR, LD_MDR,LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic SR2MUX, ADDR1MUX, MARMUX, MIO_EN, SR1MUX, DRMUX;
logic BEN;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic [15:0] Data_Mem_In, Data_Mem_Out;
assign MIO_EN = ~OE; //
assign mioen = MIO_EN;
logic [2:0] SR2;
logic [15:0] MAR, MDR, IR, PC_Data;
logic [15:0] BUS;
logic [15:0] MDR_In;
logic LD_IR;
assign ADDR = { 4'b0000, MAR }; //Note, our external SRAM chip is 1Mx16, but address space is only 64Kx16
assign dat = PC_Data;
assign irdat = IR;
assign mdrdat = MDR;
assign ldmdrdat = LD_MDR;
assign bus_dat = BUS;
assign mardat = MAR;
// Connect everything to the data path (you have to figure out this part)
datapath d0(.*,.Clk(Clk),.Reset(Reset_ah),.MAR(MAR),.MDR(MDR),.IR(IR),.PC_Data(PC_Data),.MDR_In(MDR_In),.BUS(BUS),.SR2(SR2),.BEN(BEN));
assign ben = BEN; // 

// State machine, you need to fill in the code here as well
	//	 assign hex_4[3] = IR[15:12];
		// assign hex_4[2] = IR[11:8];
		// assign hex_4[1] = IR[7:4];
		// assign hex_4[0] = IR[3:0];
		 assign LED = IR[11:0];
Mem2IO memory_subsystem(
	.*, .Reset(Reset_ah), .A(ADDR), .Switches(S),
	.HEX0(hex_4[0]), .HEX1(hex_4[1]), .HEX2(hex_4[2]), .HEX3(hex_4[3]),
	
	.Data_CPU_In(MDR), .Data_CPU_Out(MDR_In)
);

ISDU state_controller(
	.*, .Reset(Reset_ah), .Run(Run_ah), .Continue(Continue_ah), .ContinueIR(Continue_ah),
	.Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
	.Mem_CE(CE), .Mem_UB(UB), .Mem_LB(LB), .Mem_OE(OE), .Mem_WE(WE),.SR2(SR2),.BEN(BEN)
);
// Break the tri-state bus to the ram into input/outputs
tristate #(.N(16)) tr0(
	.Clk(Clk), .OE(~WE),.In(Data_Mem_Out), .Out(Data_Mem_In), .Data(Data)
);

test_memory test_mem (.Clk(Clk), .Reset(Reset_ah), .I_O(Data), .A(ADDR), .CE(CE), .UB(UB),
.LB(LB), .OE(OE), .WE(WE));
// uncomment to use test memory

endmodule
