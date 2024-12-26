`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2024 07:55:41 PM
// Design Name: 
// Module Name: half_adder_data
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


module half_adder_data(
    input a,
    input b,
    output s,
    output c
    );
    
    //assign {c, s} = a + b; 
   assign s = a ^ b;
   assign c = a & b;
endmodule
