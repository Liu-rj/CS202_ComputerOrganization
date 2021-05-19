`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/12 19:40:48
// Design Name:
// Module Name: ifetc32_sim
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


module ifetc32_sim();
    // input
    reg[31:0]  Addr_result;
    reg[31:0]  Read_data_1;
    reg        Branch;
    reg        nBranch;
    reg        Jmp;
    reg        Jal;
    reg        Jr;
    reg        Zero;
    reg        clock = 1'b0;
    reg        reset;    //1'b1 is 'reset' enable, 1'b0 means 'reset' disable. while 'reset' enable, the value of PC is set as 32'h0000_0000
    
    // output
    wire[31:0] Instruction;
    wire[31:0] branch_base_addr;
    wire[31:0] link_addr;
    wire[31:0] pco;      // bind with the new output port 'pco' in IFetc32
    
    Ifetc32 Uifetch(.Instruction(Instruction),.branch_base_addr(branch_base_addr),.Addr_result(Addr_result),
    .Read_data_1(Read_data_1),.Branch(Branch),.nBranch(nBranch),.Jmp(Jmp),.Jal(Jal),.Jr(Jr),.Zero(Zero),
    .clock(clock),.reset(reset),.link_addr(link_addr),.pco(pco));
    
    always #2 clock = ~clock;   //4,8,12... negedge(4n),updtate pc,  //2,6,10... posedge(4n+2),get instruction according to the value of PC
    initial begin
        #64 $finish();
    end
endmodule
