`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/15 12:45:08
// Design Name: 
// Module Name: display_tube
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


module display_tube(
    input rst,              //复位
    input clk,              //Y18
    input [16:0] write_data,        
    input digwrite,	        // 写信号
    input digcs,		    // 从memorio来的DIG片选信号   !!!!!!!!!!!!!!!!!
    output [7:0] DIG,       //8个 扫描一个
    output [7:0] Y          //输出的内容
    );

    reg clkout;
    reg [31:0] cnt;
    reg [3:0] scan_cnt;
    wire [31:0] num; // num to be displayed
    parameter period = 200000; //500Hz
    reg [7:0] DIG_r;

    reg [3:0] bcd;
    reg [6:0] seg_out;
    reg init = 1'b0; // the first time to use dig, open dig

    assign Y = {1'b1,(~seg_out[6:0])};
    assign DIG = ~DIG_r;

    Bin_BCD binToBCD(
        .digcs(digcs),
        .digwrite(digwrite),
        .binary(write_data),
        .decimal(num)
    );

    //分频
    always @ (posedge clk or posedge rst)
    begin
        if (rst) begin
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

    //扫描计数
    always @ (posedge clkout or posedge rst) begin
        if(rst)
            scan_cnt <=0;
        else begin
            scan_cnt <= scan_cnt +1;
            if(scan_cnt == 3'd7) scan_cnt <=0;
        end
    end

    //将输入转为对应位置的BCD码
    always @ (scan_cnt, num) begin
        case (scan_cnt)
            1 : bcd = num[3:0];
            2 : bcd = num[7:4];
            3 : bcd = num[11:8];
            4 : bcd = num[15:12];
            5 : bcd = num[19:16];
            6 : bcd = num[23:20];
            7 : bcd = num[27:24];
            8 : bcd = num[31:28];
            default: bcd = 4'b1111;
        endcase
    end

    //BCD码转输出字符
    always @ (bcd) begin
        if (digcs && digwrite && init) begin
            init = 1'b1;
            case(bcd)
                4'b0000: seg_out = 7'b0111111;//0
                4'b0001: seg_out = 7'b0000110;//1
                4'b0010: seg_out = 7'b1011011;//2
                4'b0011: seg_out = 7'b1001111;//3
                4'b0100: seg_out = 7'b1100110;//4
                4'b0101: seg_out = 7'b1101101;//5
                4'b0110: seg_out = 7'b1111101;//6
                4'b0111: seg_out = 7'b0100111;//7
                4'b1000: seg_out = 7'b1111111;//8
                4'b1001: seg_out = 7'b1101111;//9
                default :seg_out = 7'b0000000;//全灭
            endcase
        end
    end

    //扫描 8选一
    always @ (scan_cnt) begin
        case (scan_cnt)
            4'b0001 : DIG_r = 8'b0000_0001;
            4'b0010 : DIG_r = 8'b0000_0010;
            4'b0011 : DIG_r = 8'b0000_0100;
            4'b0100 : DIG_r = 8'b0000_1000;
            4'b0101 : DIG_r = 8'b0001_0000;
            4'b0110 : DIG_r = 8'b0010_0000;
            4'b0111 : DIG_r = 8'b0100_0000;
            4'b1111 : DIG_r = 8'b1000_0000;
            default : DIG_r = 8'b0000_0000;
        endcase
    end
endmodule