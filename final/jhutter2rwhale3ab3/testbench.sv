module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1
timeprecision 1ns;

// These signals are internal because the processor will be
// instantiated as a submodule in testbench.
logic Clk = 0;
logic Reset;
logic [399:0][199:0] game;
logic [9:0]  BallX, BallY, BallX2, BallY2, BallX3, BallY3, BallX4, BallY4, DrawX, DrawY, Ball_size;
logic pause_enable;
logic [7:0] Red,Green,Blue;
logic flag;
color_mapper cm(.*);
/*
module  color_mapper ( input Clk, Reset,
                       input [9:0] BallX, BallY, BallX2, BallY2, BallX3, BallY3, BallX4, BallY4, DrawX, DrawY, Ball_size,
                       input pause_enable,
                       input [399:0][199:0] game,
                       output logic [7:0]  Red, Green, Blue,
							  output logic flag
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
#0 pause_enable = 1'b0;
#0 BallX = 10'd200;
#0 BallY = 10'd220;
#0 BallX2 = 10'd200;
#0 BallY2 = 10'd220;
#0 BallX3 = 10'd200;
#0 BallY3 = 10'd220;
#0 BallX4 = 10'd200;
#0 BallY4 = 10'd220;
#0 Reset = 1'b0;
#2 Reset = 1'b1;
#2 Reset = 1'b0;  //reset

<<<<<<< HEAD
=======
#2 at_bottom = 1'b1;
#2 at_bottom = 1'b0;

#2 square1x = 10'd280;
#0 square2x = 10'd300;
#0 square3x = 10'd320;
#0 square4x = 10'd340;
#0 square1y = 10'd380;
#0 square2y = 10'd380;
#0 square3y = 10'd380;
#0 square4y = 10'd380;

#2 at_bottom = 1'b1;
#2 at_bottom = 1'b0;

#2 square1x = 10'd360;
#0 square2x = 10'd380;
#0 square3x = 10'd200;
#0 square4x = 10'd220;
#0 square1y = 10'd380;
#0 square2y = 10'd380;
#0 square3y = 10'd360;
#0 square4y = 10'd360;

#2 at_bottom = 1'b1;
#2 at_bottom = 1'b0;


>>>>>>> 9b1c6dc1725e0fc6ff297331fa33a15b8a3f133f


end
endmodule
