module evictbuf_tb ();

timeunit 10ns;

timeprecision 1ns;

logic clk;

wishbone orig_wb(clk);
wishbone dest_wb(clk);

evictbuffer eb_dut (orig_wb, dest_wb);

always begin : CLOCK_GENERATION
#1 clk = ~clk;
end

initial begin: CLOCK_INITIALIZATION
    clk = 0;
end 


initial begin: TEST_VECTORS
    orig_wb.DAT_M = 0;
    orig_wb.CYC = 0;
    orig_wb.STB = 0;
    orig_wb.WE = 0;
    orig_wb.SEL = 0;
    orig_wb.ADR = 0;
    dest_wb.DAT_S = 0;
    dest_wb.ACK = 0;
    dest_wb.RTY = 0;
    
    // Test pass-through read
    #2 orig_wb.DAT_M = {8{16'h600d}};
    orig_wb.STB = 1;
    orig_wb.WE = 0;
    orig_wb.SEL = {128{1'b1}};
    orig_wb.ADR = 12'h001;
    dest_wb.ACK = 1;
    #1 assert(dest_wb.ADR == orig_wb.ADR);
    assert(dest_wb.STB == 1);
    assert(dest_wb.WE == 0);
    assert(dest_wb.SEL == {16{1'b1}});
    assert(orig_wb.ACK == 1);
    #1 dest_wb.ACK = 0;
    
    // Write-back #1: no interruption
    // First write transfer
    orig_wb.DAT_M = {8{16'habcd}};
    orig_wb.STB = 1;
    orig_wb.WE = 1;
    orig_wb.ADR = 12'h002;
    #1 assert(dest_wb.STB == 0);
    assert(orig_wb.ACK == 1);
    // Master now executes read
    #1 orig_wb.STB = 1;
    orig_wb.WE = 0;
    orig_wb.ADR = 12'h003;
    #1 assert(dest_wb.ADR == orig_wb.ADR);
    assert(dest_wb.STB == 1);
    assert(dest_wb.WE == 0);
    assert(dest_wb.SEL == {16{1'b1}});
    #3 dest_wb.ACK = 1;
    #1 assert(orig_wb.ACK == 1);
    #1 dest_wb.ACK = 0;
    
    // Master idles, but buffer performs a write
    orig_wb.STB = 0;
    orig_wb.WE = 0;
    #3 assert(dest_wb.ADR == 12'h002);
    assert(dest_wb.STB == 1);
    assert(dest_wb.WE == 1);
    assert(dest_wb.SEL == {16{1'b1}});
    #5 dest_wb.ACK = 1;
    #1 assert(orig_wb.ACK == 0);
    #1 dest_wb.ACK = 0;
    
    // Writeback #2: read interruption
    // First write transfer
    orig_wb.DAT_M = {8{16'h1337}};
    orig_wb.STB = 1;
    orig_wb.WE = 1;
    orig_wb.ADR = 12'h004;
    #1 assert(dest_wb.STB == 0);
    #2 assert(orig_wb.ACK == 1);
    // Master now executes read
    #1 orig_wb.STB = 1;
    orig_wb.WE = 0;
    orig_wb.ADR = 12'h005;
    dest_wb.ACK = 1;
    #1 assert(dest_wb.ADR == orig_wb.ADR);
    assert(dest_wb.STB == 1);
    assert(dest_wb.WE == 0);
    assert(dest_wb.SEL == {16{1'b1}});
    assert(orig_wb.ACK == 1);
    #1 dest_wb.ACK = 0;
    // Master now reads from same address as write
    orig_wb.STB = 1;
    orig_wb.WE = 0;
    orig_wb.ADR = 12'h004;
    #1 assert(orig_wb.ACK == 1);
    assert(orig_wb.DAT_S == {8{16'h1337}});
    // Also check for concurrent write from buffer
    #2 assert(dest_wb.ADR == 12'h004);
    assert(dest_wb.STB == 1);
    assert(dest_wb.WE == 1);
    assert(dest_wb.SEL == {16{1'b1}});
    assert(dest_wb.DAT_M == {8{16'h1337}});
    // Master is denied attempt to read from different address
    #1 orig_wb.STB = 1;
    orig_wb.WE = 0;
    orig_wb.ADR = 12'h006;
    #1 assert(orig_wb.ACK == 0);
    // Service writeback
    #1 dest_wb.ACK = 1;
    #1 assert(orig_wb.ACK == 0);
    #1 dest_wb.ACK = 0;
    
    // Writeback #3: write interruption
    // First write transfer
    orig_wb.DAT_M = {8{16'hfa11}};
    orig_wb.STB = 1;
    orig_wb.WE = 1;
    orig_wb.ADR = 12'h007;
    #1 assert(dest_wb.STB == 0);
    #2 assert(orig_wb.ACK == 1);
    // Master now executes read
    #1 orig_wb.STB = 1;
    orig_wb.WE = 0;
    orig_wb.ADR = 12'h008;
    #1 assert(dest_wb.ADR == orig_wb.ADR);
    assert(dest_wb.STB == 1);
    assert(dest_wb.WE == 0);
    assert(dest_wb.SEL == {16{1'b1}});
    #1 dest_wb.ACK = 1;
    #1 assert(orig_wb.ACK == 1);
    #1 dest_wb.ACK = 0;
    // Master is denied attempt to write from same address
    orig_wb.DAT_M = {8{16'hfa22}};
    orig_wb.STB = 1;
    orig_wb.WE = 1;
    orig_wb.ADR = 12'h007;
    #1 assert(orig_wb.ACK == 0);
//    // Also check for concurrent write from buffer
    #2 assert(dest_wb.ADR == 12'h007);
    assert(dest_wb.STB == 1);
    assert(dest_wb.WE == 1);
    assert(dest_wb.SEL == {16{1'b1}});
    assert(dest_wb.DAT_M == {8{16'hfa11}});
    // Service writeback
    #3 dest_wb.ACK = 1;
    #1 assert(orig_wb.ACK == 0);
    #1 dest_wb.ACK = 0;
end

endmodule : evictbuf_tb