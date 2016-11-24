module keycode_state_machine( input Clk, input Reset,
							 input [15:0] keycode,
							 output logic step_enable_a,
							 output logic step_enable_s,
							 output logic step_enable_d
						);
						enum logic [3:0] {WAIT, press_a, assign_a, press_d, assign_d, press_s, assign_s} State, next_state;

						always_ff @ (posedge Reset or posedge Clk )
						begin : Assign_Next_State
							if (Reset)
								State <= WAIT;
							else
								State <= next_state;
					   end
						always_comb begin
						unique case(State)
							WAIT : begin
								if(keycode == 16'd7) // d
									next_state <=  press_d;
								else if(keycode == 16'd22) // s
									next_state <= press_s;
								else if(keycode == 16'd4) // a
									next_state <= press_a;
								else
									next_state <= WAIT;
							end
						  press_d : begin
								if(keycode == 16'd7)
									next_state <= press_d;
								else
									next_state <= assign_d;
						  end
						 assign_d : begin
								next_state <= WAIT;
						 end

						 press_s : begin
								if(keycode == 16'd22)
									next_state <= press_s;
								else
									next_state <= assign_s;
						  end
						 assign_s : begin
								next_state <= WAIT;
						 end

						 press_a : begin
								if(keycode == 16'd4)
									next_state <= press_a;
								else
									next_state <= assign_a;
						  end
						 assign_a : begin
								next_state <= WAIT;
						 end
						 default : begin
								next_state <= WAIT;
						 end
							endcase
						end

						always_comb
						begin

						step_enable_a = 1'b0;
						step_enable_s = 1'b0;
						step_enable_d = 1'b0;

						case(State)
						WAIT:
							begin
							end
						press_a:
							begin
							end
						press_d:
							begin
							end
						press_s:
							begin
							end

						assign_a:
							begin
								step_enable_a = 1'b1;
							end

						assign_d:
							begin
								step_enable_d = 1'b1;
							end

						assign_s :
							begin
								step_enable_s = 1'b1;
							end
						default :
							begin
							end
						endcase
						end
endmodule
