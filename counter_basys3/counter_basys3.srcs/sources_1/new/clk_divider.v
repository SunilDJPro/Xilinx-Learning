module clk_divider(
    input clk,          // 100MHz input clock
    input reset,        // Reset signal
    output reg slow_clk // 1Hz output clock
);

    reg [31:0] counter = 0;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            slow_clk <= 0;
        end
        else begin
            if (counter == 49_999_999) begin  // 50M cycles for 1Hz (100MHz/2)
                counter <= 0;
                slow_clk <= ~slow_clk;
            end
            else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
