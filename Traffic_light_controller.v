`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2026 21:51:20
// Design Name: 
// Module Name: Traffic_light_controller
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


module TFC(
input CLOCK,
input CLEAR,
input X,
output reg [1:0] HWY,
output reg [1:0] CNTRY
);

// Light Encoding
localparam RED = 2'd0;
localparam YELLOW = 2'd1;
localparam GREEN = 2'd2;

// State Encoding
localparam S0 = 3'd0, // HWY GREEN, CNTRY RED
S1 = 3'd1, // HWY YELLOW, CNTRY RED
S2 = 3'd2, // HWY RED, CNTRY RED
S3 = 3'd3, // HWY RED, CNTRY GREEN
S4 = 3'd4; // HWY RED, CNTRY YELLOW

// Delay Values
localparam Y2RDELAY = 3;
localparam R2GDELAY = 2;

// Registers
reg [2:0] STATE, NEXT_STATE;
reg [2:0] count;

// STATE REGISTER + COUNTER
always @(posedge CLOCK or posedge CLEAR)
begin
if (CLEAR) begin
STATE <= S0;
count <= 0;
end
else begin
STATE <= NEXT_STATE;

    // Reset counter when state changes
    if (STATE != NEXT_STATE)
        count <= 0;

    // Counter active only in delay states
    else if (STATE == S1 || STATE == S2 || STATE == S4)
        count <= count + 1;
end

end

// NEXT STATE LOGIC
always @(*)
begin
case (STATE)

    S0: begin
        if (X)
            NEXT_STATE = S1;
        else
            NEXT_STATE = S0;
    end

    S1: begin
        if (count >= Y2RDELAY)
            NEXT_STATE = S2;
        else
            NEXT_STATE = S1;
    end

    S2: begin
        if (count >= R2GDELAY)
            NEXT_STATE = S3;
        else
            NEXT_STATE = S2;
    end

    S3: begin
        if (!X)
            NEXT_STATE = S4;
        else
            NEXT_STATE = S3;
    end

    S4: begin
        if (count >= Y2RDELAY)
            NEXT_STATE = S0;
        else
            NEXT_STATE = S4;
    end

    default: NEXT_STATE = S0;

endcase

end

// OUTPUT LOGIC (MOORE MACHINE)
always @(*)
begin
case (STATE)

    S0: begin
        HWY   = GREEN;
        CNTRY = RED;
    end

    S1: begin
        HWY   = YELLOW;
        CNTRY = RED;
    end

    S2: begin
        HWY   = RED;
        CNTRY = RED;
    end

    S3: begin
        HWY   = RED;
        CNTRY = GREEN;
    end

    S4: begin
        HWY   = RED;
        CNTRY = YELLOW;
    end

    default: begin
        HWY   = GREEN;
        CNTRY = RED;
    end

endcase

end

endmodule
