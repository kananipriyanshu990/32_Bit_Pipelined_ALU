`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: MEM_B_TB
// Project Name: 32_BIT_PIPELINED_ALU
// Module Creation Date: 28-05-2026
// Description: This testbench is used to test the register bank/register file 
// Modification Date: none
// Verification date: 28-05-2026
//////////////////////////////////////////////////////////////////////////////////


module MEM_B_TB;
    reg [31:0] MEM_TB_IN = 32'b0;                 //32-bit input bus for writing into register file                               
    wire [31:0] MEM_TB_OUT1, MEM_TB_OUT2;         //32-bit output buses 
    reg CLK, CLR, WRT_EN;                         //clock, clear, write enable signals respectively
    reg [3:0] WR_ADR, RD_ADR1, RD_ADR2;           //4-bit write, read1, read2 addresses respectively
    
    integer I = 0, J = 0;                         //integer values for use in 'for' loops
    
    REG_FILE RGB (.REG_BIN(MEM_TB_IN),            //register file input
                  .REG_BOUT1(MEM_TB_OUT1),        //register file output 1
                  .REG_BOUT2(MEM_TB_OUT2),        //register file output 2
                  .REG_BCLK(CLK),                 //clock signal
                  .CLR(CLR),                      //clear signal (active-low)
                  .WR_EN(WRT_EN),                 //write enable signal
                  .WR_ADDR(WR_ADR),               //write address
                  .RD_ADDR1(RD_ADR1),
                  .RD_ADDR2(RD_ADR2));
                    
    initial begin
        $monitor($time,"CLR = %b, CLK = %b, WR_EN = %b, WR_ADR = %d, RD_ADR1 = %d, RD_ADR2 = %d, MEM_TB_OUT1 = %d, MEM_TB_OUT2 = %d, MEM_TB_IN = %d",
                 CLR, CLK, WRT_EN, WR_ADR, RD_ADR1, RD_ADR2, MEM_TB_OUT1, MEM_TB_OUT2, MEM_TB_IN);
    end
    initial begin
        WRT_EN = 1'b0;
        RD_ADR1 <= 4'b0000;
        RD_ADR2 <= 4'b0000;
        #2 CLR = 1'b0;
        #5 CLR = 1'b1;
    end
    initial begin
        #2 CLK = 1'b0;
        #8;
        forever begin
            #5 CLK = ~CLK;
        end
    end
    initial begin
        #18;
        WRT_EN = 1'b1;
        for(I = 0; I < 16; I = I + 1)begin
             WR_ADR = I;
             J = (J + 5000);
             MEM_TB_IN = J;
             #10;
        end
        #1;
        WRT_EN = 1'b0;
        WR_ADR = 4'b0000;
    end
    initial begin
        #190;
            RD_ADR1 <= 4'b0000;
            RD_ADR2 <= 4'b1000;
        for(I = 0; I < 8; I = I + 1)begin
            RD_ADR1 <= I;
            RD_ADR2 <= (I + 8);
            #10;          
        end
    end
    initial begin
        #300 $finish;
    end
endmodule
