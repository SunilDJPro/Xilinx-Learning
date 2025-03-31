`timescale 1ns / 1ps

module hsv_color_cycle(
    input wire clk,              // System clock
    input wire rst,              // Reset signal
    output wire led4_r,          // LD4 Red (PIN N15)
    output wire led4_g,          // LD4 Green (PIN G17)
    output wire led4_b,          // LD4 Blue (PIN L15)
    output wire led5_r,          // LD5 Red (PIN M15)
    output wire led5_g,          // LD5 Green (PIN L14)
    output wire led5_b           // LD5 Blue (PIN G14)
);

    // Parameters for clock division and HSV cycling
    parameter BASE_CLK_FREQ = 125_000_000;  // 100 MHz clock
    parameter COLOR_CYCLE_FREQ = 30;         // 500ms per color change (2Hz)
    parameter PWM_BITS = 8;                 // PWM resolution
    parameter PWM_FREQ = 500;               // PWM frequency in Hz
    
    // Calculate the divisors for counters
    parameter COLOR_CLK_DIV = BASE_CLK_FREQ / COLOR_CYCLE_FREQ;
    parameter COLOR_COUNTER_BITS = $clog2(COLOR_CLK_DIV);
    parameter PWM_CLK_DIV = BASE_CLK_FREQ / (PWM_FREQ * (2**PWM_BITS));
    parameter PWM_CLK_DIV_BITS = $clog2(PWM_CLK_DIV + 1);
    
    // Registers for basic operations
    reg [25:0] clk_div_counter = 0;             // Clock divider for color changing
    reg [7:0] hue_counter = 0;                  // 8-bit hue counter (0-255)
    reg [PWM_CLK_DIV_BITS-1:0] pwm_clk_div = 0; // PWM clock divider
    reg [PWM_BITS-1:0] pwm_counter = 0;         // PWM counter for LED brightness
    
    // Simplified RGB values (precomputed common patterns)
    reg [7:0] red1 = 0, green1 = 0, blue1 = 0;  // RGB values for LED4
    reg [7:0] red2 = 0, green2 = 0, blue2 = 0;  // RGB values for LED5
    
    // PWM output registers
    reg led4_r_pwm = 1, led4_g_pwm = 1, led4_b_pwm = 1;
    reg led5_r_pwm = 1, led5_g_pwm = 1, led5_b_pwm = 1;
    
    // Color cycle counter - controls hue progression
    always @(posedge clk) begin
        if (rst) begin
            clk_div_counter <= 0;
            hue_counter <= 0;
        end else begin
            if (clk_div_counter >= COLOR_CLK_DIV-1) begin
                clk_div_counter <= 0;
                hue_counter <= hue_counter + 1; // 8-bit counter wraps automatically
            end else begin
                clk_div_counter <= clk_div_counter + 1;
            end
        end
    end
    
    // Simplified HSV to RGB conversion using lookup approach
    // We use the 8-bit hue value (0-255) to determine color transition patterns
    always @(posedge clk) begin
        if (rst) begin
            red1 <= 0;
            green1 <= 0;
            blue1 <= 0;
            red2 <= 0;
            green2 <= 0;
            blue2 <= 0;
        end else begin
            // Simplified HSV to RGB conversion using 8-bit hue (0-255)
            // The conversion is based on which 1/6 segment of the color wheel we're in
            case (hue_counter[7:6]) // Top 2 bits determine the primary color
                2'b00: begin // Red to Yellow (R=255, G=0→255, B=0)
                    red1 <= 8'd255;
                    green1 <= {hue_counter[5:0], 2'b00}; // 0-252
                    blue1 <= 8'd0;
                end
                
                2'b01: begin // Yellow to Green (R=255→0, G=255, B=0)
                    red1 <= 8'd255 - {hue_counter[5:0], 2'b00};
                    green1 <= 8'd255;
                    blue1 <= 8'd0;
                end
                
                2'b10: begin // Green to Cyan (R=0, G=255, B=0→255)
                    red1 <= 8'd0;
                    green1 <= 8'd255;
                    blue1 <= {hue_counter[5:0], 2'b00};
                end
                
                2'b11: begin // Cyan to Blue (R=0, G=255→0, B=255)
                    red1 <= 8'd0;
                    green1 <= 8'd255 - {hue_counter[5:0], 2'b00};
                    blue1 <= 8'd255;
                end
                
                default: begin
                    red1 <= 8'd0;
                    green1 <= 8'd0;
                    blue1 <= 8'd0;
                end
            endcase
            
            // LED5 has a different phase (offset by 128 in 8-bit hue space = 180° in HSV)
            case (hue_counter[7:6] + 2'b10) // Offset by 180 degrees
                2'b00: begin // Red to Yellow
                    red2 <= 8'd255;
                    green2 <= {hue_counter[5:0], 2'b00};
                    blue2 <= 8'd0;
                end
                
                2'b01: begin // Yellow to Green
                    red2 <= 8'd255 - {hue_counter[5:0], 2'b00};
                    green2 <= 8'd255;
                    blue2 <= 8'd0;
                end
                
                2'b10: begin // Green to Cyan
                    red2 <= 8'd0;
                    green2 <= 8'd255;
                    blue2 <= {hue_counter[5:0], 2'b00};
                end
                
                2'b11: begin // Cyan to Blue
                    red2 <= 8'd0;
                    green2 <= 8'd255 - {hue_counter[5:0], 2'b00};
                    blue2 <= 8'd255;
                end
                
                default: begin
                    red2 <= 8'd0;
                    green2 <= 8'd0;
                    blue2 <= 8'd0;
                end
            endcase
        end
    end
    
    // PWM clock divider
    always @(posedge clk) begin
        if (rst) begin
            pwm_clk_div <= 0;
            pwm_counter <= 0;
        end else begin
            if (pwm_clk_div >= PWM_CLK_DIV-1) begin
                pwm_clk_div <= 0;
                pwm_counter <= pwm_counter + 1;
            end else begin
                pwm_clk_div <= pwm_clk_div + 1;
            end
        end
    end
    
    // LED PWM generation
    always @(posedge clk) begin
        // LEDs are active LOW on PYNQ Z2 due to transistor inverter
        led4_r_pwm <= (pwm_counter >= red1) ? 1'b1 : 1'b0;
        led4_g_pwm <= (pwm_counter >= green1) ? 1'b1 : 1'b0;
        led4_b_pwm <= (pwm_counter >= blue1) ? 1'b1 : 1'b0;
        
        led5_r_pwm <= (pwm_counter >= red2) ? 1'b1 : 1'b0;
        led5_g_pwm <= (pwm_counter >= green2) ? 1'b1 : 1'b0;
        led5_b_pwm <= (pwm_counter >= blue2) ? 1'b1 : 1'b0;
    end
    
    // Output assignments
    assign led4_r = led4_r_pwm;
    assign led4_g = led4_g_pwm;
    assign led4_b = led4_b_pwm;
    
    assign led5_r = led5_r_pwm;
    assign led5_g = led5_g_pwm;
    assign led5_b = led5_b_pwm;

endmodule