module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1
timeprecision 1ns;

// These signals are internal because the processor will be
// instantiated as a submodule in testbench.
logic Clk = 0;
logic Reset, at_bottom, at_bottom3, at_bottom2, at_bottom4;
logic [9:0] new_square_1x;
logic [9:0] new_square_1y;
                       logic [9:0] new_square_2x;
							  logic [9:0] new_square_2y;
                      logic [9:0] new_square_3x; logic [9:0] new_square_3y;
                       logic [9:0] new_square_4x; logic [9:0] new_square_4y;
                       logic [9:0] next_square_1x;  logic [9:0] next_square_1y;
                       logic [9:0] next_square_2x;  logic [9:0] next_square_2y;
                       logic [9:0] next_square_3x;  logic [9:0] next_square_3y;
                       logic [9:0] next_square_4x;  logic [9:0] next_square_4y;
                       logic [3:0] shape;

/*
module shape_generator(input Clk, Reset, at_bottom, at_bottom2, at_bottom3, at_bottom4,
                       output logic [9:0] new_square_1x, output logic [9:0] new_square_1y,
                       output logic [9:0] new_square_2x, output logic [9:0] new_square_2y,
                       output logic [9:0] new_square_3x, output logic [9:0] new_square_3y,
                       output logic [9:0] new_square_4x, output logic [9:0] new_square_4y,
                       output logic [9:0] next_square_1x, output logic [9:0] next_square_1y,
                       output logic [9:0] next_square_2x, output logic [9:0] next_square_2y,
                       output logic [9:0] next_square_3x, output logic [9:0] next_square_3y,
                       output logic [9:0] next_square_4x, output logic [9:0] next_square_4y,
                       output logic [3:0] shape,
                       output logic next,
							  output logic  coord
							  );


*/
/*
module rowmodule( input Clk,Reset,load,
                  input [9:0] in,
                  input [9:0] square1x,square1y,square2x,square2y,square3x,square3y,square4x,square4y,
                  input [9:0] y_val,
                  output logic full,
                  output logic [9:0] out,
						output logic [19:0][199:0] compilation
);
*/
//logic pause_enable, rotate_enable;
//logic  [399:0][199:0] game;
//logic [3:0] shape;
//logic[2:0] sq;
//logic[9:0] center_x, center_y;
//logic[9:0]  SQUAREX, SQUAREY, SQUARE_Size_x, SQUARE_Size_y;
///logic at_bottom, at_edgeL, at_edgeR;
//logic [15:0] keycode;
//logic step_enable_a,step_enable_d,step_enable_s,restart_enable;
/*square sw(.*);
keycode_state_machine keyc(.*);
/*module keycode_state_machine( input Clk, input Reset,
							 input [15:0] keycode,
							 output logic step_enable_a,
							 output logic step_enable_s,
							 output logic step_enable_d,
							 output logic pause_enable, restart_enable, rotate_enable
						);*/
/*
module  square (input Reset, Clk, coord, edge_disableL, edge_disableR,
					input a_enable,s_enable,d_enable, pause_enable, rotate_enable,
					input [399:0][199:0] game,
					input [3:0] shape,
					input [2:0] sq,
					input [9:0] center_x, center_y,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,
					output logic [9:0]  SQUAREX, SQUAREY, SQUARE_Size_x, SQUARE_Size_y,
					output logic at_bottom, at_edgeL, at_edgeR);

								);*/
/*module gameboard(
              input Clk,Reset, at_bottom,
              input [9:0] square1x,square1y,square2x,square2y,square3x,square3y,square4x,square4y, // current square positions not placed
              output logic [399:0][199:0] game,
				  output logic [19:0][199:0] example
  );*/
/*module  color_mapper ( input        [9:0] BallX, BallY, BallX2, BallY2, BallX3, BallY3, BallX4, BallY4, DrawX, DrawY, Ball_size,
                       input [399:0][199:0] game,
                       output logic [7:0]  Red, Green, Blue );
*/
/*module  vga_controller ( input        Clk,       // 50 MHz clock
                                      Reset,     // reset signal
                         output logic hs,        // Horizontal sync pulse.  Active low
								              vs,        // Vertical sync pulse.  Active low
												  pixel_clk, // 25 MHz pixel clock output
												  blank,     // Blanking interval indicator.  Active low.
												  sync,      // Composite Sync signal.  Active low.  We don't use it in this lab,
												             //   but the video DAC on the DE2 board requires an input for it.
								 output [9:0] DrawX,     // horizontal coordinate
								              DrawY );   // vertical coordinate*/

// To store expected results

// A counter to count the instances where simulation results
// do no match with expected results

// Instantiating the DUT
// Make sure the module and signal names match with those in your design


// Toggle the clock
// #1 means wait for a delay of 1 timeunit



always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
#0 at_bottom = 0;
#0 at_bottom2 = 0;
#0 at_bottom3 = 0;
#0 at_bottom4 = 0;
#0 Reset = 1'b0;
#2 Reset = 1'b1;
#2 Reset = 1'b0;  //reset

#2 at_bottom = 1'b1;





end
endmodule
