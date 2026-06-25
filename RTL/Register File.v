module Register_File(
    input wire clk, rst_n, 
    input wire RegWrite, 
    input wire [4:0] ra1, ra2, wa, 
    input wire [31:0] wdata,
    output wire [31:0] rdata1, rdata2
); 
    reg [31:0] x [0:31];

    integer i; 
    always@(posedge clk or negedge rst_n) begin
      if(!rst_n) begin 
        for(i=0; i<32; i++) 
            x[i] <= 32'b0;
      end else if (RegWrite && (wa != 5'b0)) begin
        x[wa] <= wdata;
      end
    end

  assign rdata1 = (ra1 != 5'b0) ? x[ra1] : 32'b0; 
  assign rdata2 = (ra2 != 5'b0) ? x[ra2] : 32'b0;

endmodule