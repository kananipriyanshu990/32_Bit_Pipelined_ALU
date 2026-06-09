//////////////////////////////////////////////////////////////////////////////////
// Module Name: P_REGISTER
// Project Name: 32_BIT_PIPELINED_ALU
// Module Creation Date: 27-05-2026
// Modification Date: none
//////////////////////////////////////////////////////////////////////////////////

module P_REGISTER(P_REG_IN,                     //register input
                  P_CLK,                        //input clock signal
                  P_RST,                        //input reset signal 
                  P_REG_OUT);                   //register output                      
    input [31:0]P_REG_IN;                //width association with register input
    input P_CLK, P_RST;                         
    output reg [31:0]P_REG_OUT;          //width association with register output
    always @(posedge P_CLK) begin               //triggered at positive clock edge
        if(P_RST == 1'b0) begin                 //synchronous active-low reset
            P_REG_OUT <= 0;
        end
        else begin 
            P_REG_OUT <= P_REG_IN;
        end 
    end
endmodule
