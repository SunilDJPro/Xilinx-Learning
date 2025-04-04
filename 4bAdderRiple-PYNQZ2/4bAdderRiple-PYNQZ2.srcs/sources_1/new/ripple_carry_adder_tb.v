// Testbench for Ripple Carry Adder
`timescale 1ns / 1ps

module ripple_carry_adder_tb();
    // Testbench signals
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    wire [3:0] sum;
    wire cout;
    
    // Instantiate the ripple carry adder
    ripple_carry_adder dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
    
    // Test vectors and verification
    initial begin
        $display("Starting Ripple Carry Adder Testbench");
        $display("------------------------------------");
        $display("    A    +    B    + Cin =   Sum   : Cout");
        $display("------------------------------------");
        
        // Test case 1: Simple addition without carry
        a = 4'b0001; b = 4'b0010; cin = 0;
        #10;
        $display("  %b +  %b +   %b  =  %b :   %b  (Expected: 0011:0)", a, b, cin, sum, cout);
        
        // Test case 2: Addition with input carry
        a = 4'b0011; b = 4'b0100; cin = 1;
        #10;
        $display("  %b +  %b +   %b  =  %b :   %b  (Expected: 1000:0)", a, b, cin, sum, cout);
        
        // Test case 3: Addition with output carry
        a = 4'b1100; b = 4'b0100; cin = 0;
        #10;
        $display("  %b +  %b +   %b  =  %b :   %b  (Expected: 0000:1)", a, b, cin, sum, cout);
        
        // Test case 4: Maximum values
        a = 4'b1111; b = 4'b1111; cin = 1;
        #10;
        $display("  %b +  %b +   %b  =  %b :   %b  (Expected: 1111:1)", a, b, cin, sum, cout);
        
        // Test case 5: Random values
        a = 4'b1010; b = 4'b0101; cin = 0;
        #10;
        $display("  %b +  %b +   %b  =  %b :   %b  (Expected: 1111:0)", a, b, cin, sum, cout);
        
        // Add more test cases as needed
        
        $display("------------------------------------");
        $display("Testbench complete!");
        $finish;
    end
    
endmodule