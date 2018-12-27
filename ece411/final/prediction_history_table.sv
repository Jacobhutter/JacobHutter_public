/****************************************************************/
/*							Prediction History Table						 */
/*																					 */
/*																					 */
/*																					 */
/*																					 */
/*																					 */
/****************************************************************/
module prediction_history_table(
	input logic clk,
	input logic branch_taken,
	input logic [1:0] current_state,
	
	output logic [1:0] new_state,
	output logic predict
);

// current_state is the current state of the predictor at entry[index]
// new_state is the updated state of the predictor to be written to entry[index]


//enum int unsigned {
//	strongly_not_taken, 
//	weakly_not_taken,
//	weakly_taken,
//	strongly_taken 
//} state, next_state;

always_comb
begin : state_actions
	case(current_state)
		2'b11: begin
			predict = 1;
		end
		
		2'b10: begin
			predict = 1;
		end
		
		2'b00: begin
			predict = 0;
		end
		
		2'b01: begin
			predict = 0;
		end
		
		default: begin
		end
		endcase
end

always_comb
begin : next_state_logic
	case(current_state)
		2'b11: begin // strongly taken
			if(branch_taken)
				new_state = 2'b11;
			else
				new_state = 2'b10;
		end
		
		2'b10: begin // weakly taken
			if(branch_taken)
				new_state = 2'b11;
			else
				new_state = 2'b01;
		end
		
		2'b00: begin // strongly not taken
			if(branch_taken)
				new_state = 2'b01;
			else
				new_state = 2'b00;
		end
		
		2'b01: begin // weakly not taken
			if(branch_taken)
				new_state = 2'b10;
			else
				new_state = 2'b00;
		end
		
		default: begin
		end
		endcase
	
end

//always_ff @(posedge clk)
//begin : next_state_assignment
//	state <= next_state;
//end

endmodule : prediction_history_table