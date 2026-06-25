module mux21 (
    input wire [31:0] a,b,
    input wire s,
    output wire [31:0] out
);

assign out = s ? a : b;
endmodule 

module adder (
    input wire [31:0] a,b,
    output wire [31:0] sum
); 
    assign sum = a+b;
endmodule