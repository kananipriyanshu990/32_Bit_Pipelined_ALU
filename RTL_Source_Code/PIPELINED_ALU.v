//////////////////////////////////////////////////////////////////////////////////
// Module Name: PIPELINED_ALU
// Project Name: 32_BIT_PIPELINED_ALU
// Module Creation Date: 04-06-2026
// Modification Date: 05-06-2026 : modified internal wires as output for analysis and debugging 
//////////////////////////////////////////////////////////////////////////////////

module PIPELINED_ALU(output wire [31:0]w_stage5,          //32-bit bus between multiplexer and register file input
                     output wire [31:0]w_stage4,          //32-bit bus between register_stage_2 and multiplexer
                     output wire [31:0]w_stage3,          //32-bit bus between ALU_OUT and register_stage_2
                     output wire [31:0]w_stage2A,         //32-bit bus between register_stage1A and ALU_IN1
                     output wire [31:0]w_stage2B,         //32-bit bus between register_stage1B and ALU_IN2
                     output wire [31:0]w_stage1A,         //32-bit bus between register file out 1 and register_stage1A
                     output wire [31:0]w_stage1B,         //32-bit bus between register file out 1 and register_stage1B
                     output wire [3:0]opcode,             //4-bit opcode bus 
                     output wire [3:0]rd_adr1,            //4-bit read address 1 bus
                     output wire [3:0]rd_adr2,            //4-bit read address 2 bus
                     output wire [3:0]wr_adr,             //4-bit write address bus
                     output wire wr_en,                   //write enable signal
                     output wire carry_flag,              //carry flag signal
                     output wire overflow_flag,           //overflow flag signal
                     output wire zero_flag,               //zero flag signal
                     output wire negative_flag,           //negative flag signal
                     output wire gt,                      //flag indicating IN1 > IN2
                     output wire lt,                      //flag indicating IN1 < IN2
                     output wire eq,                      //flag indicating IN1 = IN2
                     input [31:0] ext_input,              //32 bit input for loading into register file
                     input [15:0] Instruction,            //16-bit instruction
                     input valid_in,                      //input signal indicating the input instructions to be valid 
                     input Load,                          //load signal that selects between ALU output and xternal input to write into register file 
                     input clr_enable,                    //clear enable signal
                     input clk);                          //clock signal
    
    CONTROL_UNIT CU (.OPCODE(opcode),
                     .RD_ADDR1(rd_adr1),
                     .RD_ADDR2(rd_adr2),
                     .WR_ADDR(wr_adr),
                     .WR_EN(wr_en),
                     .CLR(clr),
                     .Operation(Instruction),
                     .clr_en(clr_enable),
                     .valid_in(valid_in),
                     .CLK(clk));
    
    ALU_32_BIT ALU(.ALU_OUT(w_stage3),
                   .Carry_flag(carry_flag),
                   .Overflow_flag(overflow_flag),
                   .Zero_flag(zero_flag),
                   .Negative_flag(negative_flag),
                   .GT(gt),
                   .LT(lt),
                   .EQ(eq),
                   .ALU_IN1(w_stage2A),
                   .ALU_IN2(w_stage2B),
                   .OPCODE(opcode));
    
    MUX #(32)MX(.MUX_OUT(w_stage5),
                .MUX_IN_0(w_stage4),
                .MUX_IN_1(ext_input),
                .SEL(Load));
    
    REG_FILE RF(.REG_BOUT1(w_stage1A),
                .REG_BOUT2(w_stage1B),
                .REG_BIN(w_stage5),
                .RD_ADDR1(rd_adr1),
                .RD_ADDR2(rd_adr2),
                .WR_ADDR(wr_adr),
                .WR_EN(wr_en),
                .REG_BCLK(clk),
                .CLR(clr));
    
    P_REGISTER PR1(.P_REG_OUT(w_stage2A),
                        .P_REG_IN(w_stage1A),
                        .P_CLK(clk),
                        .P_RST(clr));
    
    P_REGISTER PR2(.P_REG_OUT(w_stage2B),
                        .P_REG_IN(w_stage1B),
                        .P_CLK(clk),
                        .P_RST(clr));
    
    P_REGISTER PR3(.P_REG_OUT(w_stage4),
                        .P_REG_IN(w_stage3),
                        .P_CLK(clk),
                        .P_RST(clr));
    
endmodule
