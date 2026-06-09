//////////////////////////////////////////////////////////////////////////////////
// Module Name: REG_FILE
// Project Name: 32_BIT_PIPELINED_ALU
// Module Creation Date: 27-05-2026
// Modification Date: none
//////////////////////////////////////////////////////////////////////////////////


module REG_FILE(output reg [31:0] REG_BOUT1,    //register output 1
                output reg [31:0] REG_BOUT2,    //register output 2
                input [31:0] REG_BIN,           //register input
                input [3:0] RD_ADDR1,           //read address 1
                input [3:0] RD_ADDR2,           //read address 2
                input [3:0] WR_ADDR,            //write address
                input WR_EN,                    //write enable
                input REG_BCLK,                 //clock supplied to register file
                input CLR);                     //register clear signal (active low)
    integer INDEX_DEPTH = 0;
    integer INDEX_WIDTH = 0;
    reg [31:0] MEM_B [15:0];
    
    always @(posedge REG_BCLK)begin
        if(CLR == 1'b0)begin                    //synchronous active-low clear
            for(INDEX_DEPTH = 0; INDEX_DEPTH < 16; INDEX_DEPTH = INDEX_DEPTH + 1)  //for loop writes zero to the whole memory unit
            begin
                MEM_B [INDEX_DEPTH] <= 32'h00000000;
            end
        end 
        else if(WR_EN == 1'b1) begin            //check whether memory write is enabled 
            MEM_B[WR_ADDR] <= REG_BIN;
        end
    end  
    always @(*)begin                            //make data at read addresses available as soon as read addresse(s) change 
        REG_BOUT1 = MEM_B[RD_ADDR1];
        REG_BOUT2 = MEM_B[RD_ADDR2];       
    end       
endmodule
