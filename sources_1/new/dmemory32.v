`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/04/12 16:57:43
// Design Name:
// Module Name: dmemory32
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


module dmemory32(clock,
                 Memwrite,
                 address,
                 write_data,
                 read_data);
    // Clock signal
    input clock;
    // the address of memory unit which is to be read/write
    input[31:0] address;
    // used to determine to write or read
    input Memwrite;
    // data tobe wirte into the memory unit
    input[31:0] write_data;
    // data tobe read from memory unit
    output[31:0] read_data;
    //Generating a clk signal, which is the inverted clock of the clock signal
    assign clk = !clock;
    //Create a instance of RAM(IP core), binding the ports
    RAM ram (
    .clka(clk), // input wire clka
    .wea(Memwrite), // input wire [0 : 0] wea
    .addra(address[15:2]), // input wire [13 : 0] addra
    .dina(write_data), // input wire [31 : 0] dina
    .douta(read_data) // output wire [31 : 0] douta
    );
endmodule
