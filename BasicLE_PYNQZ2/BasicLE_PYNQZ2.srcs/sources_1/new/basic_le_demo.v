

module basic_le_demo (
    input wire clk,
    input wire reset,
    input wire [3:0] sw,
    output wire [3:0] led
);


    wire comb_out; // Combinational Logic - LUT resources
    assign comb_out = (sw[0] & sw[1]) | (sw[2] & sw[3]);
    
    reg [3:0] counter = 4'b0000; // Srquential Logic - LUT + FlipFlop resources
    reg toggle_out = 1'b0; // Simple counter that uses both the LUT and FF in a LE
    
    reg [24:0] clk_divider = 25'b0;
    wire slow_clk = clk_divider[24]; // 25-bit register used to as clock divider by just capturing the MSB
    
    always @(posedge clk) begin // clk
        if (reset) begin
            clk_divider <= 25'b0;
        end else begin
            clk_divider <= clk_divider + 1'b1;
        end
    end
    
    always @(posedge slow_clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
            toggle_out <= 1'b0;
         end else begin
            
            if (sw[0]) begin // counts SW0
                counter <= counter + 1'b1;
            end
            
            if (counter == 4'b1111) begin  
                toggle_out <= ~toggle_out;
            end
         end
     end
     
     
     reg [1:0] pattern_selector;
     reg [3:0] pattern_output;
     
     always @(*) begin // LUT as small memory / LUT
        pattern_selector = sw[3:2];
        case (pattern_selector)
            2'b00: pattern_output = 4'b0101; // Alternating pattern
            2'b01: pattern_output = 4'b1100; // Half and Half
            2'b10: pattern_output = 4'b1010; // Another pattern
            2'b11: pattern_output = 4'b1111; // All on
        endcase
     end
     
     wire [1:0] sum;
     assign sum = sw[1:0] + sw[3:2]; // carry chain 
     
     assign led[0] = comb_out;
     assign led[1] = toggle_out;
     assign led[2] = pattern_output[0];
     assign led[3] = sum[1];
     
     
     (* KEEP = "TRUE" *) wire _keep_comb_out = comb_out;
     (* KEEP = "TRUE" *) wire _keep_toggle_out = toggle_out;
     (* KEEP = "TRUE" *) wire _keep_pattern = pattern_output[0];
     (* KEEP = "TRUE" *) wire _keep_sum = sum[1];
     

endmodule    