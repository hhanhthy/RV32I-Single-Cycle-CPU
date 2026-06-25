`include "ALU_Decoder.v"
`include "ALU.v"
`include "Comb.v"
`include "Data_Memory.v"
`include "Immediate_gen.v"
`include "Instruction_Fetch.v"
`include "Main_decoder.v"
`include "Register_File.v"
module Summary (
   input wire clk, rst_n, 
   output wire [31:0] adr, 
   output wire [31:0] inst, 
   output wire [31:0] pc_now
);
    wire [31:0] pc_next;
    wire [31:0] rdata1, rdata2;
    wire [31:0] imm;
    wire [3:0] ALU_operation;
    wire [31:0] rdata;
    wire [31:0] wdata;
    wire [31:0] in2_ALU;

    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire [1:0] ALUOp; 
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;

    wire zero;
    wire s_sum;
    wire [31:0] sum;
    wire [31:0] pc_mux;
    assign s_sum = Branch & zero;
    mux21 mux_PCSrc (.a(sum), .b(pc_next), .s(s_sum), .out(pc_mux)); 
    adder add_1 (.a(pc_now), .b(imm), .sum(sum));

    instruction_fetch ins_uut ( .clk(clk) ,.rst_n (rst_n), .inst (inst),
                               .pc_next(pc_mux) , .pc_now (pc_now));

    adder add_pc (.a(pc_now), .b(32'd4), .sum(pc_next));

    Register_File reg_uut (.clk(clk), .rst_n(rst_n), .RegWrite(RegWrite), 
                        .ra1(inst[19:15]), .ra2 (inst[24:20]), 
                        .wa (inst[11:7]), .wdata (wdata), 
                        .rdata1(rdata1), .rdata2 (rdata2));

    mux21 mux_ALU (.a(imm), .b(rdata2), .s(ALUSrc), .out(in2_ALU)); 

    Immediate_Gen im_uut (.inst(inst), .imm(imm));
    ALU uut (.a(rdata1), .b(in2_ALU), .ALU_operation(ALU_operation), 
            .zero(zero), .result(adr));

    main_decoder mde_uut (.inst(inst[6:0]), .Branch(Branch), 
                    .MemRead(MemRead), .MemtoReg(MemtoReg), .ALUOp(ALUOp)
                    ,.MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite));

    ALU_Decoder ALU_de_uut (.funct7(inst[31:25]), .funct3(inst[14:12]), 
            .ALUOp(ALUOp), .ALU_operation(ALU_operation));

    Data_memory data_uut (.clk(clk), .rst_n(rst_n), .adr(adr), .wdata(rdata2), 
                .MemWrite(MemWrite), .MemRead(MemRead), .rdata(rdata));

    mux21 uut1 (.a(rdata), .b(adr), .s(MemtoReg), .out(wdata)); 

endmodule