`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/05/14 15:21:38
// Design Name:
// Module Name: cpu
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


module cpu(clock, // for test, from clk to clock, should be clk in real situation
           rst,
           switchN24,
           ledN24);
           
    input clock; // for test, from clk to clock, should be clk
    input rst;
    input[18:0] switchN24;
    output [23:0] ledN24;
    
    // wire clock; // output clock signal, should not be annotated
    wire [31:0]Instruction;
    wire [31:0]branch_base_addr;
    wire [31:0]Addr_result;
    wire [31:0]Read_data_1;
    wire Branch,nBranch,Jmp,Jal,Jr,Zero;
    wire [31:0]link_addr;
    wire [31:0]pco;
    
    wire [31:0] Read_data_2;
    wire [31:0] read_data;
    wire RegWrite;
    wire RegDst;
    wire [31:0]imme_extend;
    
    wire ALUSrc;
    wire MemorIOtoReg;
    wire MemRead;
    wire MemWrite;
    wire IORead;
    wire IOWrite;
    wire I_format;
    wire Sftmd;
    wire [1:0]ALUOp;
    
    wire [4:0]Shamt;
    wire [31:0]ALU_Result;
    wire[31:0] read_data_fromMemory;
    wire[31:0] address;
    wire[31:0] write_data;
    wire [15:0]ioread_data;
    wire switchcs;
    wire [1:0]switchaddr;
    wire [23:0]switch_i;
    
    wire ledcs;
    wire [1:0]ledaddr;
    
    // cpuclk cpuclk(
    // .clk_in1(clk),
    // .clk_out1(clock)
    // );
    
    Ifetc32 ifetch(
    .Instruction(Instruction),
    .branch_base_addr(branch_base_addr),
    .Addr_result(Addr_result),
    .Read_data_1(Read_data_1),
    .Branch(Branch),
    .nBranch(nBranch),
    .Jmp(Jmp),
    .Jal(Jal),
    .Jr(Jr),
    .Zero(Zero),
    .clock(clock),
    .reset(rst),
    .link_addr(link_addr),
    .pco(pco)
    );
    
    Idecode32 decoder(
    .read_data_1(Read_data_1),
    .read_data_2(Read_data_2),
    .Instruction(Instruction),
    .read_data(read_data),
    .ALU_result(ALU_Result),
    .Jal(Jal),
    .RegWrite(RegWrite),
    .MemtoReg(MemorIOtoReg),
    .RegDst(RegDst),
    .imme_extend(imme_extend),
    .clock(clock),
    .reset(rst),
    .opcplus4(link_addr)
    );
    
    control32 control(
    .Opcode(Instruction[31:26]),
    .Function_opcode(Instruction[5:0]),
    .Alu_resultHigh(ALU_Result[31:10]),
    .Jr(Jr),
    .Jmp(Jmp),
    .Jal(Jal),
    .Branch(Branch),
    .nBranch(nBranch),
    .RegDST(RegDst),
    .MemorIOtoReg(MemorIOtoReg),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .IORead(IORead),
    .IOWrite(IOWrite),
    .ALUSrc(ALUSrc),
    .I_format(I_format),
    .Sftmd(Sftmd),
    .ALUOp(ALUOp)
    );
    
    Executs32 execute(
    .Read_data_1(Read_data_1),
    .Read_data_2(Read_data_2),
    .Imme_extend(imme_extend),
    .Function_opcode(Instruction[5:0]),
    .opcode(Instruction[31:26]),
    .Shamt(Instruction[10:6]),
    .PC_plus_4(branch_base_addr),
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    .I_format(I_format),
    .Sftmd(Sftmd),
    .Jr(Jr),
    .Zero(Zero),
    .ALU_Result(ALU_Result),
    .Addr_Result(Addr_result)
    );
    
    dmemory32 memory(
    .clock(clock),
    .Memwrite(MemWrite),
    .address(address),
    .write_data(write_data),
    .read_data(read_data_fromMemory)
    );
    
    MemOrIO memorio(
    .mRead(MemRead),
    .mWrite(MemWrite),
    .ioRead(IORead),
    .ioWrite(IOWrite),
    .addr_in(ALU_Result),
    .addr_out(address),
    .m_rdata(read_data_fromMemory),
    .io_rdata(ioread_data), // input io data from switch, 16 bit to 32 bit r_wdata
    .r_wdata(read_data), // io read data output to idecode32(register file)
    .r_rdata(Read_data_2), // data read from idecode32(register file) input port
    .write_data(write_data), // data to memory or I/O (m_wdata, io_wdata) output reg
    .LEDCtrl(ledcs),
    .SwitchCtrl(switchcs)
    );
    
    switchs switch24(
    .switclk(clock),
    .switrst(rst),
    .switchcs(switchcs),
    .switchaddr(address[1:0]),
    .switchread(IORead),
    .switchrdata(ioread_data), // data from io switch, 16-bit output to other module
    .switch_i(switchN24) // 19bit switch io data in
    );
    
    leds led24(
    .led_clk(clock),
    .ledrst(rst),
    .ledwrite(IOWrite),
    .ledcs(ledcs),
    .ledaddr(address[1:0]),
    .ledwdata(write_data[15:0]), // io write data to be displayed on leds
    .ledout(ledN24) // led display port
    );
    
    
endmodule
