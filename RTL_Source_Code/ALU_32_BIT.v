//////////////////////////////////////////////////////////////////////////////////
// Module Name: ALU_32_BIT
// Project Name: 32_BIT_PIPELINED_ALU
// Module Creation Date: 29-05-2026
// Modification Date: 30-06-26 : made correction in flag generation logic
//                               restricted overflow flag to generate only during (signed) ADD/SUB opearation 
//////////////////////////////////////////////////////////////////////////////////


// Macro Definitions
`define BUFF_IN1 4'b0000             //Pass 32 bits of ALU_IN1 as it is
`define BUFF_IN2 4'b0001             //Pass 32 bits of ALU_IN2 as it is
`define ADD 4'b0010                  //Perform ALU_IN1 + ALU_IN2
`define SUB 4'b0011                  //Perform ALU_IN1 - ALU_IN2
`define SHR_IN1 4'b0100              //Shift ALU_IN1 right by 1 bit without sign extension (divide by 2)
`define SHR_IN2 4'b0101              //Shift ALU_IN2 right by 1 bit without sign extension (divide by 2)
`define AR_SHR_IN1 4'b0110           //Shift ALU_IN1 right by 1 bit with sign extension (divide by 2)
`define AR_SHR_IN2 4'b0111           //Shift ALU_IN2 right by 1 bit with sign extension (divide by 2)
`define SHL_IN1 4'b1000              //Shift ALU_IN1 left by 1 bit (multiply by 2)
`define SHL_IN2 4'b1001              //Shift ALU_IN2 left by 1 bit (multiply by 2)
`define AND 4'b1010                  //Bitwise AND of A and B 
`define OR 4'b1011                   //Bitwise OR of A and B
`define XOR 4'b1100                  //Bitwise XOR of A and B
`define NOT_IN1 4'b1101              //Bitwise inversion of ALU_IN1
`define NOT_IN2 4'b1110              //Bitwise inversion of ALU_IN2
`define CMP 4'b1111                  //Compare ALU_IN1 and ALU_IN2 and generate flags accordingly (GT,LT,EQ)
  

module ALU_32_BIT(output reg [31:0]ALU_OUT,        //32-bit output of ALU
                  output reg Carry_flag,           //Flag indicating final carry/borrow flag for unsigned arithmetic overflow
                  output reg Overflow_flag,        //Flag indicating signed arithmetic overflow 
                  output wire Zero_flag,           //Flag indicating the Final result is ZERO
                  output wire Negative_flag,       //Flag indicating the MSB of final Result is 1
                  output wire GT,                  //Flag indicating ALU_IN1 > ALU_IN2
                  output wire LT,                  //Flag indicating ALU_IN1 < ALU_IN2
                  output wire EQ,                  //Flag indicating ALU_IN1 = ALU_IN2
                  input [31:0] ALU_IN1,            //First 32-bit Input 
                  input [31:0] ALU_IN2,            //Second 32-bit Input
                  input [3:0] OPCODE);             //Operation code Input
    always @(*)begin
        case(OPCODE)
            `BUFF_IN1 : {Carry_flag, ALU_OUT} <= {1'b0, ALU_IN1};
            `BUFF_IN2 : {Carry_flag, ALU_OUT} <= {1'b0, ALU_IN2};
            `ADD : {Carry_flag, ALU_OUT} <= ALU_IN1 + ALU_IN2;
            `SUB : {Carry_flag, ALU_OUT} <= ALU_IN1 - ALU_IN2;
            `SHR_IN1 : {Carry_flag, ALU_OUT} <= {1'b0, ALU_IN1 >> 1};
            `SHR_IN2 : {Carry_flag, ALU_OUT} <= {1'b0, ALU_IN2 >> 1};
            `AR_SHR_IN1 : {Carry_flag, ALU_OUT} <= {1'b0, ALU_IN1 >>> 1};
            `AR_SHR_IN2 : {Carry_flag, ALU_OUT} <= {1'b0, ALU_IN2 >>> 1};
            `SHL_IN1 : {Carry_flag, ALU_OUT} <= {1'b0, ALU_IN1 << 1};
            `SHL_IN2 : {Carry_flag, ALU_OUT} <= {1'b0, ALU_IN2 << 1};
            `AND : {Carry_flag, ALU_OUT} <= {1'b0, ALU_IN1 & ALU_IN2};
            `OR : {Carry_flag, ALU_OUT} <= {1'b0, ALU_IN1 | ALU_IN2};
            `XOR : {Carry_flag, ALU_OUT} <= {1'b0, ALU_IN1 ^ ALU_IN2};
            `NOT_IN1 : {Carry_flag, ALU_OUT} <= {1'b0, ~ALU_IN1};
            `NOT_IN2 : {Carry_flag, ALU_OUT} <= {1'b0, ~ALU_IN2};
            `CMP :{Carry_flag, ALU_OUT} <= {1'b0, 32'b0};
            default : {Carry_flag, ALU_OUT} <= {1'b0, 32'b0};
        endcase
    end
    always @(*)begin
        if(OPCODE == 4'b0010 | OPCODE == 4'b0011)begin                                     //overflow flag effective only when (signed) ADD or SUB opeartion is being performed
            Overflow_flag = (((ALU_IN1[31] == ALU_IN2[31]) && (ALU_OUT[31] != ALU_IN1[31]) && (ALU_OUT[31] != ALU_IN2[31])) ? 1'b1 : 1'b0);
        end
        else begin
            Overflow_flag = 1'b0;
        end
    end
    assign Zero_flag = ((ALU_OUT == 32'b0) ? 1'b1 : 1'b0);                                  //zero flag generation logic
    assign Negative_flag = ALU_OUT[31];                                                     //negative flag generation logic
    assign GT = ((OPCODE == 4'b1111) ? ((ALU_IN1 > ALU_IN2) ? 1'b1 : 1'b0) : 1'b0);         //'IN1 > IN2' flag generation logic
    assign LT = ((OPCODE == 4'b1111) ? ((ALU_IN1 < ALU_IN2) ? 1'b1 : 1'b0) : 1'b0);         //'IN1 < IN2' flag generation logic
    assign EQ = ((OPCODE == 4'b1111) ? ((ALU_IN1 == ALU_IN2) ? 1'b1 : 1'b0) : 1'b0);        //'IN1 = IN2' flag generation logic
endmodule
