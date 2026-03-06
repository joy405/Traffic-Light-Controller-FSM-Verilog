`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2026 21:58:32
// Design Name: 
// Module Name: TFC_testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TFC_testbench(

    );
    reg CLOCK;
reg CLEAR;
reg X;

wire [1:0] HWY;
wire [1:0] CNTRY;

// DUT
TFC uut (
.CLOCK(CLOCK),
.CLEAR(CLEAR),
.X(X),
.HWY(HWY),
.CNTRY(CNTRY)
);

// Clock generation (10ns period)
always #5 CLOCK = ~CLOCK;

// Stimulus
initial begin

// Initialize
CLOCK = 0;
CLEAR = 1;
X = 0;

// Reset active
#20;
CLEAR = 0;

// Stay in S0 for some time
#40;

// Car arrives on country road
X = 1;

// Wait for full FSM cycle
#200;

// Car leaves
X = 0;

#200;

// Another car arrives
X = 1;

#200;

$finish;

end
endmodule
