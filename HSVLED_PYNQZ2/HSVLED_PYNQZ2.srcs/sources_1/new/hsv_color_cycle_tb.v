`timescale 1ns / 1ps

module hsv_color_cycle_tb();

    // Testbench signals
    reg clk;
    reg rst;
    wire led4_r, led4_g, led4_b;
    wire led5_r, led5_g, led5_b;

    // Instantiate the Unit Under Test (UUT)
    hsv_color_cycle #(
        .CLK_FREQ(125_000),    // Using a smaller value for simulation
        .COLOR_CYCLE_TIME(1)   // 1 second for simulation
    ) uut (
        .clk(clk),
        .rst(rst),
        .led4_r(led4_r),
        .led4_g(led4_g),
        .led4_b(led4_b),
        .led5_r(led5_r),
        .led5_g(led5_g),
        .led5_b(led5_b)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #4 clk = ~clk;  // 125 MHz
    end

    // Reset generation
    initial begin
        rst = 1;
        #100;
        rst = 0;
    end
    
    // Monitoring
    initial begin
        $monitor("Time=%t, LED4[RGB]=%b%b%b, LED5[RGB]=%b%b%b",
                 $time, led4_r, led4_g, led4_b, led5_r, led5_g, led5_b);
    end
    
    // Run simulation
    initial begin
        // Since we're using a smaller clock frequency for simulation,
        // run for a shorter time to see the effect
        #2_000_000;  // 2 ms simulation time
        $finish;
    end

endmodule