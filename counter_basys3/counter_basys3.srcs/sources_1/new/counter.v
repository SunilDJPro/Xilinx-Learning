module counter(
    input clk,              // 1Hz clock input
    input reset,            // Reset signal
    output reg [13:0] count // Counter output (0-9999)
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 0;
        else begin
            if (count == 9999)
                count <= 9999;  // Stop at 9999
            else
                count <= count + 1;
        end
    end

endmodule