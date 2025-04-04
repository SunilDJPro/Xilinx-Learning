// Top module for 4-bit Ripple Carry Adder implementation on PYNQ-Z2
module ripple_adder_top (
    input wire clk,        // System clock
    input wire reset,      // Reset button
    input wire [3:0] sw,   // Switches for input selection
    output wire [3:0] led  // LEDs to display output
);
    
    // Input registers
    reg [3:0] a_reg = 4'b0000;
    reg [3:0] b_reg = 4'b0000;
    reg cin_reg = 1'b0;
    
    // Control signals
    reg input_select = 1'b0;  // 0 for input A, 1 for input B
    
    // Output from the adder
    wire [3:0] sum;
    wire cout;
    
    // Ripple Carry Adder instance
    ripple_carry_adder rca (
        .a(a_reg),
        .b(b_reg),
        .cin(cin_reg),
        .sum(sum),
        .cout(cout)
    );
    
    // Debounce counter for button press
    reg [19:0] debounce_counter = 20'h00000;
    
    // Process input selection and capture input values
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers
            a_reg <= 4'b0000;
            b_reg <= 4'b0000;
            cin_reg <= 1'b0;
            input_select <= 1'b0;
            debounce_counter <= 20'h00000;
        end
        else begin
            // Debounce counter for button press
            if (debounce_counter > 0) begin
                debounce_counter <= debounce_counter - 1;
            end
            
            // Handle input mode
            if (sw[3] && debounce_counter == 0) begin
                // SW[3] acts as a mode switch when pressed
                input_select <= ~input_select;
                debounce_counter <= 20'hFFFFF; // Set debounce delay
            end
            
            // Capture inputs based on selection
            if (!input_select) begin
                // Input A mode
                a_reg <= {sw[3], sw[2], sw[1], sw[0]};
            end
            else begin
                // Input B mode
                b_reg <= {sw[3], sw[2], sw[1], sw[0]};
                // SW[0] also controls carry input in B mode
                cin_reg <= sw[0];
            end
        end
    end
    
    // Output mapping - Depends on the switch state
    // If input_select = 0, show sum
    // If input_select = 1, show carry out on LED[3] and inputs on lower LEDs
    assign led = input_select ? {cout, b_reg[2:0]} : sum;
    
endmodule