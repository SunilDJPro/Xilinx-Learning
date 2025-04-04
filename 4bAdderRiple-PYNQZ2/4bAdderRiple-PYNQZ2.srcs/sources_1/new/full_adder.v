module full_adder (
    input wire a, 
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
    );
    
    assign sum = a ^ b ^ cin; // XOR
    
    assign cout = (a & b) | (cin & (a ^ b)); // AND, OR, AND + XOR
    
    
endmodule