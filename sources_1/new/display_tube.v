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
    //input [1:0] digaddr, // 地址低端
    input [31:0] write_data,      //要显示的数字  
    input digwrite,	        // 写信号
    input digcs,		    // 从memorio来的DIG片选信号   !!!!!!!!!!!!!!!!!
    //input enable;
    output [7:0] DIG,       //8个 扫描一个
    output [7:0] Y          //输出的内容
    );

    reg clkout;
    reg [31:0] cnt;
    reg [3:0] scan_cnt;
    //wire [31:0] num; // num to be displayed
    parameter period = 20000; //5000Hz
    reg [7:0] DIG_r;

    reg [3:0] bcd;
    reg [6:0] seg_out;
    //reg init = 1'b0; // the first time to use dig, open dig

    reg [31:0] store;//存住上一次想要输出的东西

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            store <= 32'b0;
        end
        else if (digwrite & digcs) begin
            store <= write_data;
        end
    end

    assign Y = {1'b1,(~seg_out[6:0])};
    assign DIG = ~DIG_r;

    //Bin_BCD binToBCD(
    //    .digcs(digcs),
    //    .digwrite(digwrite),
    //    .binary(write_data),
    //    .decimal(num)
    //);


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
        begin
            scan_cnt <=4'b0000;
        end

        else begin
            scan_cnt <= scan_cnt +1;
            //if(scan_cnt == 4'd8) scan_cnt <=4'b0000;
        end
    end

    //将输入转为对应位置的BCD码//已经修改 现在的bcd代表对应位置上的连续4位的二进制码
    always @ (scan_cnt) begin
        case (scan_cnt)
            1 : bcd = store[3:0];
            2 : bcd = store[7:4];
            3 : bcd = store[11:8];
            4 : bcd = store[15:12];
            5 : bcd = store[19:16];
            6 : bcd = store[23:20];
            7 : bcd = store[27:24];
            8 : bcd = store[31:28];
            default: bcd = 4'bz;
        endcase
    end

    //BCD码转输出字符//已经修改 现在转为16进制的输出字符
    always @ (bcd) begin
        //if (digcs && digwrite ) begin
            //init = 1'b1;
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
                4'b1010: seg_out = 7'b1110111;//A
                4'b1011: seg_out = 7'b1111100;//b
                4'b1100: seg_out = 7'b0111001;//C
                4'b1101: seg_out = 7'b1011110;//d
                4'b1110: seg_out = 7'b1111001;//E
                4'b1111: seg_out = 7'b1110001;//F
                default :seg_out = 7'b0000000;//全灭
            endcase
        //end
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
            4'b1000 : DIG_r = 8'b1000_0000;
            default : DIG_r = 8'b0000_0000;
        endcase
    end
endmodule