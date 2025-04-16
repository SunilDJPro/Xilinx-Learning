module dsp_multiplier (
    input wire clk,
    input wire rst,
    input wire [15:0] data_a,
    input wire [15:0] data_b,
    input wire start,
    output reg done,
    output wire [47:0] result
);


    reg [2:0] pipe_count;
    
    reg [15:0] data_a_reg, data_b_reg;
    
    wire [47:0] dsp_p;
    
    
    