`timescale 1ns / 1ps

module pynq_z2_top(
    input  wire clk,   // 125 MHz system clock
    input  wire rst,   // Reset button (Btn0)
    
    // RGB LEDs
    output wire led4_r,
    output wire led4_g,
    output wire led4_b,
    output wire led5_r,
    output wire led5_g,
    output wire led5_b
);

    // Instantiate the HSV color cycle module
    hsv_color_cycle hsv_cycler (
        .clk(clk),
        .rst(rst),
        .led4_r(led4_r),
        .led4_g(led4_g),
        .led4_b(led4_b),
        .led5_r(led5_r),
        .led5_g(led5_g),
        .led5_b(led5_b)
    );

endmodule