`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: PIPELINED_ALU_TB
// Project Name: 32_BIT_PIPELINED_ALU
// Module Creation Date: 06-06-2026 
// Modification Date: 07-06-26 : added serial instructions and input data, edge case instructions and required input data
//                    08-06-26 : fixed the bugs: clear wire connections
//                                               write enable propagation delay correction
//                                               fixed instruction execution and input data coordination mismatch 
// Verification date: 08-06-2026
//////////////////////////////////////////////////////////////////////////////////

module PIPELINED_ALU_TB;

    logic [15:0] INSTRUCTION;
    logic [31:0] INPUT_DATA;
    logic VALID_IN;
    logic LOAD;
    logic CLR_EN;
    logic CLK;

    wire  CARRY_FLAG;
    wire  OVERFLOW_FLAG;
    wire  ZERO_FLAG;
    wire  NEGATIVE_FLAG;
    wire  GT;
    wire  LT;
    wire  EQ;

    wire [31:0]W1A,W1B,W2A,W2B,W3,W4,W5;
    
    wire [3:0]OPCODE;
    wire [3:0]RD1;
    wire [3:0]RD2;
    wire [3:0]WR;
    
    wire WR_EN;
    wire Load;

    integer i;
    localparam int VALUE = 45_928_429;

    // DUT
    PIPELINED_ALU ALU1(.w_stage1A(W1A),
                       .w_stage1B(W1B),
                       .w_stage2A(W2A),
                       .w_stage2B(W2B),
                       .w_stage3(W3),
                       .w_stage4(W4),
                       .w_stage5(W5),
                       .wr_en(WR_EN),
                       .opcode(OPCODE),
                       .rd_adr1(RD1),
                       .rd_adr2(RD2),
                       .wr_adr(WR),
                       .carry_flag (CARRY_FLAG),
                       .overflow_flag(OVERFLOW_FLAG),
                       .zero_flag(ZERO_FLAG),
                       .negative_flag(NEGATIVE_FLAG),
                       .gt(GT),
                       .lt(LT),
                       .eq(EQ),
                       .ext_input(INPUT_DATA),
                       .Instruction(INSTRUCTION),
                       .valid_in(VALID_IN),
                       .Load(LOAD),
                       .clr_enable(CLR_EN),
                       .clk(CLK));           

    // Clock generation
    initial begin
        CLK = 1'b0;
        forever #5 CLK = ~CLK;
    end

    // Waveform dump
    initial begin
        $dumpfile("pipelined_alu_tb.vcd");
        $dumpvars(0, PIPELINED_ALU_TB);
    end

    // Monitor statement
    initial begin
        $monitor("%0t | load=%b valid=%b clr=%b instr=%h in=%h OPC=%h RD1=%h RD2=%h WR=%h W1A=%h W1B=%h W2A=%h W2B=%h W3=%h W4=%h W5=%h wr_en=%b | C=%b O=%b Z=%b N=%b GT=%b LT=%b EQ=%b",
                 $time, LOAD, VALID_IN, CLR_EN, INSTRUCTION, INPUT_DATA, OPCODE, RD1, RD2, WR, W1A, W1B, W2A, W2B, W3, W4, W5, WR_EN,
                 CARRY_FLAG, OVERFLOW_FLAG, ZERO_FLAG, NEGATIVE_FLAG, GT, LT, EQ);
    end

    // Main stimulus
    initial begin
        // Initialize control Signals and input data
        VALID_IN   = 1'b0;
        LOAD       = 1'b0;
        CLR_EN     = 1'b0;
        INPUT_DATA = 32'h0000_0000;
        INSTRUCTION = 16'h0000;

        // Reset pulse
        #4  CLR_EN = 1'b1;
        #6  CLR_EN = 1'b0;

        // Phase 1: instruction and data set to load data into register file
        #2  LOAD = 1'b1;
            VALID_IN = 1'b1;

        for (i = 0; i < 19; i = i + 1) begin
            if (i == 0)
                INSTRUCTION = 16'h0000;
            else if ( i > 0 & i < 16 )
                INSTRUCTION = INSTRUCTION + 16'h0001;

            if (i >= 3)
                INPUT_DATA = INPUT_DATA + VALUE;
            #10;
        end

        LOAD     = 1'b0;
        VALID_IN = 1'b0;
        INSTRUCTION = 16'h0000;
        #40;

        // Phase 2: Directed instruction sequence
        #4;
            VALID_IN = 1'b1;
            INSTRUCTION = 16'h1018;
        #10 INSTRUCTION = 16'h2239;
        #10 INSTRUCTION = 16'h545A;
        #10 INSTRUCTION = 16'h367B;
        #10 INSTRUCTION = 16'h826C;
        #10 INSTRUCTION = 16'hA51D;
        #10 INSTRUCTION = 16'hF43E;
        #10 INSTRUCTION = 16'hD73F;
        #10 INSTRUCTION = 16'h9AC1;
        #10 INSTRUCTION = 16'h7BD2;
        #10 INSTRUCTION = 16'h4FE3;
            VALID_IN = 1'b0;

        // Reset pulse
        #5  CLR_EN = 1'b1;
        #6  CLR_EN = 1'b0;
        #30;

        // Phase 3: Set of edge case operations and data
        LOAD = 1'b1;
        #2;
            VALID_IN = 1'b1;
            INSTRUCTION = 16'h0000;
        #10 INSTRUCTION = 16'h0001;
        #10 INSTRUCTION = 16'h0002;
        #10 INSTRUCTION = 16'h0003; 
        #10 INSTRUCTION = 16'h0004; INPUT_DATA = 32'hFFFF_FFFF; 
        #10 INSTRUCTION = 16'h0005; INPUT_DATA = 32'h0000_0001; 
        #10                         INPUT_DATA = 32'h7FFF_FFFF; 
        #10                         INPUT_DATA = 32'h8000_0000; 
        #10                         INPUT_DATA = 32'd50;        
        #10                         INPUT_DATA = 32'd100;
            VALID_IN = 1'b0;        
        #10 LOAD = 1'b0;
            

        // Phase 4: Mixed sequence
        #21 VALID_IN = 1'b1;
            INSTRUCTION = 16'h2018;
        #10 INSTRUCTION = 16'h2119;
        #10 INSTRUCTION = 16'h221A;
        #10 INSTRUCTION = 16'h230B;
        #10 INSTRUCTION = 16'h322C;
        #10 INSTRUCTION = 16'hF00D;
        #10 INSTRUCTION = 16'hF54D;
        #10 INSTRUCTION = 16'hF45D;
        #10 INSTRUCTION = 16'hF55D;
            VALID_IN = 1'b0;

        // Reset pulse
        #30  CLR_EN = 1'b1;
        #5  CLR_EN = 1'b0;

        #40 $finish;                      // Finish after pipeline has drained
    end

endmodule

