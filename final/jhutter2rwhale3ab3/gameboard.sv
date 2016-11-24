module gameboard(
              input Clk,Reset,
              input [9:0] square1x,square1y,square2x,square2y,square3x,square3y,square4x,square4y, // current square positions not placed
              output logic [9:0]  c1,c2,c3,c4,c5,c6,c7,c8,c9,c10, // max heights of each column
              output logic [199:0] gameboard
  );

        Reg200 rt(.*,); // contains every square on the board
        /* all row modules below*/
        rowmodule r1();
        rowmodule r2();
        rowmodule r3();
        rowmodule r4();
        rowmodule r5();
        rowmodule r6();
        rowmodule r7();
        rowmodule r8();
        rowmodule r9();
        rowmodule r10();
        rowmodule r11();
        rowmodule r12();
        rowmodule r13();
        rowmodule r14();
        rowmodule r15();
        rowmodule r16();
        rowmodule r17();
        rowmodule r18();
        rowmodule r19();
        rowmodule r20();

endmodule
