module ALU_Decoder (
    input wire [6:0] funct7, 
    input wire [2:0] funct3, 
    input wire [1:0] ALUOp,
    output reg [3:0] ALU_operation
);
    always@(*) begin 
        casez ({ALUOp,funct7,funct3})
            12'b00_zzzzzzz_zzz: ALU_operation = 4'b0010;
            12'b01_zzzzzzz_zzz: ALU_operation = 4'b0110;
            12'b10_0000000_000: ALU_operation = 4'b0010;
            12'b10_0100000_000: ALU_operation = 4'b0110;
            12'b10_0000000_111: ALU_operation = 4'b0000;
            12'b10_0000000_110: ALU_operation = 4'b0001;
            default: ALU_operation = 4'bxxxx;
        endcase 
    end
endmodule