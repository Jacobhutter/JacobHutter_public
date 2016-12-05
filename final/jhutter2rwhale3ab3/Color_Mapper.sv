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
                       input        [9:0] BallX, BallY, BallX2, BallY2, BallX3, BallY3, BallX4, BallY4, DrawX, DrawY, Ball_size,
                       input pause_enable,
                       input [399:0][199:0] game,
                       output logic [7:0]  Red, Green, Blue,
							  output logic flag
								);
    logic[3:0] counter0,counter1,counter2,counter3,counter4,counter5;
    always_ff @ (posedge Clk or posedge Reset) begin
      if(Reset)begin
        counter0 = 0;
        counter1 = 0;
        counter2 = 0;
        counter3 = 0;
        counter4 = 0;
        counter5 = 0;
      end
      if(counter0 % 10 == 0) begin
        counter0 = 4'd0;
        counter1 = counter1 + 1;
        end
      if(counter1 % 10 == 0) begin
          counter0 = 4'd0;
          counter1 = counter1 + 1;
      end
      else
        counter0 = counter0 + 1;
    end
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

		if(DrawX >= box && DrawX < box + bo_size_x && DrawY >= boy && DrawY < boy + bo_size_y)
		begin
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
			if((bo_on == 1'b1) && sprite_data[DrawX - box] == 1'b1)
			begin
			   Red = 8'h00;
            Green = 8'hff;
            Blue = 8'hff;

			end
			else if((c_on == 1'b1) && sprite_data[DrawX - box] == 1'b1)
			begin
			   Red = 8'h00;
            Green = 8'hff;
            Blue = 8'hff;

			end
			else if((o_on == 1'b1) && sprite_data[DrawX - box] == 1'b1)
			begin
			   Red = 8'h00;
            Green = 8'hff;
            Blue = 8'hff;

			end
			else if((r_on == 1'b1) && sprite_data[DrawX - box] == 1'b1)
			begin
			   Red = 8'h00;
            Green = 8'hff;
            Blue = 8'hff;

			end
			else if((e_on == 1'b1) && sprite_data[DrawX - box] == 1'b1)
			begin
			   Red = 8'h00;
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
      else
		  begin
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
        end
    end

endmodule
