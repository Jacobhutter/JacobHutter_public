import lc3b_types::*;
/****************************************************************/
/*								Global Branch History						 */
/*																					 */
/*																					 */
/*																					 */
/*																					 */
/*																					 */
/****************************************************************/
module global_bht(
	input logic clk,
	input logic update,
	input lc3b_word pc_in,
	input branch_taken,
	
	output logic predict
);

reg branch_history_register;
logic [1:0] current_state;
logic [1:0] new_state;

initial begin
	branch_history_register = 0;
end

array #(.width(2))pht_array
(
	.clk,
   .write(update), // only update when there is a branch
   .index(3'({pc_in[2:1], branch_history_register})),
   .datain(new_state),
   .dataout(current_state)
);

prediction_history_table pht
(
	.clk,
	.branch_taken,
	.current_state,
	.new_state,
	.predict
);

always_ff @(posedge clk) begin
	branch_history_register = branch_taken;
end
endmodule : global_bht