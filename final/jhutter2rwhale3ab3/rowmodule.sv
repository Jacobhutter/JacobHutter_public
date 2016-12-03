module rowmodule( input Clk,Reset,load,
                  input [9:0] in,
                  input [9:0] square1x,square1y,square2x,square2y,square3x,square3y,square4x,square4y,
                  input [9:0] y_val,
                  output logic full,
                  output logic [9:0] out,
						output logic [19:0][199:0] compilation
);
			 logic[199:0] b_row;
			 always_comb begin
				b_row[199:0] = {{20{out[9]}}, {20{out[8]}}, {20{out[7]}}, {20{out[6]}}, {20{out[5]}}, {20{out[4]}},{20{out[3]}},{20{out[2]}},{20{out[1]}},{20{out[0]}}};
				compilation = {{b_row},{b_row},{b_row},{b_row},{b_row},{b_row},{b_row},{b_row},{b_row},{b_row},{b_row},{b_row},{b_row},{b_row},{b_row},{b_row},{b_row},{b_row},{b_row},{b_row}};

			 end
          always_ff @ (posedge Clk or posedge Reset)
          begin
          if(Reset)
            out <= 10'b0;
          else begin
            out <= in;
            if(load) begin
             if(square1y == y_val) begin
              case(square1x)
              200 : out[0] <= 1'b1;
              220 : out[1] <= 1'b1;
              240 : out[2] <= 1'b1;
              260 : out[3] <= 1'b1;
              280 : out[4] <= 1'b1;
              300 : out[5] <= 1'b1;
              320 : out[6] <= 1'b1;
              340 : out[7] <= 1'b1;
              360 : out[8] <= 1'b1;
              380 : out[9] <= 1'b1;
              endcase
              end
              if(square2y == y_val) begin
               case(square2x)
               200 : out[0] <= 1'b1;
               220 : out[1] <= 1'b1;
               240 : out[2] <= 1'b1;
               260 : out[3] <= 1'b1;
               280 : out[4] <= 1'b1;
               300 : out[5] <= 1'b1;
               320 : out[6] <= 1'b1;
               340 : out[7] <= 1'b1;
               360 : out[8] <= 1'b1;
               380 : out[9] <= 1'b1;
               endcase
               end
               if(square3y == y_val) begin
                case(square3x)
                200 : out[0] <= 1'b1;
                220 : out[1] <= 1'b1;
                240 : out[2] <= 1'b1;
                260 : out[3] <= 1'b1;
                280 : out[4] <= 1'b1;
                300 : out[5] <= 1'b1;
                320 : out[6] <= 1'b1;
                340 : out[7] <= 1'b1;
                360 : out[8] <= 1'b1;
                380 : out[9] <= 1'b1;
                endcase
                end
                if(square4y == y_val) begin
                 case(square4x)
                 200 : out[0] <= 1'b1;
                 220 : out[1] <= 1'b1;
                 240 : out[2] <= 1'b1;
                 260 : out[3] <= 1'b1;
                 280 : out[4] <= 1'b1;
                 300 : out[5] <= 1'b1;
                 320 : out[6] <= 1'b1;
                 340 : out[7] <= 1'b1;
                 360 : out[8] <= 1'b1;
                 380 : out[9] <= 1'b1;
                 endcase
                 end
              if(out == 10'b1111111111 ) // full row
                full <= 1'b1;
              else
                full <= 1'b0;

          end
        end
      end

endmodule
