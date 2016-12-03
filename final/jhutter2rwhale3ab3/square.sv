
module  square (input Reset, Clk, coord, edge_disableL, edge_disableR,
					input a_enable,s_enable,d_enable, pause_enable,
					input [9:0] center_x, center_y,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,
					output logic [9:0]  SQUAREX, SQUAREY, SQUARE_Size_x, SQUARE_Size_y,
					output logic at_bottom, at_edgeL, at_edgeR);

    logic [9:0] SQUARE_X_Pos, SQUARE_Y_Pos;
    parameter [9:0] SQUARE_X_Min=200;       // Leftmost point on the X axis
    parameter [9:0] SQUARE_X_Max=380;     // Rightmost point on the X axis
    parameter [9:0] SQUARE_Y_Min=0;       // Topmost point on the Y axis
    logic [9:0] SQUARE_Y_Max;     // Bottommost point on the Y axis


    parameter [9:0] SQUARE_X_Step=20;      // Step size on the X axis
    parameter [9:0] SQUARE_Y_Step=20;      // Step size on the Y axis

    assign SQUARE_Size_x = 20;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign SQUARE_Size_y = 20;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"

    always_ff @ (posedge Reset or posedge Clk)
    begin: Move_SQUARE
        if (Reset)  // Asynchronous Reset
        begin
						SQUARE_Y_Pos <= center_y;
						SQUARE_X_Pos <= center_x;
        end
		  else if(coord) begin
						SQUARE_Y_Pos <= center_y;
						SQUARE_X_Pos <= center_x;
		  end
        	else
        		begin
				if(pause_enable) begin
					SQUARE_X_Pos <= SQUARE_X_Pos;
					SQUARE_Y_Pos <= SQUARE_Y_Pos;
				end
				else if(a_enable == 1'b1 && edge_disableL != 1'b1)
				begin
					 SQUARE_X_Pos <= SQUARE_X_Pos - SQUARE_X_Step;
				end
				else if(s_enable == 1'b1)
				begin
					 SQUARE_Y_Pos <= SQUARE_Y_Pos + SQUARE_Y_Step;
				end
				else if(d_enable == 1'b1 && edge_disableR != 1'b1)
				begin
					 SQUARE_X_Pos <= SQUARE_X_Pos + SQUARE_X_Step;
				end
				else begin
				end


				 if ((SQUARE_Y_Pos) >= SQUARE_Y_Max )  // SQUARE is at the bottom edge
				 begin
				 		SQUARE_Y_Pos <= SQUARE_Y_Max;

				 end
				 if( (SQUARE_X_Pos) >= (SQUARE_X_Max) & ~s_enable) // SQUARE is at right edge
				 begin
						SQUARE_X_Pos <= SQUARE_X_Max;
				 end
				 else if( (SQUARE_X_Pos) >= (SQUARE_X_Max) & s_enable) // SQUARE is at right edge and s pressed
				 begin
						SQUARE_X_Pos <= SQUARE_X_Max - 20;
				 end
				 else if ((SQUARE_X_Pos) <= SQUARE_X_Min & ~d_enable) // SQUARE is at left edge
				 begin
						SQUARE_X_Pos <= SQUARE_X_Min;
				 end
				 else begin
				 end

		 end
    end
	 always_comb begin
		unique case(SQUAREX)
		10'd200: begin
			SQUARE_Y_Max = c1;
		end
		10'd220:  begin
			SQUARE_Y_Max = c2;
		end
		10'd240: begin
			SQUARE_Y_Max = c3;
		end
		10'd260: begin
			SQUARE_Y_Max = c4;
		end
		10'd280: begin
			SQUARE_Y_Max = c5;
		end
		10'd300: begin
			SQUARE_Y_Max = c6;
		end
		10'd320: begin
			SQUARE_Y_Max = c7;
		end
		10'd340: begin
			SQUARE_Y_Max = c8;
		end
		10'd360: begin
			SQUARE_Y_Max = c9;
		end
		10'd380: begin
			SQUARE_Y_Max = c10;
		end
		endcase
	 end
	 always_comb begin
	 if((SQUARE_X_Pos == SQUARE_X_Min) && ~d_enable)
	 		at_edgeL = 1'b1;
	 else
	 	  at_edgeL = 1'b0;
	 
	 if((SQUARE_X_Pos == SQUARE_X_Max) && ~s_enable)
	 		at_edgeR = 1'b1;
	 else
	 	  at_edgeR = 1'b0;

		if(SQUARE_Y_Pos == SQUARE_Y_Max)
			at_bottom = 1'b1;
		else
			at_bottom = 1'b0;

	 end

    assign SQUAREX = SQUARE_X_Pos;

    assign SQUAREY = SQUARE_Y_Pos;


endmodule
