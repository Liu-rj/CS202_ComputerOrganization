`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/04/19 17:45:55
// Design Name:
// Module Name: control32Tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module control32Tb();
    //reg type variables are use for binding with input ports
    reg [5:0] Opcode;
    reg [5:0] Function_opcode;
    //wire type variables are use for binding with output ports
    wire [1:0] ALUOp;
    wire Jr,RegDST,ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,nBranch,Jmp,Jal,I_format,Sftmd;
    //instance the module "control32", bind the ports
    control32 c32
    (Opcode,Function_opcode, Jr,Jmp,Jal, Branch,nBranch,RegDST,MemtoReg,RegWrite,MemWrite, ALUSrc,I_format, Sftmd, ALUOp);
    initial begin
        //an example: #0 add $3,$1,$2. get the machine code of 'add $3,$1,$2'
        // step1: edit the assembly code, add "add $3,$1,$2"
        // step2: open the assembly code in Minisys1A assembler, do the assembly procession
        // step3: open the "output/prgmips32.coe" file, find the related machine code of 'add $3,$1,$2'
        //in "0x00221820", 'Opcode' is 6'h00,'Function_opcode' is 6'h20
        Opcode          = 6'h00;
        Function_opcode = 6'h20;
        #200
        Opcode          = 6'h00;
        Function_opcode = 6'h08;
        #200
        Opcode          = 6'h08;
        Function_opcode = 6'h08;
        #200
        Opcode          = 6'h23;
        Function_opcode = 6'h08;
        #200
        Opcode          = 6'h2b;
        Function_opcode = 6'h08;
        #200
        Opcode          = 6'h04;
        Function_opcode = 6'h08;
        #200
        Opcode          = 6'h05;
        Function_opcode = 6'h08;
        #200
        Opcode          = 6'h02;
        Function_opcode = 6'h08;
        #200
        Opcode          = 6'h03;
        Function_opcode = 6'h08;
        #200
        Opcode          = 6'h00;
        Function_opcode = 6'h02;
        #200 $finish();
    end
endmodule
