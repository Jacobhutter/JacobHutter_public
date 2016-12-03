
module  square (input Reset, Clk, coord, edge_disableL, edge_disableR,
					input a_enable,s_enable,d_enable,
					input [9:0] center_x, center_y,
					output logic [9:0]  SQUAREX, SQUAREY, SQUARE_Size_x, SQUARE_Size_y,
					output logic at_bottom, at_edgeL, at_edgeR);

    logic [9:0] SQUARE_X_Pos, SQUARE_Y_Pos;
    parameter [9:0] SQUARE_X_Min=200;       // Leftmost point on the X axis
    parameter [9:0] SQUARE_X_Max=380;     // Rightmost point on the X axis
    parameter [9:0] SQUARE_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] SQUARE_Y_Max=380;     // Bottommost point on the Y axis


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
				if(a_enable == 1'b1 && edge_disableL != 1'b1)
				begin
					 SQUARE_X_Pos <= SQUARE_X_Pos - SQUARE_X_Step;
				end
				if(s_enable == 1'b1)
				begin
					 SQUARE_Y_Pos <= SQUARE_Y_Pos + SQUARE_Y_Step;
				end
				if(d_enable == 1'b1 && edge_disableR != 1'b1)
				begin
					 SQUARE_X_Pos <= SQUARE_X_Pos + SQUARE_X_Step;
				end


				 if ((SQUARE_Y_Pos) >= SQUARE_Y_Max )  // SQUARE is at the bottom edge
				 begin
				 		SQUARE_Y_Pos <= SQUARE_Y_Max;

				 end
				 if( (SQUARE_X_Pos) >= (SQUARE_X_Max) & ~s_enable) // SQUARE is at right edge
				 begin
						SQUARE_X_Pos <= SQUARE_X_Max;
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
