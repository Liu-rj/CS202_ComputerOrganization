`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/04/12 17:17:03
// Design Name:
// Module Name: ramTb
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


//The testbench module for dmemory32
module ramTb();
    reg clock            = 1'b0;
    reg memWrite         = 1'b0;
    reg [31:0] addr      = 32'h0000_0010;
    reg [31:0] writeData = 32'ha000_0000;
    wire [31:0] readData;
    dmemory32 uram(clock,memWrite,addr,writeData,readData);
    always
    #50 clock = ~clock;
    initial begin
        #200
        writeData = 32'ha0000_00f5;
        memWrite  = 1'b1;
        #200
        memWrite = 1'b0;
    end
endmodule
