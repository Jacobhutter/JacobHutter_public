module gameboard(
              input Clk,Reset, at_bottom,
              input [9:0] square1x,square1y,square2x,square2y,square3x,square3y,square4x,square4y, // current square positions not placed
              output logic [399:0][199:0] game,
				  output logic [19:0][199:0] example,
				  output logic [9:0] c1,c2,c3,c4,c5,c6,c7,c8,c9,c10
  );
		       logic [19:0][199:0] compilation1,compilation2,compilation3,compilation4,compilation5,compilation6,compilation7,compilation8,compilation9,compilation10,compilation11,compilation12,compilation13,compilation14,compilation15,compilation16,compilation17,compilation18,compilation19,compilation20;
		 assign example = compilation20;
		  assign game = {{compilation20},{compilation19},{compilation18},{compilation17},{compilation16},{compilation15},{compilation14},{compilation13},{compilation12},{compilation11},{compilation10},{compilation9},{compilation8},{compilation7},{compilation6},{compilation5},{compilation4},{compilation3},{compilation2},{compilation1}};
        logic [9:0] r1out,r2out,r3out,r4out,r5out,r6out,r7out,r8out,r9out,r10out,r11out,r12out,r13out,r14out,r15out,r16out,r17out,r18out,r19out,r20out;
        logic f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,f17,f18,f19,f20;		  
			
        always_comb begin
            if(r1out[0])
              c1 = -20;
            else if(r2out[0])
              c1 = 0;
            else if(r3out[0])
              c1 = 20;
            else if(r4out[0])
              c1 = 40;
            else if(r5out[0])
              c1 = 60;
            else if(r6out[0])
              c1 = 80;
            else if(r7out[0])
              c1 = 100;
            else if(r8out[0])
              c1 = 120;
            else if(r9out[0])
              c1 = 140;
            else if(r10out[0])
              c1 = 160;
            else if(r11out[0])
              c1 = 180;
            else if(r12out[0])
              c1 = 200;
            else if(r13out[0])
              c1 = 220;
            else if(r14out[0])
              c1 = 240;
            else if(r15out[0])
              c1 = 260;
            else if(r16out[0])
              c1 = 280;
            else if(r17out[0])
              c1 = 300;
            else if(r18out[0])
              c1 = 320;
            else if(r19out[0])
              c1 = 340;
            else if(r20out[0])
              c1 = 360;
				else
					c1 = 380;

              if(r1out[1])
                c2 = -20;
              else if(r2out[1])
                c2 = 0;
              else if(r3out[1])
                c2 = 20;
              else if(r4out[1])
                c2 = 40;
              else if(r5out[1])
                c2 = 60;
              else if(r6out[1])
                c2 = 80;
              else if(r7out[1])
                c2 = 100;
              else if(r8out[1])
                c2 = 120;
              else if(r9out[1])
                c2 = 140;
              else if(r10out[1])
                c2 = 160;
              else if(r11out[1])
                c2 = 180;
              else if(r12out[1])
                c2 = 200;
              else if(r13out[1])
                c2 = 220;
              else if(r14out[1])
                c2 = 240;
              else if(r15out[1])
                c2 = 260;
              else if(r16out[1])
                c2 = 280;
              else if(r17out[1])
                c2 = 300;
              else if(r18out[1])
                c2 = 320;
              else if(r19out[1])
                c2 = 340;
              else if(r20out[1])
                c2 = 360;
				  else 
					 c2 = 380;

                if(r1out[2])
                  c3 = -20;
                else if(r2out[2])
                  c3 = 0;
                else if(r3out[2])
                  c3 = 20;
                else if(r4out[2])
                  c3 = 40;
                else if(r5out[2])
                  c3 = 60;
                else if(r6out[2])
                  c3 = 80;
                else if(r7out[2])
                  c3 = 100;
                else if(r8out[2])
                  c3 = 120;
                else if(r9out[2])
                  c3 = 140;
                else if(r10out[2])
                  c3 = 160;
                else if(r11out[2])
                  c3 = 180;
                else if(r12out[2])
                  c3 = 200;
                else if(r13out[2])
                  c3 = 220;
                else if(r14out[2])
                  c3 = 240;
                else if(r15out[2])
                  c3 = 260;
                else if(r16out[2])
                  c3 = 280;
                else if(r17out[2])
                  c3 = 300;
                else if(r18out[2])
                  c3 = 320;
                else if(r19out[2])
                  c3 = 340;
                else if(r20out[2])
                  c3 = 360;
					 else 
						c3 = 380;

                  if(r1out[3])
                    c4 = -20;
                  else if(r2out[3])
                    c4 = 0;
                  else if(r3out[3])
                    c4 = 20;
                  else if(r4out[3])
                    c4 = 40;
                  else if(r5out[3])
                    c4 = 60;
                  else if(r6out[3])
                    c4 = 80;
                  else if(r7out[3])
                    c4 = 100;
                  else if(r8out[3])
                    c4 = 120;
                  else if(r9out[3])
                    c4 = 140;
                  else if(r10out[3])
                    c4 = 160;
                  else if(r11out[3])
                    c4 = 180;
                  else if(r12out[3])
                    c4 = 200;
                  else if(r13out[3])
                    c4 = 220;
                  else if(r14out[3])
                    c4 = 240;
                  else if(r15out[3])
                    c4 = 260;
                  else if(r16out[3])
                    c4 = 280;
                  else if(r17out[3])
                    c4 = 300;
                  else if(r18out[3])
                    c4 = 320;
                  else if(r19out[3])
                    c4 = 340;
                  else if(r20out[3])
                    c4 = 360;
						else 
							c4 = 380;
                    if(r1out[4])
                      c5 = -20;
                    else if(r2out[4])
                      c5 = 0;
                    else if(r3out[4])
                      c5 = 20;
                    else if(r4out[4])
                      c5 = 40;
                    else if(r5out[4])
                      c5 = 60;
                    else if(r6out[4])
                      c5 = 80;
                    else if(r7out[4])
                      c5 = 100;
                    else if(r8out[4])
                      c5 = 120;
                    else if(r9out[4])
                      c5 = 140;
                    else if(r10out[4])
                      c5 = 160;
                    else if(r11out[4])
                      c5 = 180;
                    else if(r12out[4])
                      c5 = 200;
                    else if(r13out[4])
                      c5 = 220;
                    else if(r14out[4])
                      c5 = 240;
                    else if(r15out[4])
                      c5 = 260;
                    else if(r16out[4])
                      c5 = 280;
                    else if(r17out[4])
                      c5 = 300;
                    else if(r18out[4])
                      c5 = 320;
                    else if(r19out[4])
                      c5 = 340;
                    else if(r20out[4])
                      c5 = 360;
						  else 
							 c5 = 380;
							 
                      if(r1out[0])
                        c6 = -20;
                      else if(r2out[5])
                        c6 = 0;
                      else if(r3out[5])
                        c6 = 20;
                      else if(r4out[5])
                        c6 = 40;
                      else if(r5out[5])
                        c6 = 60;
                      else if(r6out[5])
                        c6 = 80;
                      else if(r7out[5])
                        c6 = 100;
                      else if(r8out[5])
                        c6 = 120;
                      else if(r9out[5])
                        c6 = 140;
                      else if(r10out[5])
                        c6 = 160;
                      else if(r11out[5])
                        c6 = 180;
                      else if(r12out[5])
                        c6 = 200;
                      else if(r13out[5])
                        c6 = 220;
                      else if(r14out[5])
                        c6 = 240;
                      else if(r15out[5])
                        c6 = 260;
                      else if(r16out[5])
                        c6 = 280;
                      else if(r17out[5])
                        c6 = 300;
                      else if(r18out[5])
                        c6 = 320;
                      else if(r19out[5])
                        c6 = 340;
                      else if(r20out[5])
                        c6 = 360;
							 else 
								c6 = 380;
								
                        if(r1out[6])
                          c7 = -20;
                        else if(r2out[6])
                          c7 = 0;
                        else if(r3out[6])
                          c7 = 20;
                        else if(r4out[6])
                          c7 = 40;
                        else if(r5out[6])
                          c7 = 60;
                        else if(r6out[6])
                          c7 = 80;
                        else if(r7out[6])
                          c7 = 100;
                        else if(r8out[6])
                          c7 = 120;
                        else if(r9out[6])
                          c7 = 140;
                        else if(r10out[6])
                          c7 = 160;
                        else if(r11out[6])
                          c7 = 180;
                        else if(r12out[6])
                          c7 = 200;
                        else if(r13out[6])
                          c7 = 220;
                        else if(r14out[6])
                          c7 = 240;
                        else if(r15out[6])
                          c7 = 260;
                        else if(r16out[6])
                          c7 = 280;
                        else if(r17out[6])
                          c7 = 300;
                        else if(r18out[6])
                          c7 = 320;
                        else if(r19out[6])
                          c7 = 340;
                        else if(r20out[6])
                          c7 = 360;
								else 
									c7 = 380;

                          if(r1out[7])
                            c8 = -20;
                          else if(r2out[7])
                            c8 = 0;
                          else if(r3out[7])
                            c8 = 20;
                          else if(r4out[7])
                            c8 = 40;
                          else if(r5out[7])
                            c8 = 60;
                          else if(r6out[7])
                            c8 = 80;
                          else if(r7out[7])
                            c8 = 100;
                          else if(r8out[7])
                            c8 = 120;
                          else if(r9out[7])
                            c8 = 140;
                          else if(r10out[7])
                            c8 = 160;
                          else if(r11out[7])
                            c8 = 180;
                          else if(r12out[7])
                            c8 = 200;
                          else if(r13out[7])
                            c8 = 220;
                          else if(r14out[7])
                            c8 = 240;
                          else if(r15out[7])
                            c8 = 260;
                          else if(r16out[7])
                            c8 = 280;
                          else if(r17out[7])
                            c8 = 300;
                          else if(r18out[7])
                            c8 = 320;
                          else if(r19out[7])
                            c8 = 340;
                          else if(r20out[7])
                            c8 = 360;
								  else 
									 c8 = 380;
									 
                            if(r1out[8])
                              c9 = -20;
                            else if(r2out[8])
                              c9 = 0;
                            else if(r3out[8])
                              c9 = 20;
                            else if(r4out[8])
                              c9 = 40;
                            else if(r5out[8])
                              c9 = 60;
                            else if(r6out[8])
                              c9 = 80;
                            else if(r7out[8])
                              c9 = 100;
                            else if(r8out[8])
                              c9 = 120;
                            else if(r9out[8])
                              c9 = 140;
                            else if(r10out[8])
                              c9 = 160;
                            else if(r11out[8])
                              c9 = 180;
                            else if(r12out[8])
                              c9 = 200;
                            else if(r13out[8])
                              c9 = 220;
                            else if(r14out[8])
                              c9 = 240;
                            else if(r15out[8])
                              c9 = 260;
                            else if(r16out[8])
                              c9 = 280;
                            else if(r17out[8])
                              c9 = 300;
                            else if(r18out[8])
                              c9 = 320;
                            else if(r19out[8])
                              c9 = 340;
                            else if(r20out[8])
                              c9 = 360;
									 else 
										c9 = 380;
										
                              if(r1out[9])
                                c10 = -20;
                              else if(r2out[9])
                                c10 = 0;
                              else if(r3out[9])
                                c10 = 20;
                              else if(r4out[9])
                                c10 = 40;
                              else if(r5out[9])
                                c10 = 60;
                              else if(r6out[9])
                                c10 = 80;
                              else if(r7out[9])
                                c10 = 100;
                              else if(r8out[9])
                                c10 = 120;
                              else if(r9out[9])
                                c10 = 140;
                              else if(r10out[9])
                                c10 = 160;
                              else if(r11out[9])
                                c10 = 180;
                              else if(r12out[9])
                                c10 = 200;
                              else if(r13out[9])
                                c10 = 220;
                              else if(r14out[9])
                                c10 = 240;
                              else if(r15out[9])
                                c10 = 260;
                              else if(r16out[9])
                                c10 = 280;
                              else if(r17out[9])
                                c10 = 300;
                              else if(r18out[9])
                                c10 = 320;
                              else if(r19out[9])
                                c10 = 340;
                              else if(r20out[9])
                                c10 = 360;
										else 
											c10 = 380;
	
        end
        rowmodule r1(.*,.load(at_bottom),.in(r1out),.full(f1),.out(r1out),.y_val(10'd0),.compilation(compilation1)); // [0 -20][]
		  rowmodule r2(.*,.load(at_bottom),.in(r2out),.full(f2),.out(r2out),.y_val(10'd20),.compilation(compilation2));
        rowmodule r3(.*,.load(at_bottom),.in(r3out),.full(f3),.out(r3out),.y_val(10'd40),.compilation(compilation3));
        rowmodule r4(.*,.load(at_bottom),.in(r4out),.full(f4),.out(r4out),.y_val(10'd60),.compilation(compilation4));
        rowmodule r5(.*,.load(at_bottom),.in(r5out),.full(f5),.out(r5out),.y_val(10'd80),.compilation(compilation5));
        rowmodule r6(.*,.load(at_bottom),.in(r6out),.full(f6),.out(r6out),.y_val(10'd100),.compilation(compilation6));
        rowmodule r7(.*,.load(at_bottom),.in(r7out),.full(f7),.out(r7out),.y_val(10'd120),.compilation(compilation7));
        rowmodule r8(.*,.load(at_bottom),.in(r8out),.full(f8),.out(r8out),.y_val(10'd140),.compilation(compilation8));
        rowmodule r9(.*,.load(at_bottom),.in(r9out),.full(f9),.out(r9out),.y_val(10'd160),.compilation(compilation9));
        rowmodule r10(.*,.load(at_bottom),.in(r10out),.full(f10),.out(r10out),.y_val(10'd180),.compilation(compilation10));
        rowmodule r11(.*,.load(at_bottom),.in(r11out),.full(f11),.out(r11out),.y_val(10'd200),.compilation(compilation11));
        rowmodule r12(.*,.load(at_bottom),.in(r12out),.full(f12),.out(r12out),.y_val(10'd220),.compilation(compilation12));
        rowmodule r13(.*,.load(at_bottom),.in(r13out),.full(f13),.out(r13out),.y_val(10'd240),.compilation(compilation13));
        rowmodule r14(.*,.load(at_bottom),.in(r14out),.full(f14),.out(r14out),.y_val(10'd260),.compilation(compilation14));
        rowmodule r15(.*,.load(at_bottom),.in(r15out),.full(f15),.out(r15out),.y_val(10'd280),.compilation(compilation15));
        rowmodule r16(.*,.load(at_bottom),.in(r16out),.full(f16),.out(r16out),.y_val(10'd300),.compilation(compilation16));
        rowmodule r17(.*,.load(at_bottom),.in(r17out),.full(f17),.out(r17out),.y_val(10'd320),.compilation(compilation17));
        rowmodule r18(.*,.load(at_bottom),.in(r18out),.full(f18),.out(r18out),.y_val(10'd340),.compilation(compilation18));
        rowmodule r19(.*,.load(at_bottom),.in(r19out),.full(f19),.out(r19out),.y_val(10'd360),.compilation(compilation19));
        rowmodule r20(.*,.load(at_bottom),.in(r20out),.full(f20),.out(r20out),.y_val(10'd380),.compilation(compilation20));		 
		endmodule
