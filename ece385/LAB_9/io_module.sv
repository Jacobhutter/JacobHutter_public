/*---------------------------------------------------------------------------
  --      io_module.sv                                                     --
  --      Christine Chen                                                   --
  --      10/23/2013                                                       --
  --                                                                       --
  --      For use with ECE 298 Experiment 9                                --
  --      UIUC ECE Department                                              --
  ---------------------------------------------------------------------------*/
// Stores 8-bit data transmitted from Nios II into 128-bit registers for encrypted message and AES key


module io_module (		input			 		clk,
						input			 		reset_n,
						output logic [1:0]  	to_sw_sig,
						output logic [31:0]  	to_sw_port,
						input [1:0]  			to_hw_sig,
						input [31:0]  			to_hw_port,
						output logic [127:0] 	msg_en,
						output logic [127:0] 	key,
						input [127:0] 			msg_de,
						output logic					io_ready,
						input					aes_ready
						);

		enum logic [6:0] {	RESET, WAIT,
							READ_MSG_0, READ_MSG_1, READ_MSG_2, READ_MSG_3, READ_MSG_4, READ_MSG_5, READ_MSG_6, READ_MSG_7,
							READ_MSG_8, READ_MSG_9, READ_MSG_10, READ_MSG_11, READ_MSG_12, READ_MSG_13, READ_MSG_14, READ_MSG_15,
							ACK_MSG_0, ACK_MSG_1, ACK_MSG_2, ACK_MSG_3, ACK_MSG_4, ACK_MSG_5, ACK_MSG_6, ACK_MSG_7,
							ACK_MSG_8, ACK_MSG_9, ACK_MSG_10, ACK_MSG_11, ACK_MSG_12, ACK_MSG_13, ACK_MSG_14, ACK_MSG_15,
							READ_KEY_0, READ_KEY_1, READ_KEY_2, READ_KEY_3, READ_KEY_4, READ_KEY_5, READ_KEY_6, READ_KEY_7,
							READ_KEY_8, READ_KEY_9, READ_KEY_10, READ_KEY_11, READ_KEY_12, READ_KEY_13, READ_KEY_14, READ_KEY_15,
							ACK_KEY_0, ACK_KEY_1, ACK_KEY_2, ACK_KEY_3, ACK_KEY_4, ACK_KEY_5, ACK_KEY_6, ACK_KEY_7,
							ACK_KEY_8, ACK_KEY_9, ACK_KEY_10, ACK_KEY_11, ACK_KEY_12, ACK_KEY_13, ACK_KEY_14, ACK_KEY_15,
							SEND_TO_AES, GET_FROM_AES,
							SEND_BACK_0, SEND_BACK_1, SEND_BACK_2, SEND_BACK_3, SEND_BACK_4, SEND_BACK_5, SEND_BACK_6, SEND_BACK_7,
							SEND_BACK_8, SEND_BACK_9, SEND_BACK_10, SEND_BACK_11, SEND_BACK_12, SEND_BACK_13, SEND_BACK_14, SEND_BACK_15,
							GOT_ACK_0, GOT_ACK_1, GOT_ACK_2, GOT_ACK_3, GOT_ACK_4, GOT_ACK_5, GOT_ACK_6, GOT_ACK_7,
							GOT_ACK_8, GOT_ACK_9, GOT_ACK_10, GOT_ACK_11, GOT_ACK_12, GOT_ACK_13, GOT_ACK_14, GOT_ACK_15}
							state, next_state;

		always_ff @ (posedge clk, negedge reset_n) begin
			if (reset_n == 1'b0) begin
				state <= RESET;
				msg_en <= 127'd0;
				key <= 127'd0;
			end else begin
				state <= next_state;
				to_sw_port = 8'd0;
				case (state)

          SEND_BACK_0: begin
            to_sw_port[31:0] <= msg_de[127:96];
          end

          SEND_BACK_1: begin
            to_sw_port[31:0] <= msg_de[95:64];
          end

          SEND_BACK_2: begin
            to_sw_port[31:0] <= msg_de[63:32];
          end

          SEND_BACK_3: begin
            to_sw_port[31:0] <= msg_de[31:0];
          end

			READ_MSG_0: begin
				msg_en[127:96] <= to_hw_port[31:0];
			end
			READ_MSG_1: begin
				msg_en[95:64] <= to_hw_port[31:0];
			end
			READ_MSG_2: begin
				msg_en[63:32] <= to_hw_port[31:0];
			end
			READ_MSG_3: begin
				msg_en[31:0] <= to_hw_port[31:0];
	      end
         READ_KEY_0: begin
  				key[127:96] <= to_hw_port[31:0];
  			end
  			READ_KEY_1: begin
  				key[95:64] <= to_hw_port[31:0];
  			end
  			READ_KEY_2: begin
  				key[63:32] <= to_hw_port[31:0];
  		   end
  			READ_KEY_3: begin
  				key[31:0] <= to_hw_port[31:0];
			end

				endcase
			end
		end

		always_comb begin
			next_state = state;
			unique case (state)
				RESET: begin
					next_state = WAIT;
				end

				WAIT: begin
					if (to_hw_sig == 2'd1)
						next_state = READ_MSG_0;
					else if (to_hw_sig == 2'd2)
						next_state = READ_KEY_0;
					else if (to_hw_sig == 2'd3)
						next_state = SEND_TO_AES;
				end
		  READ_KEY_0: begin
        if (to_hw_sig == 2'd2)
          next_state = ACK_KEY_0;
        end
        READ_KEY_1: begin
        if (to_hw_sig == 2'd2)
          next_state = ACK_KEY_1;
        end
        READ_KEY_2: begin
        if (to_hw_sig == 2'd2)
          next_state = ACK_KEY_2;
        end
        READ_KEY_3: begin
        if (to_hw_sig == 2'd2)
          next_state = ACK_KEY_3;
        end
        ACK_KEY_0: begin
        if (to_hw_sig == 2'd1)
          next_state = READ_KEY_1;
        end
        ACK_KEY_1: begin
        if (to_hw_sig == 2'd1)
          next_state = READ_KEY_2;
        end
        ACK_KEY_2: begin
        if (to_hw_sig == 2'd1)
          next_state = READ_KEY_3;
        end
        ACK_KEY_3: begin
		  if (to_hw_sig == 2'd1)
          next_state = WAIT;
        end

				READ_MSG_0: begin
					if (to_hw_sig == 2'd2)
						next_state = ACK_MSG_0;
				end

				READ_MSG_1: begin
					if (to_hw_sig == 2'd2)
						next_state = ACK_MSG_1;
				end

				ACK_MSG_0: begin
					if (to_hw_sig == 2'd1)
						next_state = READ_MSG_1;
				end

				ACK_MSG_1: begin
					if (to_hw_sig == 2'd1)
						next_state = READ_MSG_2;
				end

				READ_MSG_2: begin
					if (to_hw_sig == 2'd2)
						next_state = ACK_MSG_2;
				end

				READ_MSG_3: begin
					if (to_hw_sig == 2'd2)
						next_state = ACK_MSG_3;
				end

				ACK_MSG_2: begin
					if (to_hw_sig == 2'd1)
						next_state = READ_MSG_3;
				end

				ACK_MSG_3: begin
					if (to_hw_sig == 2'd1)
						next_state = WAIT;
				end

		SEND_TO_AES: begin
        if(aes_ready == 1'b1)
          next_state = GET_FROM_AES;
				end
        GET_FROM_AES: begin
          if(to_hw_sig == 1'b1)
            next_state = SEND_BACK_0;
        end

        SEND_BACK_0: begin
        if (to_hw_sig == 2'd2)
          next_state = GOT_ACK_0;
        end
        SEND_BACK_1: begin
        if (to_hw_sig == 2'd2)
          next_state = GOT_ACK_1;
        end
        SEND_BACK_2: begin
        if (to_hw_sig == 2'd2)
          next_state = GOT_ACK_2;
        end
        SEND_BACK_3: begin
        if (to_hw_sig == 2'd2)
          next_state = GOT_ACK_3;
        end

        GOT_ACK_0: begin
        if (to_hw_sig == 2'd1)
          next_state = SEND_BACK_1;
        end
        GOT_ACK_1: begin
        if (to_hw_sig == 2'd1)
          next_state = SEND_BACK_2;
        end
        GOT_ACK_2: begin
        if (to_hw_sig == 2'd1)
          next_state = SEND_BACK_3;
        end
        GOT_ACK_3: begin
          next_state = WAIT;
        end

				// TODO
			endcase
		end

		always_comb begin
			
			to_sw_sig = 2'd0;
			io_ready = 1'b0;
			unique case (state)
				RESET: begin
					to_sw_sig = 2'd3;
				end

				WAIT: begin
					to_sw_sig = 2'd0;
				end

				READ_MSG_0: begin
					to_sw_sig = 2'd1;
				end
				READ_MSG_1: begin
					to_sw_sig = 2'd1;
				end
				READ_MSG_2: begin
					to_sw_sig = 2'd1;
				end
				READ_MSG_3: begin
					to_sw_sig = 2'd1;
				end

        READ_KEY_0: begin
					to_sw_sig = 2'd1;
				end
        READ_KEY_1: begin
					to_sw_sig = 2'd1;
				end
        READ_KEY_2: begin
					to_sw_sig = 2'd1;
				end
        READ_KEY_3: begin
					to_sw_sig = 2'd1;
				end

        ACK_KEY_0: begin
          to_sw_sig = 2'd0;
        end
        ACK_KEY_1: begin
          to_sw_sig = 2'd0;
        end
        ACK_KEY_2: begin
          to_sw_sig = 2'd0;
        end
        ACK_KEY_3: begin
          to_sw_sig = 2'd0;
        end

				ACK_MSG_0: begin
					to_sw_sig = 2'd0;
				end
				ACK_MSG_1: begin
					to_sw_sig = 2'd0;
				end
				ACK_MSG_2: begin
					to_sw_sig = 2'd0;
				end
				ACK_MSG_3: begin
					to_sw_sig = 2'd0;
				end


        SEND_BACK_0: begin
        to_sw_sig = 2'd1;
        end
        SEND_BACK_1: begin
        to_sw_sig = 2'd1;
        end
        SEND_BACK_2: begin
        to_sw_sig = 2'd1;
        end
        SEND_BACK_3: begin
        to_sw_sig = 2'd1;
        end

        GOT_ACK_0: begin
        to_sw_sig = 2'd0;
        end
        GOT_ACK_1: begin
        to_sw_sig = 2'd0;
        end
        GOT_ACK_2: begin
        to_sw_sig = 2'd0;
        end
        GOT_ACK_3: begin
        to_sw_sig = 2'd0;
        end

				SEND_TO_AES: begin
					to_sw_sig = 2'd0;
					io_ready = 1'b1;
					to_sw_sig = 2'd2;
				end

				GET_FROM_AES: begin
					to_sw_sig = 2'd2;
				end

				// TODO
			endcase
		end

endmodule
