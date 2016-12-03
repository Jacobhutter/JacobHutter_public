module shape_generator(input Clk, Reset, at_bottom, at_bottom2, at_bottom3, at_bottom4,
                       output logic [9:0] new_square_1x, output logic [9:0] new_square_1y,
                       output logic [9:0] new_square_2x, output logic [9:0] new_square_2y,
                       output logic [9:0] new_square_3x, output logic [9:0] new_square_3y,
                       output logic [9:0] new_square_4x, output logic [9:0] new_square_4y,
							  output logic  coord
							  );



				enum logic [3:0] {square, square_wait, rod, rod_wait, l_s, l_s_wait, r_s, r_s_wait, r_l, r_l_wait, l_l, l_l_wait, t, t_wait} State, next_state;

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
								next_state <= rod;
							end

              rod : begin
              if(at_bottom != 1'b1 && at_bottom2 != 1'b1 && at_bottom3 != 1'b1 && at_bottom4 != 1'b1)
								next_state <= rod_wait;

              end
              rod_wait : begin
              if(at_bottom == 1'b1 || at_bottom2 == 1'b1 || at_bottom3 == 1'b1 || at_bottom4 == 1'b1)
								next_state <= r_s;
              end
              r_s : begin
              if(at_bottom != 1'b1 && at_bottom2 != 1'b1 && at_bottom3 != 1'b1 && at_bottom4 != 1'b1)
                next_state <= r_s_wait;
              end
              r_s_wait : begin
              if(at_bottom == 1'b1 || at_bottom2 == 1'b1 || at_bottom3 == 1'b1 || at_bottom4 == 1'b1)
                next_state <= l_s;
              end

              l_s : begin
              if(at_bottom != 1'b1 && at_bottom2 != 1'b1 && at_bottom3 != 1'b1 && at_bottom4 != 1'b1)
								next_state <= l_s_wait;
              end

              l_s_wait : begin
              if(at_bottom == 1'b1 || at_bottom2 == 1'b1 || at_bottom3 == 1'b1 || at_bottom4 == 1'b1)
								next_state <= r_l;
              end

              r_l : begin
              if(at_bottom != 1'b1 && at_bottom2 != 1'b1 && at_bottom3 != 1'b1 && at_bottom4 != 1'b1)
                next_state <= r_l_wait;
              end

              r_l_wait : begin
              if(at_bottom == 1'b1 || at_bottom2 == 1'b1 || at_bottom3 == 1'b1 || at_bottom4 == 1'b1)
                next_state <= l_l;
              end

              l_l : begin
              if(at_bottom != 1'b1 && at_bottom2 != 1'b1 && at_bottom3 != 1'b1 && at_bottom4 != 1'b1)
                next_state <= l_l_wait;
              end

              l_l_wait : begin
              if(at_bottom == 1'b1 || at_bottom2 == 1'b1 || at_bottom3 == 1'b1 || at_bottom4 == 1'b1)
                next_state <= t;
              end

              t : begin
              if(at_bottom != 1'b1 && at_bottom2 != 1'b1 && at_bottom3 != 1'b1 && at_bottom4 != 1'b1)
                next_state <= t_wait;
              end
              t_wait : begin
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
						end

            rod : begin
            new_square_1x = 10'd300;
            new_square_1y = 10'd0;
            new_square_2x = 10'd300;
            new_square_2y = 10'd20;
            new_square_3x = 10'd300;
            new_square_3y = 10'd40;
            new_square_4x = 10'd300;
            new_square_4y = 10'd60;
            coord = 1'b1;
            end
            rod_wait : begin
            end


            r_s : begin
            new_square_1x = 10'd320;
            new_square_1y = 10'd0;
            new_square_2x = 10'd300;
            new_square_2y = 10'd0;
            new_square_3x = 10'd300;
            new_square_3y = 10'd20;
            new_square_4x = 10'd280;
            new_square_4y = 10'd20;
            coord = 1'b1;
            end
            r_s_wait : begin
            end

            l_s : begin
            new_square_1x = 10'd280;
            new_square_1y = 10'd0;
            new_square_2x = 10'd300;
            new_square_2y = 10'd0;
            new_square_3x = 10'd300;
            new_square_3y = 10'd20;
            new_square_4x = 10'd320;
            new_square_4y = 10'd20;
            coord = 1'b1;
            end
            l_s_wait : begin
            end

            r_l : begin
            new_square_1x = 10'd300;
            new_square_1y = 10'd0;
            new_square_2x = 10'd300;
            new_square_2y = 10'd20;
            new_square_3x = 10'd300;
            new_square_3y = 10'd40;
            new_square_4x = 10'd320;
            new_square_4y = 10'd40;
            coord = 1'b1;
            end
            r_l_wait :begin
            end

            l_l : begin
            new_square_1x = 10'd300;
            new_square_1y = 10'd0;
            new_square_2x = 10'd300;
            new_square_2y = 10'd20;
            new_square_3x = 10'd300;
            new_square_3y = 10'd40;
            new_square_4x = 10'd280;
            new_square_4y = 10'd40;
            coord = 1'b1;
            end
            l_l_wait : begin
            end

            t : begin
            new_square_1x = 10'd280;
            new_square_1y = 10'd0;
            new_square_2x = 10'd300;
            new_square_2y = 10'd0;
            new_square_3x = 10'd320;
            new_square_3y = 10'd0;
            new_square_4x = 10'd300;
            new_square_4y = 10'd20;
            coord = 1'b1;
            end
            t_wait : begin
            end

            default : begin
            end
					  endcase
					end

		endmodule
