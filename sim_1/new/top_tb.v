`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/17 12:52:17
// Design Name:
// Module Name: top_tb
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


module top_tb();
    reg clk              = 1'b0;
    reg rst              = 1'b0;
    reg tub_on_off       = 1'b0;
    reg [18:0] switchN24 = 0;
    wire [23:0] ledN24;
    wire [7:0] DIG;
    wire [7:0] Y;
    
    Top top(clk, rst, switchN24, ledN24, tub_on_off, DIG, Y);
    
    always
    #10 clk = ~clk;
    initial begin
        #100 $finish();
    end
endmodule
