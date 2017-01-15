module datapath(
				input Clk,
				input Reset,
				input logic LD_MAR, LD_MDR, LD_IR, LD_PC, LD_CC, LD_BEN, LD_REG,
				input logic GatePC, GateMDR, GateALU, GateMARMUX, MIO_EN,
				input logic [1:0] PCMUX,
				input logic SR2MUX, ADDR1MUX, DRMUX, SR1MUX,
				input logic [1:0] ADDR2MUX,
				input logic 	MARMUX,
				input logic [1:0] ALUK,
				input logic [15:0] MDR_In,
				input logic [2:0] SR2,


			output  logic[15:0]     MAR,
			output  logic[15:0]     MDR,
			output  logic[15:0]     IR,
			output  logic[15:0]     PC_Data,
			output  logic[15:0]     BUS,
			output  logic           BEN,
			output  logic [15:0] zero_out, one_out, two_out, three_out, four_out, five_out, six_out, seven_out,
			output logic neg, zer, pos,
			output logic [3:0] drreg
			);

logic [15:0] global_bus; //
assign  BUS = global_bus;
logic [15:0] muxconnect; //
logic [15:0] marmux; //
logic [15:0] mdrtogate; //
logic [15:0] muxtomdr;
logic [2:0] NZP_Connect;
logic [2:0] NZP_to_logic;
logic logic_to_BEN;
logic [2:0] SR1_to_Reg, DR_to_Reg;
logic [15:0] Reg_to_SR2;
logic [15:0] IR4,IR10,IR8,IR5;
assign IR4 = {{11{IR[4]}},IR[4:0]}; // sign extend IR[4:0]
assign IR10 = {{5{IR[10]}},IR[10:0]};
assign IR8 =  {{7{IR[8]}},IR[8:0]};
assign IR5 = {{10{IR[5]}},IR[5:0]};
logic [15:0] SR2_to_ALUK, SR2_to_MUX;
logic [15:0] Reg_to_ALUK;
logic [15:0] ALUK_to_Gate;
logic [15:0] A1,A2,A3;
//instantiate 16bit adder
assign A3 = A1 + A2; // 16 bit adder
assign drreg = DR_to_Reg;
//intstantiate pc


reg16 pc(.Clk(Clk),.Reset(Reset),.Load(LD_PC),.D(muxconnect),.Data_Out(PC_Data));

// instantiate mar

reg16 mar(.Clk(Clk),.Reset(Reset),.Load(LD_MAR),.D(global_bus),.Data_Out(MAR));

// instantiate mdr

reg16 mdr(.Clk(Clk),.Reset(Reset),.Load(LD_MDR),.D(muxtomdr),.Data_Out(MDR));

// instantiate ir

reg16 ir(.Clk(Clk),.Reset(Reset),.Load(LD_IR),.D(global_bus),.Data_Out(IR));

// instantiate pcmUX

four_mux pcMUX(.D1(PC_Data + 1'b1),.D2(A3),.D3(global_bus),.D4(16'h0000),.select(PCMUX),.Z(muxconnect));

//instantiate tristate buffer mux

buffers tri_state(.MDR_Gate(GateMDR),.PC_Gate(GatePC),.GateMARMUX(GateMARMUX),.GateALU(GateALU),.PC(PC_Data),.MDR(MDR),.A3(A3),.ALUK_to_Gate(ALUK_to_Gate),.Z(global_bus));

//instantiate MIO.en mux

two_mux MIO(.D1(global_bus),.D2(MDR_In),.select(MIO_EN),.Z(muxtomdr)); // 16 bit mux 

//instantiate bus to nzp logic
logic1 l1(.BUS_Data(global_bus),.N(NZP_Connect[0]),.Z(NZP_Connect[1]),.P(NZP_Connect[2]));

//instantiate NZP Registers

register_1 N(.*,.D(NZP_Connect[0]),.Load(LD_CC),.Z(NZP_to_logic[0]));

register_1 Z(.*,.D(NZP_Connect[1]),.Load(LD_CC),.Z(NZP_to_logic[1]));

register_1 P(.*,.D(NZP_Connect[2]),.Load(LD_CC),.Z(NZP_to_logic[2]));

assign neg = NZP_to_logic[0];
assign zer = NZP_to_logic[1];
assign pos = NZP_to_logic[2];

// instantiate logic from nzp to ben

logic2 l2(.IR(IR[11:9]),.NZP(NZP_to_logic),.BEN_Data(logic_to_BEN));

// instantiate BEN register_
register_1 Branch_enable(.*,.D(logic_to_BEN),.Load(LD_BEN),.Z(BEN));

//instantiate SR1 mux
mux_3 sr1(.D1(IR[8:6]),.D2(IR[11:9]),.select(SR1MUX),.Z(SR1_to_Reg));

// instantiate DR mux
mux_3 dr(.D1(IR[11:9]),.D2(3'b111),.select(DRMUX),.Z(DR_to_Reg));

// instantiate SR2 mux
two_mux sr2(.D1(SR2_to_MUX),.D2(IR4),.select(SR2MUX),.Z(SR2_to_ALUK)); ////////////// Reg_to_SR2

//instantiate register file
Reg_File RF(.*,.DR(DR_to_Reg),.SR1(SR1_to_Reg),.SR2(IR[2:0]),.BUS(global_bus),.LDREG(LD_REG),.SR1_Out(Reg_to_ALUK),.SR2_Out(SR2_to_MUX));

//instantiate ALUK
ALUK aluk(.A(Reg_to_ALUK),.B(SR2_to_ALUK),.select(ALUK),.Z(ALUK_to_Gate));

//instantiate ADDR1MUX
two_mux ADDR1(.D1(PC_Data),.D2(Reg_to_ALUK),.select(ADDR1MUX),.Z(A1));

//instantiate ADDR2MUX
four_mux ADDR2(.D1(16'h0000),.D2(IR5),.D3(IR8),.D4(IR10),.select(ADDR2MUX),.Z(A2));









endmodule
