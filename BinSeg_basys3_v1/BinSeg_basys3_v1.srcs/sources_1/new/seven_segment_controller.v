module seven_segment_controller(
    input clk,
    input [15:0] bcd,
    input overflow,
    output reg [6:0] segments,
    output reg [3:0] digit_sel
);

    reg [1:0] digit_count;
    reg [16:0] refresh_counter;
    reg [3:0] current_digit;
    
    // 100Hz refresh rate (adjust counter based on actual clock frequency)
    parameter REFRESH_RATE = 100000; // For 100MHz clock
    
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
        if (refresh_counter >= REFRESH_RATE) begin
            refresh_counter <= 0;
            digit_count <= digit_count + 1;
        end
    end
    
    // Digit selection logic
    always @(*) begin
        case(digit_count)
            2'b00: begin
                digit_sel = 4'b1110;
                current_digit = bcd[3:0];
            end
            2'b01: begin
                digit_sel = 4'b1101;
                current_digit = bcd[7:4];
            end
            2'b10: begin
                digit_sel = 4'b1011;
                current_digit = bcd[11:8];
            end
            2'b11: begin
                digit_sel = 4'b0111;
                current_digit = bcd[15:12];
            end
            default: begin
                digit_sel = 4'b1111;
                current_digit = 4'b0000;
            end
        endcase
        
        // 7-segment encoding
        if (overflow) begin
            segments = 7'b0111111; // "-" using middle segment (G) [active low]
        end else begin
            case(current_digit)
                4'h0: segments = 7'b1000000;
                4'h1: segments = 7'b1111001;
                4'h2: segments = 7'b0100100;
                4'h3: segments = 7'b0110000;
                4'h4: segments = 7'b0011001;
                4'h5: segments = 7'b0010010;
                4'h6: segments = 7'b0000010;
                4'h7: segments = 7'b1111000;
                4'h8: segments = 7'b0000000;
                4'h9: segments = 7'b0010000;
                default: segments = 7'b1111111;
            endcase
        end
    end
endmodule