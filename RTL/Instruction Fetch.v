module instruction_fetch (
    input wire clk, rst_n, 
    input wire [31:0] pc_next,
    output wire [31:0] inst, 
    output reg [31:0] pc_now
); 
    reg [31:0] imem [0:255];
  	integer i; 
  initial begin
    for(i=0; i<256; i=i+1)  
      imem[i] = 32'b0;
  end
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            pc_now <= 32'd0;
        else begin
            pc_now <= pc_next;
        end
    end
    
    assign inst = imem [pc_now[9:2]];

endmodule