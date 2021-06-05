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
    reg [23:0] switchN24 = 24'b000000000000000000000001;
    wire [23:0] ledN24;
    wire [7:0] DIG;
    wire [7:0] Y;
    reg start_pg = 0;
    reg upg_rx   = 0;
    wire upg_tx;
    
    
    CPU_UART cpu_ins(clk, rst, switchN24, ledN24, DIG, Y, start_pg, upg_rx, upg_tx);
    
    always
    #10 clk = ~clk;
    initial begin
        #5 rst = 1'b1;
        #8 rst = 1'b0;
        #200 $finish();
    end
endmodule
