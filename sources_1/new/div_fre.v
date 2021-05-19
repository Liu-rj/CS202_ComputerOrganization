`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/15 12:03:51
// Design Name: 
// Module Name: div_fre
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


module div_fre(
    input clk,  //Y18
    input rst,  //复位
    output reg clkout
    );
    parameter period = 100000000;//1s
    reg [31:0] cnt;

    always @ (posedge clk or negedge rst)
    begin
    if (!rst) begin
        cnt <= 0;
        clkout <=0;
    end
    else begin
        if(cnt == (period>>1)-1)
        begin
            clkout <= ~clkout;
            cnt <= 0;
        end
        else
            cnt <= cnt+1;
    end
end
endmodule
