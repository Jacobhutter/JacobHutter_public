
module  square (input Reset, Clk, coord, edge_disableL, edge_disableR,
<<<<<<< HEAD
					input a_enable,s_enable,d_enable, pause_enable, rotate_enable,
					input [399:0][199:0] game,
					input [3:0] shape,
					input [2:0] sq,
=======
					input a_enable,s_enable,d_enable, pause_enable,
					input [399:0][199:0] game,
>>>>>>> 9b1c6dc1725e0fc6ff297331fa33a15b8a3f133f
					input [9:0] center_x, center_y,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,
					output logic [9:0]  SQUAREX, SQUAREY, SQUARE_Size_x, SQUARE_Size_y,
					output logic at_bottom, at_edgeL, at_edgeR);

    logic [9:0] SQUARE_X_Pos, SQUARE_Y_Pos;
    parameter [9:0] SQUARE_X_Min=200;       // Leftmost point on the X axis
    parameter [9:0] SQUARE_X_Max=380;     // Rightmost point on the X axis
    parameter [9:0] SQUARE_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] SQUARE_Y_Max = 380;     // Bottommost point on the Y axis


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
				 if( (SQUARE_X_Pos) >= (SQUARE_X_Max) & ~a_enable) // SQUARE is at right edge
				 begin
						SQUARE_X_Pos <= SQUARE_X_Max;
				 end
			   if ((SQUARE_X_Pos) <= SQUARE_X_Min & ~d_enable) // SQUARE is at left edge
				 begin
						SQUARE_X_Pos <= SQUARE_X_Min;
				 end
		 end
    end

	 always_comb begin
	 if(((SQUARE_X_Pos == SQUARE_X_Min) || game[SQUARE_Y_Pos][SQUARE_X_Pos - 220] == 1'b1) && ~d_enable ) // probe one left
	 		at_edgeL = 1'b1;
	 else
	 	  at_edgeL = 1'b0;

	 if(((SQUARE_X_Pos == SQUARE_X_Max) || game[SQUARE_Y_Pos][SQUARE_X_Pos - 180] == 1'b1) && ~s_enable) // probe one right
	 		at_edgeR = 1'b1;
	 else
	 	  at_edgeR = 1'b0;

		if(SQUARE_Y_Pos == SQUARE_Y_Max || game[SQUARE_Y_Pos + 20][SQUARE_X_Pos - 200] == 1'b1 )
<<<<<<< HEAD
			at_bottom = 1'b1;		 
=======
			at_bottom = 1'b1;
>>>>>>> 9b1c6dc1725e0fc6ff297331fa33a15b8a3f133f
		else
			at_bottom = 1'b0;
		end
		logic [9:0] SQUARE_X_Pos1, SQUARE_Y_Pos1;
		always_comb
		 begin 
			unique case(shape)
				1: begin // square
					SQUARE_X_Pos1 = SQUARE_X_Pos;
					SQUARE_Y_Pos1 = SQUARE_Y_Pos;
				end
				2: begin // rod
					if(sq == 0) begin
					SQUARE_X_Pos1 = SQUARE_X_Pos - 20;
					SQUARE_Y_Pos1 = SQUARE_Y_Pos + 20;
					end
					else if(sq == 1) begin
					SQUARE_X_Pos1 = SQUARE_X_Pos;
					SQUARE_Y_Pos1 = SQUARE_Y_Pos;
					end
					else if (sq == 2) begin
					SQUARE_X_Pos1 = SQUARE_X_Pos + 20;
					SQUARE_Y_Pos1 = SQUARE_Y_Pos - 20;
					end else begin
					SQUARE_X_Pos1 = SQUARE_X_Pos + 40;
					SQUARE_Y_Pos1 = SQUARE_Y_Pos - 40;
					 end
					end
				3: begin // right S
				if(sq == 0) begin
				SQUARE_Y_Pos1 = SQUARE_Y_Pos - 20;
				SQUARE_X_Pos1 = SQUARE_X_Pos - 20;
				end
				else if(sq == 1) begin
					SQUARE_X_Pos1 = SQUARE_X_Pos;
					SQUARE_Y_Pos1 = SQUARE_Y_Pos;
				end
				else if (sq == 2) begin
				SQUARE_X_Pos1 = SQUARE_X_Pos + 20;
				SQUARE_Y_Pos1 = SQUARE_Y_Pos - 20;
				end else begin
				SQUARE_X_Pos1 = SQUARE_X_Pos + 40;
			   SQUARE_Y_Pos1 = SQUARE_Y_Pos;
				 end

					end
				4: begin // left S
				if(sq == 0) begin
				SQUARE_Y_Pos1 = SQUARE_Y_Pos - 20;
				SQUARE_X_Pos1 = SQUARE_X_Pos + 20;
				end
				else if(sq == 1) begin
					SQUARE_X_Pos1 = SQUARE_X_Pos;
					SQUARE_Y_Pos1 = SQUARE_Y_Pos;
				end
				else if (sq == 2) begin
				SQUARE_X_Pos1 = SQUARE_X_Pos - 20;
				SQUARE_Y_Pos1 = SQUARE_Y_Pos - 20;
				end else begin
				SQUARE_X_Pos1 = SQUARE_X_Pos - 40;
				SQUARE_Y_Pos1 = SQUARE_Y_Pos;
				 end
					end
				5: begin // right L
				if(sq == 0) begin
				SQUARE_Y_Pos1 = SQUARE_Y_Pos + 20;
				SQUARE_X_Pos1 = SQUARE_X_Pos + 20;
				end
				else if(sq == 1) begin
					SQUARE_X_Pos1 = SQUARE_X_Pos;
					SQUARE_Y_Pos1 = SQUARE_Y_Pos;
				end
				else if (sq == 2) begin
				SQUARE_X_Pos1 = SQUARE_X_Pos - 20;
				SQUARE_Y_Pos1 = SQUARE_Y_Pos - 20;
				end else begin
				SQUARE_X_Pos1 = SQUARE_X_Pos - 40;
				SQUARE_Y_Pos1 = SQUARE_Y_Pos;
				 end
					end
				6: begin // left L
				if(sq == 0) begin
				SQUARE_Y_Pos1 = SQUARE_Y_Pos - 20;
				SQUARE_X_Pos1 = SQUARE_X_Pos - 20;
				end
				else if(sq == 1) begin
					SQUARE_X_Pos1 = SQUARE_X_Pos;
					SQUARE_Y_Pos1 = SQUARE_Y_Pos;
				end
				else if (sq == 2) begin
				SQUARE_X_Pos1 = SQUARE_X_Pos + 20;
				SQUARE_Y_Pos1 = SQUARE_Y_Pos - 20;
				end else begin
				SQUARE_X_Pos1 = SQUARE_X_Pos + 40;
				SQUARE_Y_Pos1 = SQUARE_Y_Pos;
				 end
					end
				7: begin // t
				if(sq == 0) begin
				SQUARE_Y_Pos1 = SQUARE_Y_Pos - 20;
				SQUARE_X_Pos1 = SQUARE_X_Pos + 20;
				end
				else if(sq == 1) begin
					SQUARE_X_Pos1 = SQUARE_X_Pos;
					SQUARE_Y_Pos1 = SQUARE_Y_Pos;
				end
				else if (sq == 2) begin
				SQUARE_X_Pos1 = SQUARE_X_Pos - 20;
				SQUARE_Y_Pos1 = SQUARE_Y_Pos + 20;
				end else begin
				SQUARE_X_Pos1 = SQUARE_X_Pos + 20;
				SQUARE_Y_Pos1 = SQUARE_Y_Pos + 20;
				 end
				end
				default : begin
					SQUARE_X_Pos1 = SQUARE_X_Pos;
					SQUARE_Y_Pos1 = SQUARE_Y_Pos;
				end
			endcase
		end
always_comb begin
	if(!rotate_enable)
     SQUAREX = SQUARE_X_Pos;
	else	
	  SQUAREX = SQUARE_X_Pos1;
	
	if(!rotate_enable)
     SQUAREY = SQUARE_Y_Pos;
	else
	  SQUAREY = SQUARE_Y_Pos1;
end

endmodule
