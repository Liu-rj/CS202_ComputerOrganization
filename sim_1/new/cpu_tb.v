`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/17 13:01:07
// Design Name: 
// Module Name: cpu_tb
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


module cpu_tb();
    reg clk              = 1'b0;
    reg rst              = 1'b0;
    reg [18:0] switchN24 = 19'b0000000000000000001;
    wire [23:0] ledN24;

    cpu cpu_ins(clk, rst, switchN24, ledN24);

    always
    #10 clk = ~clk;
    initial begin
        #2 rst = 1'b1;
        #5 rst = 1'b0;
        #200 $finish();
    end
endmodule
