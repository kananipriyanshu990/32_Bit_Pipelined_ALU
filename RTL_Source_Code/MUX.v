//////////////////////////////////////////////////////////////////////////////////
// Module Name: MUX
// Project Name: 32_BIT_PIPELINED_ALU
// Module Creation Date: 27-05-2026
// Modification Date: none
//////////////////////////////////////////////////////////////////////////////////

module MUX #(parameter COUNT = 1)
            (MUX_OUT,
             MUX_IN_0,
             MUX_IN_1,
             SEL);
             output [(COUNT - 1):0] MUX_OUT;
             input [(COUNT - 1):0] MUX_IN_0;
             input [(COUNT - 1):0] MUX_IN_1;
             input SEL;
    assign MUX_OUT = (SEL == 1'b1) ? MUX_IN_1 : MUX_IN_0;
endmodule
