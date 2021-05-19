`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/15 12:05:58
// Design Name:
// Module Name: Top
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


module Top(clk,
           rst,
           switchN24,
           ledN24,
           tub_on_off, // 七段数码显示管用不用
           DIG,
           Y);
    
    wire [31:0] BCD;
    //CPU part
    input clk; // Y18
    input rst;
    input tub_on_off;
    
    input [18:0] switchN24; // use [23:21] as
    output [23:0] ledN24;
    output [7:0] DIG;
    output [7:0] Y;
    
    //Switch to CPU input
    
    
    
    //cpu instance
    cpu cpu_instance(.clk(clk),.rst(rst),.switchN24(switchN24),.ledN24(ledN24));
    
    Bin_BCD binToBCD(.binary({{3{1'b0}},led24}),.decimal(BCD));
    
    display_tube tube(.on_off(tub_on_off),.rst(rst),.clk(clk),.num(BCD),.DIG(DIG),.Y(Y));
    
    
endmodule
