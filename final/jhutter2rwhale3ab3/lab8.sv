//-------------------------------------------------------------------------
//      lab7_usb.sv                                                      --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Fall 2014 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 7                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module  lab8 		( input         CLOCK_50,
                       input[3:0]    KEY, //bit 0 is set up as Reset
							  output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, // HEX6, HEX7,
							  //output [8:0]  LEDG,
							  //output [17:0] LEDR,
							  // VGA Interface
                       output [7:0]  VGA_R,					//VGA Red
							                VGA_G,					//VGA Green
												 VGA_B,					//VGA Blue
							  output        VGA_CLK,				//VGA Clock
							                VGA_SYNC_N,			//VGA Sync signal
												 VGA_BLANK_N,			//VGA Blank signal
												 VGA_VS,					//VGA virtical sync signal
												 VGA_HS,					//VGA horizontal sync signal
							  // CY7C67200 Interface
							  inout [15:0]  OTG_DATA,						//	CY7C67200 Data bus 16 Bits
							  output [1:0]  OTG_ADDR,						//	CY7C67200 Address 2 Bits
							  output        OTG_CS_N,						//	CY7C67200 Chip Select
												 OTG_RD_N,						//	CY7C67200 Write
												 OTG_WR_N,						//	CY7C67200 Read
												 OTG_RST_N,						//	CY7C67200 Reset
							  input			 OTG_INT,						//	CY7C67200 Interrupt
							  // SDRAM Interface for Nios II Software
							  output [12:0] DRAM_ADDR,				// SDRAM Address 13 Bits
							  inout [31:0]  DRAM_DQ,				// SDRAM Data 32 Bits
							  output [1:0]  DRAM_BA,				// SDRAM Bank Address 2 Bits
								  output [3:0]  DRAM_DQM,				// SDRAM Data Mast 4 Bits
								  output			 DRAM_RAS_N,			// SDRAM Row Address Strobe
								  output			 DRAM_CAS_N,			// SDRAM Column Address Strobe
								  output			 DRAM_CKE,				// SDRAM Clock Enable
								  output			 DRAM_WE_N,				// SDRAM Write Enable
								  output			 DRAM_CS_N,				// SDRAM Chip Select
								  output			 DRAM_CLK				// SDRAM Clock
											);

    logic Reset_h, vssig, Clk;
    logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig;
	 logic [9:0] ballxsig2,ballysig2,ballxsig3,ballysig3,ballxsig4,ballysig4;
	 logic [15:0] keycode;
	 logic s_enable;
	 logic a_enable;
	 logic d_enable; // enable that d
	 logic drop_enable;
	 logic pause_enable, restart_enable;
   logic edge1L,edge2L,edge3L,edge4L;
	logic edge1R,edge2R,edge3R,edge4R;
   logic [399:0][199:0] game; ////// boi

	 assign Clk = CLOCK_50;
    assign {Reset_h}=~ (KEY[0]);  // The push buttons are active low


	 wire [1:0] hpi_addr;
	 wire [15:0] hpi_data_in, hpi_data_out;
	 wire hpi_r, hpi_w,hpi_cs;

	 hpi_io_intf hpi_io_inst(   .from_sw_address(hpi_addr),
										 .from_sw_data_in(hpi_data_in),
										 .from_sw_data_out(hpi_data_out),
										 .from_sw_r(hpi_r),
										 .from_sw_w(hpi_w),
										 .from_sw_cs(hpi_cs),
		 								 .OTG_DATA(OTG_DATA),
										 .OTG_ADDR(OTG_ADDR),
										 .OTG_RD_N(OTG_RD_N),
										 .OTG_WR_N(OTG_WR_N),
										 .OTG_CS_N(OTG_CS_N),
										 .OTG_RST_N(OTG_RST_N),
										 .OTG_INT(OTG_INT),
										 .Clk(Clk),
										 .Reset(Reset_h)
	 );

	 //The connections for nios_system might be named different depending on how you set up Qsys
	 nios_system nios_system(
										 .clk_clk(Clk),
										 .reset_reset_n(KEY[0]),
										 .sdram_wire_addr(DRAM_ADDR),
										 .sdram_wire_ba(DRAM_BA),
										 .sdram_wire_cas_n(DRAM_CAS_N),
										 .sdram_wire_cke(DRAM_CKE),
										 .sdram_wire_cs_n(DRAM_CS_N),
										 .sdram_wire_dq(DRAM_DQ),
										 .sdram_wire_dqm(DRAM_DQM),
										 .sdram_wire_ras_n(DRAM_RAS_N),
										 .sdram_wire_we_n(DRAM_WE_N),
										 .sdram_clk_clk(DRAM_CLK),
										 .keycode_export(keycode),
										 .otg_hpi_address_export(hpi_addr),
										 .otg_hpi_data_in_port(hpi_data_in),
										 .otg_hpi_data_out_port(hpi_data_out),
										 .otg_hpi_cs_export(hpi_cs),
										 .otg_hpi_r_export(hpi_r),
										 .otg_hpi_w_export(hpi_w));
   // vga controller
   logic rotate_enable;
    vga_controller vgasync_instance(.Clk(Clk),.Reset(Reset_h),.hs(VGA_HS),.vs(VGA_VS),.pixel_clk(VGA_CLK),.blank(VGA_BLANK_N),.sync(VGA_SYNC_N),.DrawX(drawxsig),.DrawY(drawysig));

    // ensures that one keypress only moves block over one
