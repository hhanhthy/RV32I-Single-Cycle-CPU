`timescale 1ns/100ps
module tb_RV32I;
    reg clk, rst_n; 
    wire [31:0] adr; 
    wire [31:0] inst;
    wire [31:0] pc_now;

    Summary uut (.clk (clk), .rst_n (rst_n), .adr(adr),
            .inst(inst) , .pc_now(pc_now));

    integer pass_cnt = 0; 
    integer fail_cnt = 0; 
  
    initial begin
        $dumpfile("cpu_wave.vcd");
        $dumpvars(0, tb_RV32I);   
    end
  
    task check; 
        input [127:0] label;
        input [31:0] got; 
        input [31:0] expected; 
        begin 
            if(got==expected) begin 
                $display("PASS %0s = %0d (0x%08h)  expected %0d (0x%08h)", label, got, got, expected, expected);
                pass_cnt = pass_cnt + 1;
            end else begin 
               $display("FAIL %0s = %0d (0x%08h)  expected %0d (0x%08h)", label, got, got, expected, expected);
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask

    task check1;
        input [127:0] label;
        input [31:0] got; 
        input [31:0] expected; 
        begin
            if (got === expected) begin
                $display("  [PASS] %0s = %0b", label, got);
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("  [FAIL] %0s = %0b  expected %0b", label, got, expected);
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask

    `define PERIOD 10
    always #(`PERIOD/2) clk = !clk;
  
    initial begin
        clk = 0; rst_n = 0;
        //TEST1
        $display(" TEST 1 : R-type ");
        @(negedge clk);                       
        uut.ins_uut.imem[0] = 32'h002081B3;
        rst_n = 0;
        @(posedge clk); #1;                      
        rst_n = 1; #1;                                     
        uut.reg_uut.x[1] = 32'd5;              
        uut.reg_uut.x[2] = 32'd3;
        #1;                                   

        $display("inst = %h, opcode = %b", inst, inst[6:0]);
        check1("ALUSrc  ",uut.ALUSrc,1'b0);
        check1("RegWrite",uut.RegWrite,1'b1);
        check1("MemRead ",uut.MemRead,1'b0);
        check1("MemWrite",uut.MemWrite,1'b0);
        check1("MemtoReg",uut.MemtoReg,1'b0);
        check1("Branch  ",uut.Branch,1'b0);
        check1("ALUOp[1]",uut.ALUOp[1],1'b1);
        check1("ALUOp[0]",uut.ALUOp[0],1'b0);
        check1("ALU_ctrl",uut.ALU_operation === 4'b0010, 1'b1);
      @(posedge clk); #1;          
        check("x3", uut.reg_uut.x[3], 32'd8);

        // TEST 2 : I-type  lw x4, 0(x1)
        $display(" TEST 2 : I-type  lw x4, 0(x1)");
        @(negedge clk);
        uut.ins_uut.imem[0]= 32'h0000A203;
        rst_n = 0;
        @(posedge clk); #1;
        rst_n = 1; #1;
        uut.reg_uut.x[1] = 32'd4;
        uut.data_uut.datamem[4] = 32'd99;
        #1;

        check1("ALUSrc  ",uut.ALUSrc,1'b1);
        check1("RegWrite",uut.RegWrite,1'b1);
        check1("MemRead ",uut.MemRead,1'b1);
        check1("MemWrite",uut.MemWrite,1'b0);
        check1("MemtoReg",uut.MemtoReg,1'b1);
        check1("Branch  ",uut.Branch,1'b0);
        check1("ALUOp   ",uut.ALUOp === 2'b00,1'b1);
        check1("ALU_ctrl",uut.ALU_operation === 4'b0010, 1'b1);

        @(posedge clk); #1;
        check("x4", uut.reg_uut.x[4], 32'd99);

        // TEST 3 : S-type  sw x2, 0(x1)
        $display(" TEST 3 : S-type  sw x2, 0(x1)");
        @(negedge clk);
        uut.ins_uut.imem[0] = 32'h0020A023;
        rst_n = 0;
        @(posedge clk); #1;
        rst_n = 1; #1;
        uut.reg_uut.x[1] = 32'd4;
        uut.reg_uut.x[2] = 32'd77;
        #1;
        check1("ALUSrc  ", uut.ALUSrc,   1'b1);
        check1("RegWrite", uut.RegWrite, 1'b0);
        check1("MemRead ", uut.MemRead,  1'b0);
        check1("MemWrite", uut.MemWrite, 1'b1);
        check1("Branch  ", uut.Branch,   1'b0);
        check1("ALUOp   ", uut.ALUOp === 2'b00, 1'b1);
        check1("ALU_ctrl", uut.ALU_operation === 4'b0010, 1'b1);

        @(posedge clk); #1;   
        check("datamem[4]", uut.data_uut.datamem[4], 32'd77);

        // TEST 4 : beq  x1==x2  (branch taken)
        $display(" TEST 4 : beq  x1==x2  (branch taken)");
        @(negedge clk);
        uut.ins_uut.imem[0] = 32'h00208463;
        rst_n = 0;
        @(posedge clk); #1;
        rst_n = 1;#1;
        uut.reg_uut.x[1] = 32'd5;
        uut.reg_uut.x[2] = 32'd5;
        #1;
        check1("ALUSrc  ", uut.ALUSrc,   1'b0);
        check1("RegWrite", uut.RegWrite, 1'b0);
        check1("MemRead ", uut.MemRead,  1'b0);
        check1("MemWrite", uut.MemWrite, 1'b0);
        check1("Branch  ", uut.Branch,   1'b1);
        check1("ALUOp   ", uut.ALUOp === 2'b01, 1'b1);
        check1("ALU_ctrl", uut.ALU_operation === 4'b0110, 1'b1);
        check1("zero    ", uut.zero,   1'b1);
        check1("PCSrc   ", uut.s_sum,  1'b1);
        @(posedge clk); #1;                     
        check("PC (taken)", pc_now, 32'd8);

        // TEST 5 : beq  x1!=x2  (branch not taken)
        $display(" TEST 5 : beq  x1!=x2  (branch not taken)");
        @(negedge clk);
        uut.ins_uut.imem[0] = 32'h00208463;
        rst_n = 0;
        @(posedge clk); #1;
        rst_n = 1; #1;
        uut.reg_uut.x[1] = 32'd5;
        uut.reg_uut.x[2] = 32'd3;
        #1;
        check1("zero    ", uut.zero,  1'b0);
        check1("PCSrc   ", uut.s_sum, 1'b0);
        @(posedge clk); #1;                     
        check("PC (not taken)", pc_now, 32'd4);

        $finish;
    end

endmodule