/*---------------------------------------------------------------------------
  --      aes_controller.sv                                                --
  --      Christine Chen                                                   --
  --      10/29/2013                                                       --
  --                                                                       --
  --      For use with ECE 298 Experiment 9                                --
  --      UIUC ECE Department                                              --
  ---------------------------------------------------------------------------*/
// AES controller module

module aes_controller(
				input			 		clk,
				input					reset_n,
				input	[127:0]			msg_en,
				input	[127:0]			key,
				output logic [127:0]			msg_de,
				input					io_ready,
				output logic  aes_ready,
				output logic  [7:0] cur_state
			    );
//assign cur_state = state;
enum logic [7:0] {WAIT, COMPUTE, READY, KEY_EXPANSION, AR0, AR1, AR2, AR3, AR4, AR5, AR6, AR7, AR8, AR9, AR10, ISR0, ISR1, ISR2, ISR3, ISR4, ISR5, ISR6, ISR7, ISR8, ISR9, ISB0, ISB1, ISB2, ISB3, ISB4, ISB5, ISB6, ISB7, ISB8, ISB9, IMC0, IMC1, IMC2, IMC3, IMC4, IMC5, IMC6, IMC7, IMC8, wait0, wait1, wait2, wait3, wait4, wait5, wait6, wait7, wait8, wait9 } state, next_state;
assign cur_state = state;
logic [15:0] counter;
logic [2:0] select; // mux select;
logic [3:0] progress; // progress for add round key
logic LD_PL,LD_KS; // load signals for registers
logic tri_state;
logic reset;
logic momspaghetti;
//assign aes_ready = momspaghetti
assign reset = ~reset_n;
AES aes0(.Clk(clk),.Reset(reset),.Plaintext(msg_en),.Cipherkey(key),.LD_PL(LD_PL),.LD_KS(LD_KS),.Run(io_ready),.tri_state(tri_state),
.select(select),.Progress(progress),.Ciphertext(msg_de),.Ready(momspaghetti));