<<<<<<< HEAD
	 keycode_state_machine ksm (.Clk(VGA_VS),.Reset(Reset_h),.keycode(keycode),.step_enable_a(a_enable),.step_enable_s(s_enable),.step_enable_d(d_enable),.pause_enable(pause_enable),.restart_enable(restart_enable),.rotate_enable(rotate_enable));
=======
	 keycode_state_machine ksm (.Clk(VGA_VS),.Reset(Reset_h),.keycode(keycode),.step_enable_a(a_enable),.step_enable_s(s_enable),.step_enable_d(d_enable),.pause_enable(pause_enable),.restart_enable(restart_enable),.rotate_enable());
>>>>>>> 9b1c6dc1725e0fc6ff297331fa33a15b8a3f133f

  // logic for up counter and flag to drop down
   logic [5:0] data_connect;
	logic flag;
	always_comb begin
		if(data_connect == 6'b111100)
			flag = 1'b1;
		else
			flag = 1'b0;
		end

 // register that counts up and overflows at 64 ish
   reg6 r6(.Clk(VGA_VS),.Reset(Reset_h),.D(data_connect),.Data_Out(data_connect));

 // state_machine that controls the placement of the squares into shapes
 logic at_bottom;
 logic at_bottom2;
 logic at_bottom3;
 logic at_bottom4;
 logic [9:0] center_x;
 logic [9:0] center_y;
 logic [9:0] center_x2;
 logic [9:0] center_y2;
  logic [9:0] center_x3;
 logic [9:0] center_y3;
  logic [9:0] center_x4;
 logic [9:0] center_y4;
 logic edge_disableL;
 assign edge_disableL = edge1L|edge2L|edge3L|edge4L;
  logic edge_disableR;
 assign edge_disableR = edge1R|edge2R|edge3R|edge4R;
 logic coord; // interrupt
 logic [3:0]shape;
 logic next;
 logic [9:0] next_square_1x,next_square_1y,next_square_2x,next_square_2y,next_square_3x,next_square_3y,next_square_4x,next_square_4y;
 shape_generator s_g(.next(next),.shape(shape),.coord(coord),.Clk(VGA_VS),.Reset(Reset_h|restart_enable),.at_bottom2(at_bottom2),.at_bottom(at_bottom),.at_bottom3(at_bottom3),.at_bottom4(at_bottom4),.new_square_1x(center_x),.new_square_1y(center_y),.new_square_2x(center_x2),.new_square_2y(center_y2),.new_square_3x(center_x3),.new_square_3y(center_y3),.new_square_4x(center_x4),.new_square_4y(center_y4),
  .next_square_1x(next_square_1x),.next_square_1y(next_square_1y),.next_square_2x(next_square_2x),.next_square_2y(next_square_2y),.next_square_3x(next_square_3x),.next_square_3y(next_square_3y),.next_square_4x(next_square_4x),.next_square_4y(next_square_4y));

 // one instance of a square
<<<<<<< HEAD
square square_instance(.sq(0),.rotate_enable(rotate_enable),.shape(shape),.game(game),.pause_enable(pause_enable),.at_edgeL(edge1L),.at_edgeR(edge1R),.edge_disableL(edge_disableL),.edge_disableR(edge_disableR),.at_bottom(at_bottom),.center_x(center_x),.center_y(center_y),.Reset(Reset_h|restart_enable),.a_enable(a_enable),.s_enable(s_enable|flag),.d_enable(d_enable),
   .Clk(VGA_VS),.SQUAREX(ballxsig),.SQUAREY(ballysig),.SQUARE_Size_x(ballsizesig),.SQUARE_Size_y(),.coord(coord));
 // ne square
square square_instance2(.sq(1),.rotate_enable(rotate_enable),.shape(shape),.game(game),.pause_enable(pause_enable),.at_edgeL(edge2L),.at_edgeR(edge2R),.edge_disableL(edge_disableL),.edge_disableR(edge_disableR),.at_bottom(at_bottom2),.center_x(center_x2),.center_y(center_y2),.Reset(Reset_h|restart_enable),.a_enable(a_enable),.s_enable(s_enable|flag),.d_enable(d_enable),
   .Clk(VGA_VS),.SQUAREX(ballxsig2),.SQUAREY(ballysig2),.SQUARE_Size_x(),.SQUARE_Size_y(),.coord(coord));

  // sw square
square square_instance3(.sq(2),.rotate_enable(rotate_enable),.shape(shape),.game(game),.pause_enable(pause_enable),.at_edgeL(edge3L),.at_edgeR(edge3R),.edge_disableL(edge_disableL),.edge_disableR(edge_disableR),.at_bottom(at_bottom3),.center_x(center_x3),.center_y(center_y3),.Reset(Reset_h|restart_enable),.a_enable(a_enable),.s_enable(s_enable|flag),.d_enable(d_enable),
   .Clk(VGA_VS),.SQUAREX(ballxsig3),.SQUAREY(ballysig3),.SQUARE_Size_x(),.SQUARE_Size_y(),.coord(coord));

	// se square
square square_instance4(.sq(3),.rotate_enable(rotate_enable),.shape(shape),.game(game),.pause_enable(pause_enable),.at_edgeL(edge4L),.at_edgeR(edge4R),.edge_disableL(edge_disableL),.edge_disableR(edge_disableR),.at_bottom(at_bottom4),.center_x(center_x4),.center_y(center_y4),.Reset(Reset_h|restart_enable),.a_enable(a_enable),.s_enable(s_enable|flag),.d_enable(d_enable),
=======
square square_instance(.game(game),.pause_enable(pause_enable),.at_edgeL(edge1L),.at_edgeR(edge1R),.edge_disableL(edge_disableL),.edge_disableR(edge_disableR),.at_bottom(at_bottom),.center_x(center_x),.center_y(center_y),.Reset(Reset_h|restart_enable),.a_enable(a_enable),.s_enable(s_enable|flag),.d_enable(d_enable),
   .Clk(VGA_VS),.SQUAREX(ballxsig),.SQUAREY(ballysig),.SQUARE_Size_x(ballsizesig),.SQUARE_Size_y(),.coord(coord));
 // ne square
square square_instance2(.game(game),.pause_enable(pause_enable),.at_edgeL(edge2L),.at_edgeR(edge2R),.edge_disableL(edge_disableL),.edge_disableR(edge_disableR),.at_bottom(at_bottom2),.center_x(center_x2),.center_y(center_y2),.Reset(Reset_h|restart_enable),.a_enable(a_enable),.s_enable(s_enable|flag),.d_enable(d_enable),
   .Clk(VGA_VS),.SQUAREX(ballxsig2),.SQUAREY(ballysig2),.SQUARE_Size_x(),.SQUARE_Size_y(),.coord(coord));

  // sw square
square square_instance3(.game(game),.pause_enable(pause_enable),.at_edgeL(edge3L),.at_edgeR(edge3R),.edge_disableL(edge_disableL),.edge_disableR(edge_disableR),.at_bottom(at_bottom3),.center_x(center_x3),.center_y(center_y3),.Reset(Reset_h|restart_enable),.a_enable(a_enable),.s_enable(s_enable|flag),.d_enable(d_enable),
   .Clk(VGA_VS),.SQUAREX(ballxsig3),.SQUAREY(ballysig3),.SQUARE_Size_x(),.SQUARE_Size_y(),.coord(coord));

	// se square
square square_instance4(.game(game),.pause_enable(pause_enable),.at_edgeL(edge4L),.at_edgeR(edge4R),.edge_disableL(edge_disableL),.edge_disableR(edge_disableR),.at_bottom(at_bottom4),.center_x(center_x4),.center_y(center_y4),.Reset(Reset_h|restart_enable),.a_enable(a_enable),.s_enable(s_enable|flag),.d_enable(d_enable),
>>>>>>> 9b1c6dc1725e0fc6ff297331fa33a15b8a3f133f
   .Clk(VGA_VS),.SQUAREX(ballxsig4),.SQUAREY(ballysig4),.SQUARE_Size_x(),.SQUARE_Size_y(),.coord(coord));


 // score counter register
  logic [15:0] scoreboard;
  reg16 score(.Clk(VGA_VS),.Reset(Reset_h|restart_enable),.D((flag|s_enable)&(~at_bottom)&(~pause_enable)),.Data_Out(scoreboard));

  gameboard gb(.Clk(VGA_VS),.Reset(Reset_h|restart_enable),.at_bottom(at_bottom|at_bottom2|at_bottom3|at_bottom4),.square1x(ballxsig),.square1y(ballysig),.square2x(ballxsig2),.square2y(ballysig2),
  .square3x(ballxsig3),.square3y(ballysig3),.square4x(ballxsig4),.square4y(ballysig4),.game(game));
<<<<<<< HEAD
  logic [2:0] endit;
  logic confirm;
  always_comb begin
   if(endit == 2)
    confirm = 1;
   else
    confirm = 0;
  end
  always_ff @(posedge VGA_VS or Reset_h) begin

    if((at_bottom | at_bottom2 | at_bottom3 | at_bottom4) && endit == 1'd0)
      endit = 1;
    else if((at_bottom | at_bottom2 | at_bottom3 | at_bottom4) && endit == 1'd1)
      endit = 2;
    else
      endit = 0;
  end
 // tells vga controller which pixels are painted what color
color_mapper color_instance(.game_over(confirm),.Clk((flag|s_enable)&(~at_bottom)&(~pause_enable)),.Reset(Reset_h|restart_enable),.pause_enable(pause_enable),.BallX(ballxsig),.BallY(ballysig),.BallX2(ballxsig2),.BallY2(ballysig2),.BallX3(ballxsig3),.BallY3(ballysig3),.BallX4(ballxsig4),.BallY4(ballysig4),.DrawX(drawxsig),.DrawY(drawysig),.Ball_size(ballsizesig),.Red(VGA_R),.Blue(VGA_B),.Green(VGA_G),.game(game));
=======

  rotation rt();
 // tells vga controller which pixels are painted what color
color_mapper color_instance(.pause_enable(pause_enable),.BallX(ballxsig),.BallY(ballysig),.BallX2(ballxsig2),.BallY2(ballysig2),.BallX3(ballxsig3),.BallY3(ballysig3),.BallX4(ballxsig4),.BallY4(ballysig4),.DrawX(drawxsig),.DrawY(drawysig),.Ball_size(ballsizesig),.Red(VGA_R),.Blue(VGA_B),.Green(VGA_G),.game(game));
>>>>>>> 9b1c6dc1725e0fc6ff297331fa33a15b8a3f133f

  // uncomment the exported HEXN above in module declaration and comment two lines above
   HexDriver hex_inst_0 (scoreboard[3:0],HEX0);
   HexDriver hex_inst_1 (scoreboard[7:4],HEX1);
   HexDriver hex_inst_2 (scoreboard[11:8],HEX2);
   HexDriver hex_inst_3 (scoreboard[15:12],HEX3);
   HexDriver hex_inst_4 (keycode[3:0], HEX4);
   HexDriver hex_inst_5 (keycode[7:4], HEX5);


endmodule
