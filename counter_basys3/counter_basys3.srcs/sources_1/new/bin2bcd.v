module bin2bcd(
    input [13:0] binary,          // Binary input (0-9999)
    output reg [3:0] thousands,   // BCD thousands digit
    output reg [3:0] hundreds,    // BCD hundreds digit
    output reg [3:0] tens,        // BCD tens digit
    output reg [3:0] ones         // BCD ones digit
);

    integer i;
    
    always @(binary) begin
        // Clear digits
        thousands = 4'd0;
        hundreds = 4'd0;
        tens = 4'd0;
        ones = 4'd0;
        
        // Double dabble algorithm
        for (i = 13; i >= 0; i = i - 1) begin
            // Add 3 to columns >= 5
            if (thousands >= 5)
                thousands = thousands + 3;
            if (hundreds >= 5)
                hundreds = hundreds + 3;
            if (tens >= 5)
                tens = tens + 3;
            if (ones >= 5)
                ones = ones + 3;
                
            // Shift left
            thousands = thousands << 1;
            thousands[0] = hundreds[3];
            hundreds = hundreds << 1;
            hundreds[0] = tens[3];
            tens = tens << 1;
            tens[0] = ones[3];
            ones = ones << 1;
            ones[0] = binary[i];
        end
    end

endmodule