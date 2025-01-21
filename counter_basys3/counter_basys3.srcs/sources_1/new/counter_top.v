module top(
    input clk,              // 100MHz system clock
    input reset,            // Reset button
    output [6:0] seg,       // 7-segment segments
    output [3:0] an,        // 7-segment digit select
    output [15:0] led       // LEDs for binary display
);

    // Internal signals
    wire slow_clk;
    wire [13:0] count;  // 14-bit counter
    wire [3:0] thousands, hundreds, tens, ones;
    
    // Clock divider instantiation
    clk_divider clk_div (
        .clk(clk),
        .reset(reset),
        .slow_clk(slow_clk)
    );
    
    // Counter instantiation
    counter counter_inst (
        .clk(slow_clk),
        .reset(reset),
        .count(count)
    );
    
    // Binary to BCD converter instantiation
    bin2bcd bin2bcd_inst (
        .binary(count),
        .thousands(thousands),
        .hundreds(hundreds),
        .tens(tens),
        .ones(ones)
    );
    
    // Display controller instantiation
    display_ctrl display_inst (
        .clk(clk),
        .reset(reset),
        .thousands(thousands),
        .hundreds(hundreds),
        .tens(tens),
        .ones(ones),
        .an(an),
        .seg(seg)
    );
    
    // LED control - Directly connect the 14-bit counter to LEDs
    // LED[15:14] = 00 (unused)
    // LED[13:0] = binary counter value
    assign led = {2'b00, count};

endmodule