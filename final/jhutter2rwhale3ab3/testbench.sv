module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1
timeprecision 1ns;

// These signals are internal because the processor will be
// instantiated as a submodule in testbench.
logic Clk = 0;
logic Reset;
logic at_bottom;
logic [9:0] center_x,center_y;
logic a_enable,d_enable,s_enable;
logic [9:0] ballxsig,ballysig,ballsizesig;

logic coord;


shape_generator s_g(.coord(coord),.Clk(Clk),.Reset(Reset_h),.at_bottom(at_bottom),.new_square_1x(center_x),.new_square_1y(center_y),.new_square_2x(),.new_square_2y(),.new_square_3x(),.new_square_3y(),.new_square_4x(),.new_square_4y());

	 square square_instance(.at_bottom(at_bottom),.center_x(center_x),.center_y(center_y),.Reset(Reset_h),.a_enable(a_enable),.s_enable(s_enable|flag),.d_enable(d_enable),
   .Clk(Clk),.SQUAREX(ballxsig),.SQUAREY(ballysig),.SQUARE_Size_x(ballsizesig),.SQUARE_Size_y(),.coord(coord));

/*module  square (input Reset, Clk,
					input a_enable,s_enable,d_enable,
					input [9:0] center_x, center_y,
					output logic [9:0]  SQUAREX, SQUAREY, SQUARE_Size_x, SQUARE_Size_y,
					output logic at_bottom);*/
/*module shape_generator(input Clk, Reset, at_bottom,
                       output logic [9:0] new_square_1x, output logic [9:0] new_square_1y,
                       output logic [9:0] new_square_2x, output logic [9:0] new_square_2y,
                       output logic [9:0] new_square_3x, output logic [9:0] new_square_3y,
                       output logic [9:0] new_square_4x, output logic [9:0] new_square_4y );*/
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
#0 Reset = 1'b0;
#0 at_bottom = 1'b0;
#0 s_enable = 1'b0;
#0 d_enable = 1'b0;
#0 a_enable = 1'b0;
#2 Reset = 1'b1;
#2 Reset = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;
#2 s_enable = 1'b1;
#2 s_enable = 1'b0;




end
endmodule
