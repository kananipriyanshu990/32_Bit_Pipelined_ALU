//////////////////////////////////////////////////////////////////////////////////
// Module Name: CONTROL_UNIT
// Project Name: 32_BIT_PIPELINED_ALU
// Module Creation Date: 01-06-2026
// Modification Date: 02-06-26: reduced decoded instruction propagation stages by one level.
//                              doumented the module.
//////////////////////////////////////////////////////////////////////////////////


module CONTROL_UNIT(output reg [3:0]OPCODE,          //the decoded opcode for ALU
                    output reg [3:0]WR_ADDR,         //4-bit write address
                    output reg [3:0]RD_ADDR1,        //4-bit read address for ALU_IN1 value
                    output reg [3:0]RD_ADDR2,        //4-bit read address for ALU_IN2 value
                    output reg WR_EN,                //memory write enable signal
                    output reg CLR,                  //clear signal for clearing the memory and all the pipeline registers
                    input [15:0]Operation,           //complex 16-bit code that contains 4-bit write address, read addresses, opration code           //negative flag received from ALU
                    input clr_en,                    //external clear-enable signal
                    input valid_in,                  //external signal indicating input instructions to be valid
                    input CLK);                      //global clock input for synchronization
                    
    reg [3:0]op_stage[1:0];                          //2 series registers to propagate opcode
    reg [3:0]rd1_stage;                              //1 register to propagate read address 1
    reg [3:0]rd2_stage;                              //1 register to propagate read address 2
    reg [3:0]wr_stage[2:0];                          //3 series registers to propagate write address
    reg wr_en[2:0];
    reg Carry = 1'b0;                                //registers that store the flags generated from ALU 
    reg Overflow = 1'b0;                             //to propagate further with output or for analysis
    reg Zero = 1'b0;                                 //
    reg Negative = 1'b0;                             //
    
    wire [3:0]opcode;                                //4-bit buses
    wire [3:0]rd1;                                   //
    wire [3:0]rd2;                                   //
    wire [3:0]wr;                                    //
    
    assign opcode = Operation[15:12];                //operation/instruction decoding
    assign rd1 = Operation[11:8];                    //
    assign rd2 = Operation[7:4];                     //
    assign wr = Operation[3:0];                      //
    
    always @(*) begin                                
        CLR  = ~clr_en;                              //invert clear signal in output to make it active low
    end
    always @(posedge CLK) begin                      //synchronous write enable signal
        if (clr_en)
            wr_en[0] <= 1'b0;
        else
            wr_en[0] <= valid_in;
    end
    always @(posedge CLK) begin                      // series registers passing decoded instructions parallel to the data
            //stage 1: decode
            op_stage[0] <= opcode;
            rd1_stage <= rd1;
            rd2_stage <= rd2;
            wr_stage[0] <= wr;
            wr_en[1] <= wr_en[0];

            //stage 2: read addresses become effective, operands made available at register file's output
            op_stage[1] <= op_stage[0];
            RD_ADDR1 <= rd1_stage;
            RD_ADDR2 <= rd2_stage;
            wr_stage[1] <= wr_stage[0];
            wr_en[2] <= wr_en[1];

            //stage 3: opcode becomes effective, operation performed on operands available at ALU input
            OPCODE <= op_stage[1];
            wr_stage[2] <= wr_stage[1];
            WR_EN <= wr_en[2];                   //write enable signal made effective to begin writing into register file from next clock edge
            
            //stage 4: write address becomes effective, result is written into register file in next clock edge
            WR_ADDR <= wr_stage[2];
    end
    
    initial begin
        RD_ADDR1 = 4'b0000;
        RD_ADDR2 = 4'b0001;
        WR_ADDR = 4'b0000;
    end
    
endmodule
