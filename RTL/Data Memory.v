module Data_memory (
    input wire clk, rst_n,
    input wire [31:0] adr, 
    input wire [31:0] wdata,
    input wire MemWrite, MemRead, 
    output reg [31:0] rdata
);
    reg [31:0] datamem [0:31];
    integer i;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin 
            for(i=0; i<32; i++) 
                datamem [i] <= 0;
        end else if (MemWrite && !MemRead) begin
            datamem [adr[4:0]] <= wdata;
        end
    end
    assign rdata = (MemRead) ? datamem [adr[4:0]] : 32'b0;
endmodule

