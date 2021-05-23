`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/22 17:41:50
// Design Name: 
// Module Name: tube_sim
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


module tube_sim(

    );
    reg rst;              //复位
    reg clk;              //Y18
    reg [1:0] digaddr; // 地址低端
    reg [31:0] write_data;      //要显示的数字  
    reg digwrite;	        // 写信号
    reg digcs;		    // 从memorio来的DIG片选信号   !!!!!!!!!!!!!!!!!
    wire [7:0] DIG;       //8个 扫描一个
    wire [7:0] Y;

    display_tube tubes (
        .rst(rst),.clk(clk),
        .write_data(write_data),
        .digwrite(digwrite),
        .digcs(digcs),
        .DIG(DIG),
        .Y(Y));

    initial begin
        #0 rst = 1'b1;
        #0 digaddr = 1'b1;
        #0 digcs = 1'b1;
        #0 digwrite = 1'b1;
        #0 write_data = 32'b0000_0000_0000_0010;


        #20 clk = 1'b0;
        #2 rst = 1'b0;
        #500 $finish(0);
    end

    always begin
        # 2 clk = ~clk;
    end
  
endmodule
