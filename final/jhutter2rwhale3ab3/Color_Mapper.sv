//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input Clk, Reset,
                       input [9:0] BallX, BallY, BallX2, BallY2, BallX3, BallY3, BallX4, BallY4, DrawX, DrawY, Ball_size,
                       input pause_enable, game_over,
                       input [399:0][199:0] game,
                       output logic [7:0]  Red, Green, Blue,
							  output logic flag
								);
    logic[4:0] counter0,counter1,counter2,counter3,counter4,counter5;
    always_ff @ (posedge Clk or posedge Reset)
	 begin : base10counter
      if(Reset)begin
        counter0 = 0;
        counter1 = 0;
        counter2 = 0;
        counter3 <= 0;
        counter4 <= 0;
        counter5 <= 0;
      end
     else begin
	  if(counter0  == 9) begin
        counter0 = 0;
        counter1 = counter1 + 1;
        end
		else begin
			counter0 = counter0 + 1;
		end
      if(counter1 == 9) begin
          counter1 = 0;
          counter2 = counter2 + 1;
      end
      if(counter2 == 9) begin
          counter2 = 0;
          counter3 = counter3 + 1;
      end
      if(counter3 == 9) begin
          counter3 = 0;
          counter4 = counter4 + 1;
      end
      if(counter4 == 9) begin
          counter4 = 0;
          counter5 = counter5 + 1;
      end
      if(counter5 == 9) begin
          counter5 = 0;
      end
		 end
    end
    logic [15:0] dig0,dig1,dig2,dig3,dig4,dig5;
    always_comb begin
    unique case(counter0)
      0 : dig0 = 16*'h30;
      1 : dig0 = 16*'h31;
      2 : dig0 = 16*'h32;
      3 : dig0 = 16*'h33;
      4 : dig0 = 16*'h34;
      5 : dig0 = 16*'h35;
      6 : dig0 = 16*'h36;
      7 : dig0 = 16*'h37;
      8 : dig0 = 16*'h38;
      9 : dig0 = 16*'h39;
      default :  begin dig0 = 16*'h0;
      end
      endcase
      unique case(counter1)
        0 : dig1 = 16*'h30;
        1 : dig1 = 16*'h31;
        2 : dig1 = 16*'h32;
        3 : dig1 = 16*'h33;
        4 : dig1 = 16*'h34;
        5 : dig1 = 16*'h35;
        6 : dig1 = 16*'h36;
        7 : dig1 = 16*'h37;
        8 : dig1 = 16*'h38;
        9 : dig1 = 16*'h39;
        default : begin  dig1 = 16*'h0;
        end
        endcase
        unique case(counter2)
          0 : dig2 = 16*'h30;
          1 : dig2 = 16*'h31;
          2 : dig2 = 16*'h32;
          3 : dig2 = 16*'h33;
          4 : dig2 = 16*'h34;
          5 : dig2 = 16*'h35;
          6 : dig2 = 16*'h36;
          7 : dig2 = 16*'h37;
          8 : dig2 = 16*'h38;
          9 : dig2 = 16*'h39;
          default : begin dig2 = 16*'h0;
          end
          endcase
          unique case(counter3)
            0 : dig3 = 16*'h30;
            1 : dig3 = 16*'h31;
            2 : dig3 = 16*'h32;
            3 : dig3 = 16*'h33;
            4 : dig3 = 16*'h34;
            5 : dig3 = 16*'h35;
            6 : dig3 = 16*'h36;
            7 : dig3 = 16*'h37;
            8 : dig3 = 16*'h38;
            9 : dig3 = 16*'h39;
            default : begin dig3 = 16*'h0;
            end
            endcase
            unique case(counter4)
              0 : dig4 = 16*'h30;
              1 : dig4 = 16*'h31;
              2 : dig4 = 16*'h32;
              3 : dig4 = 16*'h33;
              4 : dig4 = 16*'h34;
              5 : dig4 = 16*'h35;
              6 : dig4 = 16*'h36;
              7 : dig4 = 16*'h37;
              8 : dig4 = 16*'h38;
              9 : dig4 = 16*'h39;
              default : begin dig4 = 16*'h0;
              end
              endcase
              unique case(counter5)
                0 : dig5 = 16*'h30;
                1 : dig5 = 16*'h31;
                2 : dig5 = 16*'h32;
                3 : dig5 = 16*'h33;
                4 : dig5 = 16*'h34;
                5 : dig5 = 16*'h35;
                6 : dig5 = 16*'h36;
                7 : dig5 = 16*'h37;
                8 : dig5 = 16*'h38;
                9 : dig5 = 16*'h39;
                default :  begin dig5 = 16*'h0;
                end
                endcase
    end
   logic g,a,m,e1,o,v,e2,r; // game over;
   logic [10:0]gx = 260;
   logic [10:0]gy = 200;

   logic [10:0]ax = 268;
   logic [10:0]mx = 276;
   logic [10:0]e1x = 284;
   logic [10:0]bigox = 308;
   logic [10:0]vx = 316;
   logic [10:0]e2x = 324;
   logic [10:0]bigrx = 332;

   logic d1,d2,d3,d4,d5,d6;
   logic [10:0]d1x = 540;
   logic [10:0]d1y = 116;
   logic[10:0] d1_size_x = 8;
   logic[10:0] d1_size_y = 16;

   logic [10:0]d2x = 532;
   logic [10:0]d2y = 116;
   logic[10:0] d2_size_x = 8;
   logic[10:0] d2_size_y = 16;

   logic [10:0]d3x = 524;
   logic [10:0]d3y = 116;
   logic[10:0] d3_size_x = 8;
   logic[10:0] d3_size_y = 16;

   logic [10:0]d4x = 516;
   logic [10:0]d4y = 116;
   logic[10:0] d4_size_x = 8;
   logic[10:0] d4_size_y = 16;

   logic [10:0]d5x = 508;
   logic [10:0]d5y = 116;
   logic[10:0] d5_size_x = 8;
   logic[10:0] d5_size_y = 16;

   logic [10:0]d6x = 500;
   logic [10:0]d6y = 116;
   logic[10:0] d6_size_x = 8;
   logic[10:0] d6_size_y = 16;


	 logic [10:0] sprite_addr;
	 logic [7:0] sprite_data;
	 font_rom fr(.addr(sprite_addr),.data(sprite_data));
	logic[10:0] box = 500;
	logic[10:0] boy = 100;
	logic[10:0] bo_size_x = 8;
	logic[10:0] bo_size_y = 16;
	logic bo_on;

	logic c_on;
	logic[10:0] cx = 508;
	logic[10:0] cy = 100;
	logic[10:0] c_size_x = 8;
	logic[10:0] c_size_y = 16;

		logic o_on;
	logic[10:0] ox = 516;
	logic[10:0] oy = 100;
	logic[10:0] o_size_x = 8;
	logic[10:0] o_size_y = 16;

		logic r_on;
	logic[10:0] rx = 524;
	logic[10:0] ry = 100;
	logic[10:0] r_size_x = 8;
	logic[10:0] r_size_y = 16;

		logic e_on;
	logic[10:0] ex = 532;
	logic[10:0] ey = 100;
	logic[10:0] e_size_x = 8;
	logic[10:0] e_size_y = 16;



 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.

    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	logic borderL_on;
	logic borderR_on;
	logic borderB_on;

	logic[10:0] borderl_x = 180;
	logic[10:0] borderl_y = 0;
	logic[10:0] borderl_size_x = 20;
	logic[10:0] borderl_size_y = 420;

   logic[10:0] borderr_x = 400;
	logic[10:0] borderr_y = 0;
	logic[10:0] borderr_size_x = 20;
	logic[10:0] borderr_size_y = 420;

	logic[10:0] borderb_x = 180;
	logic[10:0] borderb_y = 400;
	logic[10:0] borderb_size_x = 240;
	logic[10:0] borderb_size_y = 20;

	logic shape_on;
	logic[10:0] shape_x;
   assign shape_x	= BallX;
	logic[10:0] shape_y;
	assign shape_y = BallY;
	logic[10:0] shape_size_x;
   assign shape_size_x = Ball_size;
	logic[10:0] shape_size_y;
	assign shape_size_y = Ball_size;

	logic shape2_on;
	logic[10:0] shape2_x;
	assign shape2_x = BallX2;
	logic[10:0] shape2_y;
	assign shape2_y = BallY2;
	logic[10:0] shape2_size_x;
	assign shape2_size_x = Ball_size;
	logic[10:0] shape2_size_y;
	assign shape2_size_y = Ball_size;

	logic shape3_on;
	logic[10:0] shape3_x;
	assign shape3_x = BallX3;
	logic[10:0] shape3_y;
	assign shape3_y = BallY3;
	logic[10:0] shape3_size_x;
	assign shape3_size_x = Ball_size;
	logic[10:0] shape3_size_y;
	assign shape3_size_y = Ball_size;

	logic shape4_on;
	logic[10:0] shape4_x;
	assign shape4_x = BallX4;
	logic[10:0] shape4_y;
	assign shape4_y = BallY4;
	logic[10:0] shape4_size_x;
	assign shape4_size_x = Ball_size;
	logic[10:0] shape4_size_y;
	assign shape4_size_y = Ball_size;

	logic game_piece;
	//logic [199:0] dy,dx;
	//assign dy = DrawY;
	//assign dx = DrawX;
	assign game_piece = game[DrawY][DrawX + 56];
	logic store_on;
	logic[10:0] gameL = 11'd200;
	logic[10:0] gameR = 11'd400;
  logic p_on,p_on1;
    always_comb
    begin:Ball_on_proc
    if(game_over == 1'b1 && DrawX >= gx && DrawX < gx + d1_size_x && DrawY >= gy && DrawY < gy + d1_size_y)
		begin

    g = 1'b1;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
		c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
		bo_on = 1'b1;
		sprite_addr = (DrawY - 200 + 16*'h47);
		p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

		end
    else if(game_over == 1'b1 && DrawX >= ax && DrawX < ax + d1_size_x && DrawY >= gy && DrawY < gy + d1_size_y)
    begin
    g = 1'b0;
    a = 1'b1;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
    c_on = 1'b0;
    o_on = 1'b0;
    r_on = 1'b0;
    e_on = 1'b0;
    bo_on = 1'b1;
    sprite_addr = (DrawY - 200 + 16*'h41);
    p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

    end
    else if(game_over == 1'b1 && DrawX >= mx && DrawX < mx + d1_size_x && DrawY >= gy && DrawY < gy + d1_size_y)
    begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b1;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
    c_on = 1'b0;
    o_on = 1'b0;
    r_on = 1'b0;
    e_on = 1'b0;
    bo_on = 1'b1;
    sprite_addr = (DrawY - 200 + 16*'h4d);
    p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

    end
    else if(game_over == 1'b1 && DrawX >= e1x && DrawX < e1x + d1_size_x && DrawY >= gy && DrawY < gy + d1_size_y)
    begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b1;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
    c_on = 1'b0;
    o_on = 1'b0;
    r_on = 1'b0;
    e_on = 1'b0;
    bo_on = 1'b1;
    sprite_addr = (DrawY - 200 + 16*'h45);
    p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

    end
    else if(game_over == 1'b1 && DrawX >= bigox && DrawX < bigox + d1_size_x && DrawY >= gy && DrawY < gy + d1_size_y)
    begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b1;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
    c_on = 1'b0;
    o_on = 1'b0;
    r_on = 1'b0;
    e_on = 1'b0;
    bo_on = 1'b1;
    sprite_addr = (DrawY - 200 + 16*'h4f);
    p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

    end
    else if(game_over == 1'b1 && DrawX >= vx && DrawX < vx + d1_size_x && DrawY >= gy && DrawY < gy + d1_size_y)
    begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b1;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
    c_on = 1'b0;
    o_on = 1'b0;
    r_on = 1'b0;
    e_on = 1'b0;
    bo_on = 1'b1;
    sprite_addr = (DrawY - 200 + 16*'h56);
    p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

    end
    else if(game_over == 1'b1 && DrawX >= e2x && DrawX < e2x + d1_size_x && DrawY >= gy && DrawY < gy + d1_size_y)
    begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b1;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
    c_on = 1'b0;
    o_on = 1'b0;
    r_on = 1'b0;
    e_on = 1'b0;
    bo_on = 1'b1;
    sprite_addr = (DrawY - 200 + 16*'h45);
    p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

    end
    else if(game_over == 1'b1 && DrawX >= bigrx && DrawX < bigrx + d1_size_x && DrawY >= gy && DrawY < gy + d1_size_y)
    begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b1;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
    c_on = 1'b0;
    o_on = 1'b0;
    r_on = 1'b0;
    e_on = 1'b0;
    bo_on = 1'b1;
    sprite_addr = (DrawY - 200 + 16*'h52);
    p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

    end
    if(DrawX >= d1x && DrawX < d1x + d1_size_x && DrawY >= d1y && DrawY < d1y + d1_size_y)
		begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b1;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
		c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
		bo_on = 1'b1;
		sprite_addr = (DrawY - 116 + dig0);
		p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

		end
    else if(DrawX >= d2x && DrawX < d2x + d2_size_x && DrawY >= d2y && DrawY < d2y + d2_size_y)
		begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b1;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
		c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
		bo_on = 1'b1;
		sprite_addr = (DrawY - 116 + dig1);
		p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

		end
    else if(DrawX >= d3x && DrawX < d3x + d3_size_x && DrawY >= d3y && DrawY < d3y + d3_size_y)
		begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b1;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
		c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
		bo_on = 1'b1;
		sprite_addr = (DrawY - 116 + dig2);
		p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

		end
    else if(DrawX >= d4x && DrawX < d4x + d4_size_x && DrawY >= d4y && DrawY < d4y + d4_size_y)
		begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b1;
    d5 = 1'b0;
    d6 = 1'b0;
		c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
		bo_on = 1'b1;
		sprite_addr = (DrawY - 116 + dig3);
		p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

		end
    else if(DrawX >= d5x && DrawX < d5x + d5_size_x && DrawY >= d5y && DrawY < d5y + d5_size_y)
		begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b1;
    d6 = 1'b0;
		c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
		bo_on = 1'b1;
		sprite_addr = (DrawY - 116 + dig4);
		p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

		end
    else if(DrawX >= d6x && DrawX < d6x + d6_size_x && DrawY >= d6y && DrawY < d6y + d6_size_y)
		begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b1;
		c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
		bo_on = 1'b1;
		sprite_addr = (DrawY - 116 + dig5);
		p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

		end
		else if(DrawX >= box && DrawX < box + bo_size_x && DrawY >= boy && DrawY < boy + bo_size_y)
		begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
		c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
		bo_on = 1'b1;
		sprite_addr = (DrawY - 100 + 16*'h73);
		p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

		end
		else if(DrawX >= cx && DrawX < cx + c_size_x && DrawY >= cy && DrawY < cy + c_size_y) // c
		begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
		c_on = 1'b1;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
		bo_on = 1'b0;
		sprite_addr = (DrawY - 100 + 16*'h63);
		p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

		end
		else if(DrawX >= ox && DrawX < ox + o_size_x && DrawY >= oy && DrawY < oy + o_size_y) // o
		begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
		c_on = 1'b0;
		o_on = 1'b1;
		r_on = 1'b0;
		e_on = 1'b0;
		bo_on = 1'b0;
		sprite_addr = (DrawY - 100 + 16*'h6f);
		p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

		end
		else if(DrawX >= rx && DrawX < rx + r_size_x && DrawY >= ry && DrawY < ry + r_size_y) // r
		begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
		c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b1;
		e_on = 1'b0;
		bo_on = 1'b0;
		sprite_addr = (DrawY - 100 + 16*'h72);
		p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

		end
		else if(DrawX >= ex && DrawX < ex + e_size_x && DrawY >= ey && DrawY < ey + e_size_y) // e
		begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
		c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b1;
		bo_on = 1'b0;
		sprite_addr = (DrawY - 100 + 16*'h65);
		p_on1 = 1'b0;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;

		end
		else if(pause_enable && DrawX >= 20 && DrawX < 30 && DrawY >= 10 && DrawY < 30)begin
    g = 1'b0;
    a = 1'b0;
    m = 1'b0;
    e1 = 1'b0;
    o = 1'b0;
    v = 1'b0;
    e2 = 1'b0;
    r = 1'b0;
    d1 = 1'b0;
    d2 = 1'b0;
    d3 = 1'b0;
    d4 = 1'b0;
    d5 = 1'b0;
    d6 = 1'b0;
		bo_on = 1'b0;
				c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
		sprite_addr = 10'b0;
		p_on1 = 1'b1;
      p_on = 1'b0;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;
      end
      else if(pause_enable && DrawX >= 40 && DrawX < 50 && DrawY >= 10 && DrawY < 30)begin
      g = 1'b0;
      a = 1'b0;
      m = 1'b0;
      e1 = 1'b0;
      o = 1'b0;
      v = 1'b0;
      e2 = 1'b0;
      r = 1'b0;
      d1 = 1'b0;
      d2 = 1'b0;
      d3 = 1'b0;
      d4 = 1'b0;
      d5 = 1'b0;
      d6 = 1'b0;
		bo_on = 1'b0;
				c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
		sprite_addr = 10'b0;
		p_on1 = 1'b0;
      p_on = 1'b1;
      store_on = 1'b0;
      shape_on = 1'b0;
      shape2_on = 1'b0;
      shape3_on = 1'b0;
      shape4_on = 1'b0;
      borderL_on = 1'b0;
      borderR_on = 1'b0;
      borderB_on = 1'b0;
      end
			else if(DrawX < gameR && DrawX >= gameL && DrawY < gameR && game_piece == 1'b1) begin
      g = 1'b0;
      a = 1'b0;
      m = 1'b0;
      e1 = 1'b0;
      o = 1'b0;
      v = 1'b0;
      e2 = 1'b0;
      r = 1'b0;
      d1 = 1'b0;
      d2 = 1'b0;
      d3 = 1'b0;
      d4 = 1'b0;
      d5 = 1'b0;
      d6 = 1'b0;
				bo_on = 1'b0;
						c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
				sprite_addr = 10'b0;
				p_on = 1'b0;
				p_on1 = 1'b0;
				store_on = 1'b1;
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				borderL_on = 1'b0;
				borderR_on = 1'b0;
	         borderB_on = 1'b0;
			end
			else if(DrawX >= shape_x && DrawX < shape_x + shape_size_x &&
				DrawY >= shape_y && DrawY < shape_y + shape_size_y)
			begin
      g = 1'b0;
      a = 1'b0;
      m = 1'b0;
      e1 = 1'b0;
      o = 1'b0;
      v = 1'b0;
      e2 = 1'b0;
      r = 1'b0;
      d1 = 1'b0;
      d2 = 1'b0;
      d3 = 1'b0;
      d4 = 1'b0;
      d5 = 1'b0;
      d6 = 1'b0;
			bo_on = 1'b0;
			sprite_addr = 10'b0;
      p_on = 1'b0;
      p_on1 = 1'b0;
				c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
				store_on = 1'b0;
				shape_on = 1'b1;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				borderL_on = 1'b0;
				borderR_on = 1'b0;
	         borderB_on = 1'b0;
			end
			else if(DrawX >= borderl_x && DrawX < borderl_x + borderl_size_x &&
				DrawY >= borderl_y && DrawY < borderl_y + borderl_size_y)
			begin
      g = 1'b0;
      a = 1'b0;
      m = 1'b0;
      e1 = 1'b0;
      o = 1'b0;
      v = 1'b0;
      e2 = 1'b0;
      r = 1'b0;
      d1 = 1'b0;
      d2 = 1'b0;
      d3 = 1'b0;
      d4 = 1'b0;
      d5 = 1'b0;
      d6 = 1'b0;
			bo_on = 1'b0;
			sprite_addr = 10'b0;
      p_on = 1'b0;
      p_on1 = 1'b0;
				c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
				store_on = 1'b0;
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				borderL_on = 1'b1;
				borderR_on = 1'b0;
	         borderB_on = 1'b0;
			end
			else if(DrawX >= borderr_x && DrawX < borderr_x + borderr_size_x &&
				DrawY >= borderr_y && DrawY < borderr_y + borderr_size_y)
			begin
      g = 1'b0;
      a = 1'b0;
      m = 1'b0;
      e1 = 1'b0;
      o = 1'b0;
      v = 1'b0;
      e2 = 1'b0;
      r = 1'b0;
      d1 = 1'b0;
      d2 = 1'b0;
      d3 = 1'b0;
      d4 = 1'b0;
      d5 = 1'b0;
      d6 = 1'b0;
			bo_on = 1'b0;
			sprite_addr = 10'b0;
      p_on = 1'b0;
      p_on1 = 1'b0;
				c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
				store_on = 1'b0;
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				borderL_on = 1'b0;
				borderR_on = 1'b1;
	         borderB_on = 1'b0;
			end
			else if(DrawX >= borderb_x && DrawX < borderb_x + borderb_size_x &&
				DrawY >= borderb_y && DrawY < borderb_y + borderb_size_y)
			begin
      g = 1'b0;
      a = 1'b0;
      m = 1'b0;
      e1 = 1'b0;
      o = 1'b0;
      v = 1'b0;
      e2 = 1'b0;
      r = 1'b0;
      d1 = 1'b0;
      d2 = 1'b0;
      d3 = 1'b0;
      d4 = 1'b0;
      d5 = 1'b0;
      d6 = 1'b0;
			bo_on = 1'b0;
			sprite_addr = 10'b0;
      p_on = 1'b0;
      p_on1 = 1'b0;
				c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
				store_on = 1'b0;
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				borderL_on = 1'b0;
				borderR_on = 1'b0;
	         borderB_on = 1'b1;
			end
			else if(DrawX >= shape2_x && DrawX < shape2_x + shape2_size_x &&
					  DrawY >= shape2_y && DrawY < shape2_y + shape2_size_y)
			begin
      g = 1'b0;
      a = 1'b0;
      m = 1'b0;
      e1 = 1'b0;
      o = 1'b0;
      v = 1'b0;
      e2 = 1'b0;
      r = 1'b0;
      d1 = 1'b0;
      d2 = 1'b0;
      d3 = 1'b0;
      d4 = 1'b0;
      d5 = 1'b0;
      d6 = 1'b0;
			bo_on = 1'b0;
			sprite_addr = 10'b0;
        p_on = 1'b0;
        p_on1 = 1'b0;
		  		c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
				store_on = 1'b0;
				shape_on = 1'b0;
				shape2_on = 1'b1;
			   shape3_on = 1'b0;
				shape4_on = 1'b0;
				borderL_on = 1'b0;
				borderR_on = 1'b0;
	         borderB_on = 1'b0;
			end
			else if(DrawX >= shape3_x && DrawX < shape3_x + shape3_size_x &&
					  DrawY >= shape3_y && DrawY < shape3_y + shape3_size_y)
			begin
      g = 1'b0;
      a = 1'b0;
      m = 1'b0;
      e1 = 1'b0;
      o = 1'b0;
      v = 1'b0;
      e2 = 1'b0;
      r = 1'b0;
      d1 = 1'b0;
      d2 = 1'b0;
      d3 = 1'b0;
      d4 = 1'b0;
      d5 = 1'b0;
      d6 = 1'b0;
			bo_on = 1'b0;
			sprite_addr = 10'b0;
			   p_on = 1'b0;
         p_on1 = 1'b0;
					c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
				store_on = 1'b0;
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b1;
				shape4_on = 1'b0;
				borderL_on = 1'b0;
				borderR_on = 1'b0;
	         borderB_on = 1'b0;
			end
			else if(DrawX >= shape4_x && DrawX < shape4_x + shape4_size_x &&
					  DrawY >= shape4_y && DrawY < shape4_y + shape4_size_y)
			begin
      g = 1'b0;
      a = 1'b0;
      m = 1'b0;
      e1 = 1'b0;
      o = 1'b0;
      v = 1'b0;
      e2 = 1'b0;
      r = 1'b0;
      d1 = 1'b0;
      d2 = 1'b0;
      d3 = 1'b0;
      d4 = 1'b0;
      d5 = 1'b0;
      d6 = 1'b0;
			bo_on = 1'b0;
			sprite_addr = 10'b0;
			  p_on = 1'b0;
        p_on1 = 1'b0;
		  		c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
				store_on = 1'b0;
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b1;
				borderL_on = 1'b0;
				borderR_on = 1'b0;
	         borderB_on = 1'b0;
			end
			else
			begin
      g = 1'b0;
      a = 1'b0;
      m = 1'b0;
      e1 = 1'b0;
      o = 1'b0;
      v = 1'b0;
      e2 = 1'b0;
      r = 1'b0;
      d1 = 1'b0;
      d2 = 1'b0;
      d3 = 1'b0;
      d4 = 1'b0;
      d5 = 1'b0;
      d6 = 1'b0;
					c_on = 1'b0;
		o_on = 1'b0;
		r_on = 1'b0;
		e_on = 1'b0;
			bo_on = 1'b0;
			sprite_addr = 10'b0;
			   p_on = 1'b0;
         p_on1 = 1'b0;
				store_on = 1'b0;
				shape_on = 1'b0;
				shape2_on = 1'b0;
				shape3_on = 1'b0;
				shape4_on = 1'b0;
				borderL_on = 1'b0;
				borderR_on = 1'b0;
	         borderB_on = 1'b0;
			end
		end
    always_comb
    begin:RGB_Display
      if((g == 1'b1) && sprite_data[DrawX - gx] == 1'b1) begin
         Red = 8'hff;
         Green = 8'hff;
         Blue = 8'hff;
      end
      else if((a == 1'b1) && sprite_data[DrawX - ax] == 1'b1) begin
         Red = 8'hff;
         Green = 8'hff;
         Blue = 8'hff;
      end
      else if((m == 1'b1) && sprite_data[DrawX - mx] == 1'b1) begin
         Red = 8'hff;
         Green = 8'hff;
         Blue = 8'hff;
      end
      else if((e1 == 1'b1) && sprite_data[DrawX - e1x] == 1'b1) begin
         Red = 8'hff;
         Green = 8'hff;
         Blue = 8'hff;
      end
      else if((o == 1'b1) && sprite_data[DrawX - bigox] == 1'b1) begin
         Red = 8'hff;
         Green = 8'hff;
         Blue = 8'hff;
      end
      else if((v == 1'b1) && sprite_data[DrawX - vx] == 1'b1) begin
         Red = 8'hff;
         Green = 8'hff;
         Blue = 8'hff;
      end
      else if((e2 == 1'b1) && sprite_data[DrawX - e2x] == 1'b1) begin
         Red = 8'hff;
         Green = 8'hff;
         Blue = 8'hff;
      end
      else if((r == 1'b1) && sprite_data[DrawX - bigrx] == 1'b1) begin
         Red = 8'hff;
         Green = 8'hff;
         Blue = 8'hff;
      end
			else if((bo_on == 1'b1) && sprite_data[DrawX - box] == 1'b1)
			begin
			   Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;

			end
			else if((c_on == 1'b1) && sprite_data[DrawX - cx] == 1'b1)
			begin
			   Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;

			end
			else if((o_on == 1'b1) && sprite_data[DrawX - ox] == 1'b1)
			begin
			   Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;

			end
			else if((r_on == 1'b1) && sprite_data[DrawX - rx] == 1'b1)
			begin
			   Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;

			end
			else if((e_on == 1'b1) && sprite_data[DrawX - ex] == 1'b1)
			begin
			   Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;

			end
        else if ((shape_on == 1'b1))
        begin
				Red = 8'hff;
            Green = 8'hff;
            Blue = 8'h00;
        end
        else if((shape2_on == 1'b1))
        begin
				Red = 8'hff;
            Green = 8'hff;
            Blue = 8'h00;
		  end
		  else if(shape3_on == 1'b1)
		  begin
				Red = 8'hff;
            Green = 8'hff;
            Blue = 8'h00;
		  end
		  else if(borderL_on == 1'b1)
		  begin
				Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
		  end
		  else if(borderR_on == 1'b1)
		  begin
				Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
		  end
		  else if(borderB_on == 1'b1)
		  begin
				Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
		  end
		  else if(shape4_on == 1'b1)
		  begin
				Red = 8'hff;
            Green = 8'hff;
            Blue = 8'h00;
		  end
      else if(store_on == 1'b1) begin
          Red = 8'hff;
          Green = 8'h14;
          Blue = 8'h93;
      end
		  else if (p_on == 1'b1) begin
      Red = 8'hff;
      Green = 8'hff;
      Blue = 8'hff;
      end
      else if (p_on1 == 1'b1)begin
      Red = 8'hff;
      Green = 8'hff;
      Blue = 8'hff;
      end
      else if(d1 == 1'b1 && sprite_data[DrawX - d1x] == 1'b1) begin
      Red = 8'hff;
      Green = 8'hff;
      Blue = 8'hff;
      end
      else if(d2 == 1'b1 && sprite_data[DrawX - d2x] == 1'b1) begin
      Red = 8'hff;
      Green = 8'hff;
      Blue = 8'hff;
      end
      else if(d3 == 1'b1 && sprite_data[DrawX - d3x] == 1'b1 ) begin
      Red = 8'hff;
      Green = 8'hff;
      Blue = 8'hff;
      end
      else if(d4 == 1'b1 && sprite_data[DrawX - d4x] == 1'b1 ) begin
      Red = 8'hff;
      Green = 8'hff;
      Blue = 8'hff;
      end
      else if(d5 == 1'b1 && sprite_data[DrawX - d5x] == 1'b1) begin
      Red = 8'hff;
      Green = 8'hff;
      Blue = 8'hff;
      end
      else if(d6 == 1'b1 && sprite_data[DrawX - d6x] == 1'b1) begin
      Red = 8'hff;
      Green = 8'hff;
      Blue = 8'hff;
      end

      else
		  begin
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
        end
    end

endmodule
