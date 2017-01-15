module gameboard(
              input Clk,Reset, at_bottom,
              input [9:0] square1x,square1y,square2x,square2y,square3x,square3y,square4x,square4y, // current square positions not placed
              output logic [399:0][199:0] game,
				  output logic [19:0][199:0] example,
				  output logic probe
  );
		       logic [19:0][199:0] compilation1,compilation2,compilation3,compilation4,compilation5,compilation6,compilation7,compilation8,compilation9,compilation10,compilation11,compilation12,compilation13,compilation14,compilation15,compilation16,compilation17,compilation18,compilation19,compilation20;
		 assign example = compilation20;
		  assign game = {{compilation20},{compilation19},{compilation18},{compilation17},{compilation16},{compilation15},{compilation14},{compilation13},{compilation12},{compilation11},{compilation10},{compilation9},{compilation8},{compilation7},{compilation6},{compilation5},{compilation4},{compilation3},{compilation2},{compilation1}};
        logic [9:0] r1out,r2out,r3out,r4out,r5out,r6out,r7out,r8out,r9out,r10out,r11out,r12out,r13out,r14out,r15out,r16out,r17out,r18out,r19out,r20out;
        logic f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,f17,f18,f19,f20;
			assign probe = r1out[5] | r1out[6];

        rowmodule r1(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 | f16 | f15 | f14 | f13 | f12 | f11 | f10 | f9 | f8 | f7 | f6 | f5 | f4 | f3 | f2 | f1 ? 10'd0 : r1out),.full(f1),.out(r1out),.y_val(10'd0),.compilation(compilation1)); // [0 -20][]
		  rowmodule r2(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 | f16 | f15 | f14 | f13 | f12 | f11 | f10 | f9 | f8 | f7 | f6 | f5 | f4 | f3 | f2 ? r1out : r2out),.full(f2),.out(r2out),.y_val(10'd20),.compilation(compilation2));
        rowmodule r3(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 | f16 | f15 | f14 | f13 | f12 | f11 | f10 | f9 | f8 | f7 | f6 | f5 | f4 | f3 ? r2out : r3out),.full(f3),.out(r3out),.y_val(10'd40),.compilation(compilation3));
        rowmodule r4(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 | f16 | f15 | f14 | f13 | f12 | f11 | f10 | f9 | f8 | f7 | f6 | f5 | f4 ? r3out : r4out),.full(f4),.out(r4out),.y_val(10'd60),.compilation(compilation4));
        rowmodule r5(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 | f16 | f15 | f14 | f13 | f12 | f11 | f10 | f9 | f8 | f7 | f6 | f5 ? r4out : r5out),.full(f5),.out(r5out),.y_val(10'd80),.compilation(compilation5));
        rowmodule r6(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 | f16 | f15 | f14 | f13 | f12 | f11 | f10 | f9 | f8 | f7 | f6 ? r5out : r6out),.full(f6),.out(r6out),.y_val(10'd100),.compilation(compilation6));
        rowmodule r7(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 | f16 | f15 | f14 | f13 | f12 | f11 | f10 | f9 | f8 | f7 ? r6out : r7out),.full(f7),.out(r7out),.y_val(10'd120),.compilation(compilation7));
        rowmodule r8(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 | f16 | f15 | f14 | f13 | f12 | f11 | f10 | f9 | f8 ? r7out : r8out),.full(f8),.out(r8out),.y_val(10'd140),.compilation(compilation8));
        rowmodule r9(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 | f16 | f15 | f14 | f13 | f12 | f11 | f10 | f9 ? r8out : r9out),.full(f9),.out(r9out),.y_val(10'd160),.compilation(compilation9));
        rowmodule r10(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 | f16 | f15 | f14 | f13 | f12 | f11 | f10 ? r9out : r10out),.full(f10),.out(r10out),.y_val(10'd180),.compilation(compilation10));
        rowmodule r11(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 | f16 | f15 | f14 | f13 | f12 | f11 ? r10out : r11out),.full(f11),.out(r11out),.y_val(10'd200),.compilation(compilation11));
        rowmodule r12(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 | f16 | f15 | f14 | f13 | f12 ? r11out : r12out),.full(f12),.out(r12out),.y_val(10'd220),.compilation(compilation12));
        rowmodule r13(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 | f16 | f15 | f14 | f13 ? r12out : r13out),.full(f13),.out(r13out),.y_val(10'd240),.compilation(compilation13));
        rowmodule r14(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 | f16 | f15 | f14 ? r13out : r14out),.full(f14),.out(r14out),.y_val(10'd260),.compilation(compilation14));
        rowmodule r15(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 | f16 | f15 ? r14out : r15out),.full(f15),.out(r15out),.y_val(10'd280),.compilation(compilation15));
        rowmodule r16(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 | f16 ? r15out : r16out),.full(f16),.out(r16out),.y_val(10'd300),.compilation(compilation16));
        rowmodule r17(.*,.load(at_bottom),.in(f19 | f20 | f18 | f17 ? r16out : r17out),.full(f17),.out(r17out),.y_val(10'd320),.compilation(compilation17));
        rowmodule r18(.*,.load(at_bottom),.in(f19 | f20 | f18 ? r17out : r18out),.full(f18),.out(r18out),.y_val(10'd340),.compilation(compilation18));
        rowmodule r19(.*,.load(at_bottom),.in(f19 | f20 ? r18out : r19out),.full(f19),.out(r19out),.y_val(10'd360),.compilation(compilation19));
        rowmodule r20(.*,.load(at_bottom),.in(f20 ? r19out : r20out),.full(f20),.out(r20out),.y_val(10'd380),.compilation(compilation20));

		endmodule
