module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1
timeprecision 1ns;

// These signals are internal because the processor will be
// instantiated as a submodule in testbench.
logic Clk = 0;
logic					reset_n;
logic	[127:0]			msg_en;
logic	[127:0]			key;
logic [127:0]			msg_de;
logic					io_ready;
logic  aes_ready;

// To store expected results

// A counter to count the instances where simulation results
// do no match with expected results

// Instantiating the DUT
// Make sure the module and signal names match with those in your design
aes_controller as(.clk(Clk),.*);
//slc3 lc(.*);

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
#2 io_ready = 1'b0;
#2 reset_n = 1'b0;
#22 reset_n = 1'b1;
#22 msg_en = 128'd128;
#22 key = 128'd127;
#22 io_ready = 1'b1;



/*

#2 S = 16'h0003;

#2 Continue = 0;
#22 Continue = 1;

#2 Continue = 0;
#22 Continue = 1;

#2 Continue = 0;
#22 Continue = 1;

#2 Continue = 0;
#22 Continue = 1;

#2 Continue = 0;
#22 Continue = 1;


#2 Continue = 0;
#22 Continue = 1;

#2 Continue = 0;
#22 Continue = 1;

#2 Continue = 0;
#22 Continue = 1;

#2 Continue/= 0;
#22 Continue = 1;

#2 Continue = 0;
#22 Continue = 1;

#2 Continue = 0;
#22 Continue = 1;

#2 Continue = 0;
#22 Continue = 1;

#2 Continue = 0;
#22 Continue = 1;

#2 Continue = 0;
#22 Continue = 1;

#2 Continue = 0;
#22 Continue = 1;
*/
end
endmodule
