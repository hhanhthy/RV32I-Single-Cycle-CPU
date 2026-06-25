module Immediate_Gen (
    input  wire [31:0] inst,
    output reg  [31:0] imm
);

    wire [6:0] opcode = inst[6:0];

    always @(*) begin
        case (opcode)
            7'b0000011, // lw
            7'b0010011, // addi, ori, andi...
            7'b1100111: // jalr
                imm = {{20{inst[31]}}, inst[31:20]};
            7'b0100011: //sw
                imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            7'b1100011: // beq, bne, blt, bge
                imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            7'b0110111, // lui
            7'b0010111: // auipc
                imm = {inst[31:12], 12'b0};
            7'b1101111: //jal
                imm = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            default:
                imm = 32'b0;
        endcase
    end

endmodule