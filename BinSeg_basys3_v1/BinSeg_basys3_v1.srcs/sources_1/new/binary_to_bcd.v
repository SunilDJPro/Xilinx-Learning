module binary_to_bcd(
    input [13:0] binary,
    output reg [15:0] bcd,
    output reg overflow
);

    integer i;
    
    always @(binary) begin
        // First check if input is greater than 9999 (decimal)
        if (binary > 14'd9999) begin
            overflow = 1;
            bcd = 16'h0000; // Clear BCD when in overflow
        end else begin
            overflow = 0;
            bcd = 0;
            
            for (i = 13; i >= 0; i = i - 1) begin
                // Add 3 to each BCD digit if it is greater than 4
                if (bcd[3:0] > 4) bcd[3:0] = bcd[3:0] + 3;
                if (bcd[7:4] > 4) bcd[7:4] = bcd[7:4] + 3;
                if (bcd[11:8] > 4) bcd[11:8] = bcd[11:8] + 3;
                if (bcd[15:12] > 4) bcd[15:12] = bcd[15:12] + 3;
                
                // Shift left one position
                bcd = {bcd[14:0], binary[i]};
            end
        end
    end
endmodule