always_ff @ (posedge clk, negedge reset_n) begin
	if (reset_n == 1'b0) begin
		state <= WAIT;
		counter <= 16'd0;

	end else begin
		state <= next_state;
		if (state == COMPUTE )
			counter <= counter + 1'b1;
	end
end

always_comb begin
	next_state = state;
	case (state)
		WAIT: begin
			if (io_ready)
				next_state = COMPUTE;
		end

		COMPUTE: begin
			//if (counter == 16'd65535)
				next_state <= KEY_EXPANSION;
		end
///////////key expansion ///////////////////
		KEY_EXPANSION: begin
			//if (counter == 16'd65535)
				next_state = AR0;
		end
/////////////initial////////////////////
		AR0 : begin // first add round key
			next_state = ISR0;
		end
///////////////////////////////////////////////////////
/****         loop begins here  1          *******/
///////////////////////////////////////////////////////
		ISR0 : begin
			next_state = ISB0;
		end

		ISB0 : begin
			next_state = wait0;
		end
    wait0 : begin
      next_state = AR1;
    end
		AR1 : begin
			next_state = IMC0;
		end
		IMC0 : begin
			next_state = ISR1;
		end
  /////////////////////////2////////////////////////////////
		ISR1 : begin
			next_state = ISB1;
		end

		ISB1 : begin
			next_state = wait1;
		end
    wait1 : begin
      next_state = AR2;
    end
		AR2 : begin
			next_state = IMC1;
		end
		IMC1 : begin
			next_state = ISR2;
		end
//////////////////////////3/////////////////////////////////
		ISR2 : begin
			next_state = ISB2;
		end

		ISB2 : begin
			next_state = wait2;
		end
    wait2 : begin
      next_state = AR3;
    end
		AR3 : begin
			next_state = IMC2;
		end
		IMC2 : begin
			next_state = ISR3;
		end
/////////////////////////4/////////////////////////////////
		ISR3 : begin
			next_state = ISB3;
		end

		ISB3 : begin
			next_state = wait3;
		end
    wait3 : begin
      next_state = AR4;
    end
		AR4 : begin
			next_state = IMC3;
		end
		IMC3 : begin
			next_state = ISR4;
		end
////////////////////////5//////////////////////////////////
				ISR4 : begin
			next_state = ISB4;
		end

		ISB4 : begin
			next_state = wait4;
		end
    wait4 : begin
      next_state = AR5;
    end
		AR5 : begin
			next_state = IMC4;
		end
		IMC4 : begin
			next_state = ISR5;
		end
////////////////////////6//////////////////////////////////


    ISR5 : begin
      next_state = ISB5;
    end

    ISB5 : begin
      next_state = wait5;
    end
    wait5 : begin
      next_state = AR6;
    end
    AR6 : begin
      next_state = IMC5;
    end
    IMC5 : begin
      next_state = ISR6;
    end

/////////////////////7/////////////////////////////////////

		ISR6 : begin
			next_state = ISB6;
		end

		ISB6 : begin
			next_state = wait6;
		end
    wait6 : begin
      next_state = AR7;
    end
		AR7 : begin
			next_state = IMC6;
		end
		IMC6 : begin
			next_state = ISR7;
		end
///////////////////////8////////////////////////////////
				ISR7 : begin
			next_state = ISB7;
		end

		ISB7 : begin
			next_state = wait7;
		end
    wait7 : begin
      next_state = AR8;
    end
		AR8 : begin
			next_state = IMC7;
		end
		IMC7 : begin
			next_state = ISR8;
		end
/////////////////////9///////////////////////////////////

		ISR8 : begin
			next_state = ISB8;
		end

		ISB8 : begin
			next_state = wait8;
		end
    wait8 : begin
      next_state = AR9;
    end
		AR9 : begin
			next_state = IMC8;
		end
		IMC8 : begin
			next_state = ISR9;
		end
//////////////////10///////////////////////////////////
		ISR9 : begin
			next_state = ISB9;
		end

		ISB9 : begin
			next_state = wait9;
		end
    wait9 : begin
      next_state = AR10;
    end
		AR10 : begin
			next_state = READY;
		end
		READY: begin
    if(io_ready == 1'b0)
      next_state = WAIT;
		end
	endcase
end

always_comb begin
  aes_ready = 1'b0;
  LD_KS = 1'b0;
  LD_PL = 1'b0;
  select = 3'b101; // 5 so high z
  progress = 4'b0000; // don't care if not loading
  tri_state = 1'b0;
	case (state)
	
	default : 
	begin
	end
	WAIT: begin
			aes_ready = 1'b0;
		end

		COMPUTE: begin
		end

		KEY_EXPANSION: begin
      LD_KS = 1'b1;
      tri_state = 1'b1;
      LD_PL = 1'b1; // ld in initial plaintext
      select = 3'b100; // pass in initial plaintext
		end
    AR0: begin
      progress = 4'b0000; // one
      select = 3'b000; // select add round key to fill reg
      LD_PL = 1'b1;
    end
    AR1: begin
    progress = 4'b0001;
    select = 3'b000; // select add round key to fill reg
    LD_PL = 1'b1;
    end
    AR2: begin
    progress = 4'b0010;
    select = 3'b000; // select add round key to fill reg
    LD_PL = 1'b1;
    end
    AR3: begin
    progress = 4'b0011;
    select = 3'b000; // select add round key to fill reg
    LD_PL = 1'b1;
    end
    AR4: begin
    progress = 4'b0100;
    select = 3'b000; // select add round key to fill reg
    LD_PL = 1'b1;
    end
    AR5: begin
    progress = 4'b0101;
    select = 3'b000; // select add round key to fill reg
    LD_PL = 1'b1;
    end
    AR6: begin
    progress = 4'b0110;
    select = 3'b000; // select add round key to fill reg
    LD_PL = 1'b1;
    end
    AR7: begin
    progress = 4'b0111;
    select = 3'b000; // select add round key to fill reg
    LD_PL = 1'b1;
    end
    AR8: begin
    progress = 4'b1000;
    select = 3'b000; // select add round key to fill reg
    LD_PL = 1'b1;
    end
    AR9: begin
    progress = 4'b1001;
    select = 3'b000; // select add round key to fill reg
    LD_PL = 1'b1;
    end
    AR10: begin
    progress = 4'b1010;
    select = 3'b000; // select add round key to fill reg
    LD_PL = 1'b1; // ld register with new val
    end

    ISR0: begin
    select = 3'b001;
    LD_PL = 1'b1;
    end
    ISR1: begin
    select = 3'b001;
    LD_PL = 1'b1;
    end
    ISR2: begin
    select = 3'b001;
    LD_PL = 1'b1;
    end
    ISR3: begin
    select = 3'b001;
    LD_PL = 1'b1;
    end
    ISR4: begin
    select = 3'b001;
    LD_PL = 1'b1;
    end
    ISR5: begin
    select = 3'b001;
    LD_PL = 1'b1;
    end
    ISR6: begin
    select = 3'b001;
    LD_PL = 1'b1;
    end
    ISR7: begin
    select = 3'b001;
    LD_PL = 1'b1;
    end
    ISR8: begin
    select = 3'b001;
    LD_PL = 1'b1;
    end
    ISR9: begin
    select = 3'b001;
    LD_PL = 1'b1;
    end

    ISB0: begin
    select = 3'b010;
    end
    wait0: begin
    select = 3'b010;
    LD_PL = 1'b1;
    end
    ISB1: begin
    select = 3'b010;
	 //LD_PL = 1'b1;
    end
    wait1: begin
    select = 3'b010;
    LD_PL = 1'b1;
    end
    ISB2: begin
    select = 3'b010;
    //LD_PL = 1'b1;
    end
    wait2: begin
    select = 3'b010;
    LD_PL = 1'b1;
    end
    ISB3: begin
    select = 3'b010;
    //LD_PL = 1'b1;
    end
    wait3: begin
    select = 3'b010;
    LD_PL = 1'b1;
    end
    ISB4: begin
    select = 3'b010;
    //LD_PL = 1'b1;
    end
    wait4: begin
    select = 3'b010;
    LD_PL = 1'b1;
    end
    ISB5: begin
    select = 3'b010;
    //LD_PL = 1'b1;
    end
    wait5: begin
    select = 3'b010;
    LD_PL = 1'b1;
    end
    ISB6: begin
    select = 3'b010;
    //LD_PL = 1'b1;
    end
    wait6: begin
    select = 3'b010;
    LD_PL = 1'b1;
    end
    ISB7: begin
    select = 3'b010;
    //LD_PL = 1'b1;
    end
    wait7: begin
    select = 3'b010;
    LD_PL = 1'b1;
    end
    ISB8: begin
    select = 3'b010;
    //LD_PL = 1'b1;
    end
    wait8: begin
    select = 3'b010;
    LD_PL = 1'b1;
    end
    ISB9: begin
    select = 3'b010;
    //LD_PL = 1'b1;
    end
    wait9: begin
    select = 3'b010;
    LD_PL = 1'b1;
    end

    IMC0: begin
    select = 3'b011;
    LD_PL = 1'b1;
    end
    IMC1: begin
    select = 3'b011;
    LD_PL = 1'b1;
    end
    IMC2: begin
    select = 3'b011;
    LD_PL = 1'b1;
    end
    IMC3: begin
    select = 3'b011;
    LD_PL = 1'b1;
    end
    IMC4: begin
    select = 3'b011;
    LD_PL = 1'b1;
    end
    IMC5: begin
    select = 3'b011;
    LD_PL = 1'b1;
    end
    IMC6: begin
    select = 3'b011;
    LD_PL = 1'b1;
    end
    IMC7: begin
    select = 3'b011;
    LD_PL = 1'b1;
    end
    IMC8: begin
    select = 3'b011;
    LD_PL = 1'b1;
    end
	READY: begin
		//if(momspaghetti)
		 aes_ready = 1'b1;
	end
		
	endcase
end

endmodule
