`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2024 06:21:22 PM
// Design Name: 
// Module Name: TB_HA_data
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


module TB_HA_data();

reg a,b; 
wire s,c;
half_adder_data d0 (a, b, s, c);
initial begin
#10 a = 0; b = 0;
#10 a = 0; b = 1;
#10 a = 1; b = 0;
#10 a = 1; b = 1;
#10 a = 0; b = 0;
#10 $finish;


end
endmodule
