`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2024 08:20:08 PM
// Design Name: 
// Module Name: half_adder_gate_level
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


module half_adder_gate_level(
    input a,
    input b,
    output sum,
    output carry
    );
    
    xor (sum, a, b);
    and (carry, a, b); 
    
endmodule
