`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: PIPELINED_ALU
// Project Name: 32_BIT_PIPELINED_ALU
// Module Creation Date: 03-06-2026
// Modification Date: none
// Verification Date:03-06-2026 
//////////////////////////////////////////////////////////////////////////////////


module Control_unit_TB;
    reg [15:0]OPERATION;            // 16 - bit opcode register
    reg VALID_IN;                   // active high valid input signal register
    reg CLR_EN;                     // active low clear signal register
    reg G_CLK;                      // clock register
    wire [3:0]opcode;               // opcode
    wire [3:0]rd_addr1;             // read address 1
    wire [3:0]rd_addr2;             // read address 2
    wire [3:0]wr_addr;              // write address
    wire wr_en;                     // write enable signal
    wire clr;                       // clear signal (active low)             
    
    initial begin
        OPERATION = 16'h0000;
        VALID_IN = 1'b0;
        CLR_EN = 1'b0;
        G_CLK = 1'b0;
     end
     
     always begin
        #5 G_CLK = ~G_CLK;
     end
     
     initial begin
        #3 CLR_EN = 1'b1;
        #5 CLR_EN = 1'b0;
     end
         
     initial begin
        $monitor("T = %d, OPR = %h, RD1 = %b, RD2 = %b, WR = %b, WR = %b, CLR = %b,", $time, opcode, rd_addr1, rd_addr2, wr_addr, wr_en, clr);
     end
     
     CONTROL_UNIT CU (.Operation(OPERATION),
                      .valid_in(VALID_IN),
                      .clr_en(CLR_EN),
                      .CLK(G_CLK),
                      .OPCODE(opcode),
                      .RD_ADDR1(rd_addr1),
                      .RD_ADDR2(rd_addr2),
                      .WR_ADDR(wr_addr),
                      .WR_EN(wr_en),
                      .CLR(clr));
     
     initial begin
        #40; VALID_IN = 1'b1;
        #10; OPERATION = 16'b1001_0000_0001_1000;  
        #10; OPERATION = 16'b0010_0010_0011_1001;
        #10; OPERATION = 16'b0110_0100_0101_1010;
        #10; OPERATION = 16'b1011_0110_0111_1011;
        #10; OPERATION = 16'b1100_1100_1101_1110;
        #10; VALID_IN = 1'b0;
        #40; $finish;
     end

endmodule