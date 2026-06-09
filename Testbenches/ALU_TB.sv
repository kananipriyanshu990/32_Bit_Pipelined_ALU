`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: ALU_TB
// Project Name: 32_BIT_PIPELINED_ALU
// Module Creation Date: 31-05-2026
// Modification Date: none
// Verification date: 31-05-2026
////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module ALU_32_BIT_tb;
    logic [31:0] ALU_OUT, ALU_IN1, ALU_IN2;
    logic Carry_flag, Overflow_flag;
    wire Zero_flag, Negative_flag, GT, LT, EQ;
    logic [3:0]  OPCODE;

    ALU_32_BIT dut (.ALU_OUT(ALU_OUT),                      //32-bit output of ALU
                    .Carry_flag(Carry_flag),                //Flag indicating final carry/borrow flag for unsigned arithmetic overflow
                    .Overflow_flag(Overflow_flag),          //Flag indicating signed arithmetic overflow
                    .Zero_flag(Zero_flag),                  //Flag indicating the Final result is ZERO
                    .Negative_flag(Negative_flag),          //Flag indicating the MSB of final Result is 1
                    .GT(GT),                                //Flag indicating ALU_IN1 > ALU_IN2
                    .LT(LT),                                //Flag indicating ALU_IN1 < ALU_IN2
                    .EQ(EQ),                                //Flag indicating ALU_IN1 = ALU_IN2
                    .ALU_IN1(ALU_IN1),                      //First 32-bit Input bus
                    .ALU_IN2(ALU_IN2),                      //Second 32-bit Input bus
                    .OPCODE(OPCODE));                       //Opcode for operation 

    initial begin
        $monitor("t=%0t OP=%04b IN1=%08h IN2=%08h OUT=%08h CF=%b OF=%b ZF=%b NF=%b GT=%b LT=%b EQ=%b",
                 $time, OPCODE, ALU_IN1, ALU_IN2, ALU_OUT, Carry_flag, Overflow_flag,
                 Zero_flag, Negative_flag, GT, LT, EQ);

        // BUFFER operation
        ALU_IN1 = 32'hDEA0_BCAF; ALU_IN2 = 32'h0;         OPCODE = 4'b0000; #10;
        ALU_IN1 = 32'h0;         ALU_IN2 = 32'hCADE_BACE; OPCODE = 4'b0001; #10;

        // ADDITION operation
        ALU_IN1 = 32'h0000_0001; ALU_IN2 = 32'h0000_0001; OPCODE = 4'b0010; #10;
        ALU_IN1 = 32'hFFFF_FFFF; ALU_IN2 = 32'h0000_0001; OPCODE = 4'b0010; #10;
        ALU_IN1 = 32'h7FFF_FFFF; ALU_IN2 = 32'h0000_0001; OPCODE = 4'b0010; #10;

        // SUBTRACTION operation
        ALU_IN1 = 32'h0000_0005; ALU_IN2 = 32'h0000_0003; OPCODE = 4'b0011; #10;
        ALU_IN1 = 32'h0000_0000; ALU_IN2 = 32'h0000_0001; OPCODE = 4'b0011; #10;
        ALU_IN1 = 32'h8000_0000; ALU_IN2 = 32'h0000_0001; OPCODE = 4'b0011; #10;

        // SHIFT RIGHT operation
        ALU_IN1 = 32'hFFFF_FFFF; ALU_IN2 = 32'h0;         OPCODE = 4'b0100; #10;
        ALU_IN1 = 32'h0;         ALU_IN2 = 32'h8000_0000; OPCODE = 4'b0101; #10;

        // ARITHMETIC SHIFT RIGHT operation
        ALU_IN1 = 32'h8000_0000; ALU_IN2 = 32'h0;         OPCODE = 4'b0110; #10;
        ALU_IN1 = 32'h0;         ALU_IN2 = 32'h8000_0000; OPCODE = 4'b0111; #10;

        // SHIFT LEFT opeartion
        ALU_IN1 = 32'h0000_0001; ALU_IN2 = 32'h0;         OPCODE = 4'b1000; #10;
        ALU_IN1 = 32'h0;         ALU_IN2 = 32'h8000_0000; OPCODE = 4'b1001; #10;

        // AND opeartion
        ALU_IN1 = 32'hFFFF_FFFF; ALU_IN2 = 32'h0000_0000; OPCODE = 4'b1010; #10;
        ALU_IN1 = 32'hA540_A1B5; ALU_IN2 = 32'hFD0A_795B; OPCODE = 4'b1010; #10;

        // OR opeartion
        ALU_IN1 = 32'h0000_0000; ALU_IN2 = 32'h0000_0000; OPCODE = 4'b1011; #10;
        ALU_IN1 = 32'hAC06_D0B5; ALU_IN2 = 32'h510A_429A; OPCODE = 4'b1011; #10;

        // XOR operaation
        ALU_IN1 = 32'hFFFF_FFFF; ALU_IN2 = 32'hFFFF_FFFF; OPCODE = 4'b1100; #10;
        ALU_IN1 = 32'h157A_5108; ALU_IN2 = 32'h0000_0000; OPCODE = 4'b1100; #10;

        // NOT operation (inversion)
        ALU_IN1 = 32'h0000_0000; ALU_IN2 = 32'h0;         OPCODE = 4'b1101; #10;
        ALU_IN1 = 32'h0;         ALU_IN2 = 32'hFFFF_FFFF; OPCODE = 4'b1110; #10;

        // COMPARISION operation
        ALU_IN1 = 32'h0000_0005; ALU_IN2 = 32'h0000_0003; OPCODE = 4'b1111; #10;
        ALU_IN1 = 32'h0000_0003; ALU_IN2 = 32'h0000_0005; OPCODE = 4'b1111; #10;
        ALU_IN1 = 32'h0000_0005; ALU_IN2 = 32'h0000_0005; OPCODE = 4'b1111; #10;

        $finish;
    end
endmodule
