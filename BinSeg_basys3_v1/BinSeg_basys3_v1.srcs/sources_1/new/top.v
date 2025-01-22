module top(
    input clk,
    input [13:0] switches,    // V17 to U1
    output [13:0] leds,       // U16 to N3
    output [6:0] seg,
    output [3:0] an
);

    wire [15:0] bcd;
    wire overflow;
    
    // Pass through switch inputs to LEDs
    assign leds = switches;
    
    // Convert binary to BCD
    binary_to_bcd b2b(
        .binary(switches),
        .bcd(bcd),
        .overflow(overflow)
    );
    
    // Control 7-segment display
    seven_segment_controller ssc(
        .clk(clk),
        .bcd(bcd),
        .overflow(overflow),
        .segments(seg),
        .digit_sel(an)
    );

endmodule