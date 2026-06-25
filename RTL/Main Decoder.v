module main_decoder(
    input wire [6:0] inst,
    output reg Branch, 
    output reg MemRead, 
    output reg MemtoReg, 
    output reg [1:0] ALUOp, 
    output reg MemWrite, 
    output reg ALUSrc, 
    output reg RegWrite
);
    always@(*) begin 
        case(inst)
        //R-type
        7'b0110011: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} 
                    = 8'b0_0_1_0_0_0_10;
        //lw
        7'b0000011: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} 
                    = 8'b1_1_1_1_0_0_00;
        //sw
        7'b0100011: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} 
                    = 8'b1_0_0_0_1_0_00;
        //beq
        7'b1100011: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} 
                    = 8'b0_0_0_0_0_1_01;
        default: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp} 
                    = 8'b0_0_0_0_0_0_00;
        endcase
    end
endmodule