module display_ctrl(
    input clk,                  // 100MHz clock
    input reset,                // Reset signal
    input [3:0] thousands,      // BCD thousands
    input [3:0] hundreds,       // BCD hundreds
    input [3:0] tens,          // BCD tens
    input [3:0] ones,          // BCD ones
    output reg [3:0] an,       // Digit select signals
    output reg [6:0] seg       // Segment signals
);

    reg [16:0] refresh_counter = 0;  // Reduced size for faster switching
    reg [1:0] display_select = 0;
    reg [3:0] current_digit;
    
    // Refresh counter
    always @(posedge clk or posedge reset) begin
        if (reset)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end
    
    // Digit select counter
    always @(posedge clk or posedge reset) begin
        if (reset)
            display_select <= 0;
        else
            // Update display select every ~0.25ms (4kHz refresh rate)
            display_select <= refresh_counter[16:15];  // Use upper bits of counter
    end
    
    // Digit multiplexer
    always @* begin
        case(display_select)
            2'b00: begin
                current_digit = ones;        // Rightmost digit
                an = 4'b1110;
            end
            2'b01: begin
                current_digit = tens;        // Second from right
                an = 4'b1101;
            end
            2'b10: begin
                current_digit = hundreds;    // Second from left
                an = 4'b1011;
            end
            2'b11: begin
                current_digit = thousands;   // Leftmost digit
                an = 4'b0111;
            end
        endcase
    end
    
    // 7-segment decoder
    always @* begin
        case(current_digit)
            4'd0: seg = 7'b1000000;  // 0
            4'd1: seg = 7'b1111001;  // 1
            4'd2: seg = 7'b0100100;  // 2
            4'd3: seg = 7'b0110000;  // 3
            4'd4: seg = 7'b0011001;  // 4
            4'd5: seg = 7'b0010010;  // 5
            4'd6: seg = 7'b0000010;  // 6
            4'd7: seg = 7'b1111000;  // 7
            4'd8: seg = 7'b0000000;  // 8
            4'd9: seg = 7'b0010000;  // 9
            default: seg = 7'b1111111;
        endcase
    end

endmodule