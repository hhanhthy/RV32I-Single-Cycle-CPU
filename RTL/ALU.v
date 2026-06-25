module ALU (
    input wire [31:0] a,b, 
    input wire [3:0] ALU_operation, 
    output wire zero, 
    output reg [31:0] result
);
    wire [4:0] shamt = b[4:0]; //số bit shift
    always @(*) begin 
        case (ALU_operation)
            4'b0000: result = a&b; //AND
            4'b0001: result = a|b; //OR
            4'b0010: result = a + b; //ADD
            4'b0110: result = a - b; //SUB
            4'b0011: result = a ^ b; //XOR
            4'b0100: result = a << shamt; //SLL
            4'b0101: result = a >> shamt; //SRL
            4'b0111: result = $signed (a) >>> shamt ;//SRA
            4'b1000: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;//SLT
            4'b1001: result = (a<b) ? 32'd1: 32'd0; //SLTU
            4'b1010: result = b; //LUI
            4'b1011: result = (a + b) & 32'hFFFFFFFE; //JALR
            default: result = 32'b0;
        endcase
    end

    assign zero = (result == 32'b0);
endmodule