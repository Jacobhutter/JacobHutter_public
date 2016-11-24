module shape_generator(input Clk, Reset, at_bottom, at_bottom2, at_bottom3, at_bottom4,
                       output logic [9:0] new_square_1x, output logic [9:0] new_square_1y,
                       output logic [9:0] new_square_2x, output logic [9:0] new_square_2y,
                       output logic [9:0] new_square_3x, output logic [9:0] new_square_3y,
                       output logic [9:0] new_square_4x, output logic [9:0] new_square_4y,
							  output logic  coord
							  );



				enum logic [3:0] {square, square_wait} State, next_state;

						always_ff @ (posedge Reset or posedge Clk )
						begin : Assign_Next_State
							if (Reset)
								State <= square;
							else
								State <= next_state;
					   end
						always_comb begin
						next_state <= State;
						unique case(State)
							square : begin
							if(at_bottom != 1'b1 && at_bottom2 != 1'b1 && at_bottom3 != 1'b1 && at_bottom4 != 1'b1)
								next_state <= square_wait;
							end
							
							square_wait : begin
							if(at_bottom == 1'b1 || at_bottom2 == 1'b1 || at_bottom3 == 1'b1 || at_bottom4 == 1'b1)
								next_state <= square;
							end
						 

						 default : begin
								next_state <= square;
						 end
						 
					endcase
				end

						always_comb
						begin

						new_square_1x = 10'd0;
						new_square_1y = 10'd0;
                  new_square_2x = 10'd0;
						new_square_2y = 10'd0;
                  new_square_3x = 10'd0;
						new_square_3y = 10'd0;
                  new_square_4x = 10'd0;
						new_square_4y = 10'd0;
					   coord = 1'b0;

						case(State)
						square : begin
						new_square_1x = 10'd300;
						new_square_2x = 10'd320;
						new_square_3x = 10'd300;
						new_square_3y = 10'd20;
						new_square_4x = 10'd320;
						new_square_4y = 10'd20;
						coord = 1'b1;
						end
						square_wait : begin
					   //new_square_1x = 10'd300;
						end
					  endcase
					end

		endmodule
