`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/15 13:13:58
// Design Name: 
// Module Name: Bin_BCD
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


module Bin_BCD(
    input [26:0] binary,
    output [31:0] decimal
    );
 
    reg [3:0] d7;
    reg [3:0] d6;
    reg [3:0] d5;
    reg [3:0] d4;
    reg [3:0] d3;
    reg [3:0] d2;
    reg [3:0] d1;
    reg [3:0] d0;

    assign decimal = {d7[3:0], d6[3:0],d5[3:0], d4[3:0], d3[3:0],d2[3:0], d1[3:0], d0[3:0]};

    integer i;
    always @(binary) begin
        d7 = 4'd0;
        d6 = 4'd0;
        d5 = 4'd0;
        d4 = 4'd0;
        d3 = 4'd0;
        d2 = 4'd0;
        d1 = 4'd0;
        d0 = 4'd0;

        for (i = 26; i >= 0; i = i - 1) begin
            // 满5加3
            if (d7 >= 5) begin
                d7 = d7 + 3;
            end
            if (d6 >= 5) begin
                d6 = d6 + 3;
            end
            if (d5 >= 5) begin
                d5 = d5 + 3;
            end
            if (d4 >= 5) begin
                d4 = d4 + 3;
            end
            if (d3 >= 5) begin
                d3 = d3 + 3;
            end
            if (d2 >= 5) begin
                d2 = d2 + 3;
            end
            if (d1 >= 5) begin
                d1 = d1 + 3;
            end
            if (d0 >= 5) begin
                d0 = d0 + 3;
            end

            // 向左移位
            d7 = d7 << 1;
            d7[0] = d6[3];

            d6 = d6 << 1;
            d6[0] = d5[3];
            d5 = d5 << 1;
            d5[0] = d4[3];

            d4 = d4 << 1;
            d4[0] = d4[3];
            d3 = d3 << 1;
            d3[0] = d2[3];

            d2 = d2 << 1;
            d2[0] = d1[3];
            d1 = d1 << 1;
            d1[0] = d0[3];
            d0 = d0 << 1;
            d0[0] = binary[i];
        end
    end
endmodule