# CPU使用手册

[TOC]

## 一、CPU功能及使用说明

### （一）CPU功能及基本信息

本CPU为单周期CPU，支持Minsys机器码的执行，CPI = 1，即每个周期执行一条指令。

### （二）使用说明

1. 复位信号

   开发板上的**按钮**为复位信号，敏感于其上升沿。复位开关按下后，CPU进入普通工作模式（非uart连接模式），并进行复位操作，如：Decoder模块中的32个寄存器将被初始化为0x00000000。

2. 接口支持说明

   ```verilog
   module CPU_UART(input fpga_clk,
              input fpga_rst, 							// Active High
              input [23:0] switchN24,					//Connect the corresponding dial switch
              output [23:0] ledN24,					//Connect the corresponding LED light
              output [7:0] DIG,						//Choice of eight seven segment digital display tubes
              output [7:0] Y, 							//Content to display
              // UART Programmer Pinouts
              // start Uart communicate at high level
              input start_pg,					 		// Active High
              input upg_rx, 							// receive data by UART
              output upg_tx); 							// send data by UART
   ```

3. uart支持说明

   开发板上的**按钮2**为uart模式的进入按钮。

   使用uart串口，可以在不重新烧写比特流文件的情况下，改写原有的程序，让cpu执行不同的程序。

   使用uart串口，需要先将minisys的汇编代码编译成.coe文件，利用UartAssist.exe将生成的数据段文件和程序段文件合并，之后再利用“串口调试助手”在cpu进入uart模式的情况下将数据文件导入。最后按下复位开关，即可在开发板上运行新烧写的程序。

4. 使用方法

   将该CPU部署到FPGA芯片上后，可以通过uart串口烧写不同的程序，在开发板上经行程序测试。

## 二、顶层模块

(cpu内部接口连接图)

![image-20210612175131759](.\pics\image-20210612175131759.png)

其他说明：在顶层模块中，设计了fpga_rst 和upg_rst两个信号来控制CPU是进入正常工作状态还是uart通信模式。

## 三、子模块设计说明

### （一）CPU结构

#### 1. IFetch_UART

（1）子模块功能：根据ControlleraIO、ALU、Decoder等模块传入的信号对PC，Next_PC值进行迭代。

（2）行为与时钟的关系：敏感于时钟信号的下降沿，对PC值进行刷新。

（3）端口规格:

```verilog
module IFetch_UART(Instruction_i,
               branch_base_addr,
               link_addr,
               clock,
               reset,
               Addr_result,
               Read_data_1,
               Branch,
               nBranch,
               Jmp,
               Jal,
               Jr,
               Zero,
               Instruction_o,
               rom_adr_o);
    input[31:0] Instruction_i; // the instruction fetched from this module
    input clock,reset; // Clock and reset
    // from ALU
    input[31:0] Addr_result; // the calculated address from ALU
    input Zero; // while Zero is 1, it means the ALUresult is zero
    // from Decoder
    input[31:0] Read_data_1; // the address of instruction used by jr instruction
    // from controller
    input Branch; // while Branch is 1,it means current instruction is beq
    input nBranch; // while nBranch is 1,it means current instruction is bnq
    input Jmp; // while Jmp 1,it means current instruction is jump
    input Jal; // while Jal is 1,it means current instruction is jal
    input Jr; // while Jr is 1,it means current instruction is jr

    output[31:0] Instruction_o;
    output[31:0] branch_base_addr; // (pc+4) to ALU which is used by branch type instruction
    output reg [31:0] link_addr; // (pc+4) to decoder which is used by jal instruction
    output[13:0] rom_adr_o;      // bind with the new output port 'pco' in IFetc32
```

（4）其他说明: 

#### 2. Decoder

（1）子模块功能：根据给定的机器码，以及ControllerIO等模块传入的信号，对寄存器经行读/写操作。

（2）行为与时钟的关系：写入部分为时序逻辑，敏感于时钟上升沿；读出部分为组合逻辑；

（3）端口规格：

```verilog
module Decoder(input [31:0] Instruction,
                 input [31:0] read_data,
                 input [31:0] ALU_result,
                 input Jal,
                 input RegWrite,
                 input MemtoReg,
                 input RegDst,
                 input clock,
                 input reset,
                 input[31:0] opcplus4,      // from ifetch link_address
                 output[31:0] read_data_1,
                 output[31:0] read_data_2,
                 output[31:0] imme_extend);

```

（4）其他说明: 当reset信号生效时，会将寄存器内的值做归零处理。

#### 3. ControllerIO

（1）子模块功能：根据给定的机器码，生成相应的控制信号。

（2）行为与时钟的关系：组合逻辑，与时钟信号无关。

（3）端口规格：

```verilog
module ControllerIO(Opcode,
                 Function_opcode,
                 Jr,
                 Jmp,
                 Jal,
                 Branch,
                 nBranch,
                 Alu_resultHigh,
                 RegDST,
                 MemorIOtoReg,
                 RegWrite,
                 MemRead,
                 MemWrite,
                 IORead,
                 IOWrite,
                 ALUSrc,
                 I_format,
                 Sftmd,
                 ALUOp);
    
    input[5:0] Opcode; // instruction[31..26]
    input[5:0] Function_opcode; // instructions[5..0]
    input[21:0] Alu_resultHigh; // From the execution unit Alu_Result[31..10]
    output Jr; // 1 indicates the instruction is "jr", otherwise it's not "jr"
    output Jmp; // 1 indicate the instruction is "j", otherwise it's not
    output Jal; // 1 indicate the instruction is "jal", otherwise it's not
    output Branch; // 1 indicate the instruction is "beq" , otherwise it's not
    output nBranch; // 1 indicate the instruction is "bne", otherwise it's not
    output RegDST; // 1 indicate destination register is "rd",otherwise it's "rt"
    output MemorIOtoReg; // 1 indicates that data needs to be read from memory or I/O to the register
    output RegWrite; // 1 indicate write register, otherwise it's not
    output MemRead; // 1 indicates that the instruction needs to read from the memory
    output MemWrite; // 1 indicate write data memory, otherwise it's not
    output IORead; // 1 indicates I/O read
    output IOWrite; // 1 indicates I/O write
    output ALUSrc; // 1 indicate the 2nd data is immidiate (except "beq","bne")
    output I_format; // 1 indicate the instruction is I-type but isn't “beq","bne","LW" or "SW"
    output Sftmd; // 1 indicate the instruction is shift instruction
    // if the instruction is R-type or I_format, ALUOp is 2'b10; if the instruction is"beq" or “bne", ALUOp is 2'b01;
    // if the instruction is"lw" or "sw", ALUOp is 2'b00;
    output[1:0] ALUOp;
```

（4）其他说明：

#### 4. ALU

（1）子模块功能：逻辑运算单元，根据从ControllerIO，Decoder等模块传入的信号，进行简单的算术逻辑运算。

（2）行为与时钟的关系：组合逻辑，与时钟信号无关。

（3）端口规格：

```verilog
module ALU(input[31:0] Read_data_1,      //the source of A input
                 input[31:0] Read_data_2,      //one of the sources of Binput
                 input[31:0] Imme_extend,      //one of the sources of Binput
                 input[5:0] Function_opcode,   //instructions[5:0]
                 input[5:0] opcode,            //instruction[31:26]
                 input[4:0] Shamt,             // instruction[10:6], the amount of shift bits
                 input[31:0] PC_plus_4,        // pc+4, from ifetch's branch_base_addr
                 input[1:0] ALUOp,             //{ (R_format || I_format), (Branch || nBranch) }
                 input ALUSrc,                 // 1 means the 2nd operand is an immedite (except beq，bne)
                 input I_format,               // 1 means I-Type instruction except beq, bne, LW, SW
                 input Sftmd,                  // 1 means this is a shift instruction
                 input Jr,                     // 1 means this is a jr instruction
                 output Zero,                  // 1 means the ALU_reslut is zero, 0 otherwise, In ALU, Zero is determined by ALU_output_mux, not ALU_Result
                 output reg [31:0] ALU_Result, // the ALU calculation result
                 output[31:0] Addr_Result);    // the calculated instruction address
```

（4）其他说明:

#### 5. Dmem_UART

（1）子模块功能：存储数据

（2）行为与时钟的关系：时序逻辑

（3）端口规格：

```verilog
module Dmem_UART(input ram_clk_i,         // from CPU top
                 input ram_wen_i,         // from controller
                 input [13:0] ram_adr_i,  // from alu_result of ALU
                 input [31:0] ram_dat_i,  // from read_data_2 of decoder
                 output [31:0] ram_dat_o, // the data read from ram
                 input upg_rst_i,         // UPG reset (Active High)
                 input upg_clk_i,         // UPG ram_clk_i (10MHz)
                 input upg_wen_i,         // UPG write enable
                 input [13:0] upg_adr_i,  // UPG write address
                 input [31:0] upg_dat_i,  // UPG write data
                 input upg_done_i);       // 1 if programming is finished
```



（4）其他说明: 常规模式下会根据控制信号对内存进行读写处理；此外，该模块会根据upg_rst_i 和 upg_done_i 信号来判断是否为uart通信模式，或者通信模式是否结束，进而对ram模块经行相应的读写处理。

#### 6. ProgramRom_UART

（1）子模块功能：储存程序段数据

（2）行为与时钟的关系： 时序逻辑

（3）端口规格：

```verilog
module ProgramROM_UART (
                // Program ROM Pinouts
                input rom_clk_i, // ROM clock
                input [13:0] rom_adr_i, // From IFetch
                // UART Programmer Pinouts
                input upg_rst_i, // UPG reset (Active High)
                input upg_clk_i, // UPG clock (10MHz)
                input upg_wen_i, // UPG write enable
                input[13:0] upg_adr_i, // UPG write address
                input[31:0] upg_dat_i, // UPG write data
                input upg_done_i, // 1 if program finished
                output [31:0] Instruction_o); // To IFetch
```



（4）其他说明：与Dmem_UART模块相似，该模块会根据upg_rst_i 和 upg_done_i 信号来判断是否为uart通信模式，进而对存储程序的ram模块经行相应的读写处理。

#### 7. MemOrIO

（1）子模块功能：根据输入的信号，判断是否使用IO读写。

（2）行为与时钟的关系: 组合逻辑，与时钟信号无关。

（3）端口规格：

```verilog
module MemOrIO(Alu_resultLow,
               mRead,
               mWrite,
               ioRead,
               ioWrite,
               addr_in,
               addr_out,
               m_rdata,
               io_rdata,
               r_wdata,
               r_rdata,
               write_data,
               LEDCtrl,
               SwitchCtrl,
               DigCtrl);
    input[7:0] Alu_resultLow; // 0x60, 0x62, 0x80, 0x82
    input mRead; // read memory, from control32
    input mWrite; // write memory, from control32
    input ioRead; // read IO, from control32
    input ioWrite; // write IO, from control32
    input[31:0] addr_in; // from alu_result in executs32
    output[31:0] addr_out; // address to memory

    input[31:0] m_rdata; // data read from memory
    input[15:0] io_rdata; // data read from io,16 bits
    output[31:0] r_wdata; // data to idecode32(register file)
    
    input[31:0] r_rdata; // data read from idecode32(register file)
    output reg[31:0] write_data; // data to memory or I/O（m_wdata, io_wdata)
    output LEDCtrl; // LED Chip Select
    output SwitchCtrl; // Switch Chip Select
    output DigCtrl; // digital display tube
```



（4）其他说明：在这里，我们定义，若lw的地址为0xfffff60则为使用LED灯（1-16）展示；若sw的地址为0xfffff62则为使用LED灯（17-24）展示；若lw的地址为0xfffff80则为使用七段数码显示管灯展示结果。

### （二）IO设备 

#### 1. Switch

（1）子模块功能: 从24位拨码开关上读取数据。

（2）行为与时钟的关系：敏感于时钟下降沿。

（3）端口规格

```verilog
module Switch(switclk, switrst, switchread, switchcs,switchaddr, switchrdata, switch_i);
    input switclk;			        //  时钟信号
    input switrst;			        //  复位信号
    input switchcs;			        //  从memorio来的switch片选信号  !!!!!!!!!!!!!!!!!
    input[1:0] switchaddr;		    //  到switch模块的地址低端  !!!!!!!!!!!!!!!
    input switchread;			    //  读信号
    output [15:0] switchrdata;	    //  送到CPU的拨码开关值注意数据总线只有16根
    input [23:0] switch_i;		    //  从板上读的24位开关数据
```

（4）其他说明：switrst生效时，会将switchrdata的输出复位为0。

#### 2. LED

（1）子模块功能: 24个LED灯的显示

（2）行为与时钟的关系：时序逻辑，敏感于时钟下降沿。

（3）端口规格

```verilog
module LED(led_clk,
            ledrst,
            ledwrite,
            ledcs,
            ledaddr,
            ledwdata,
            ledout);
    input led_clk;    		    // 时钟信号
    input ledrst; 		        // 复位信号
    input ledwrite;		       	// 写信号
    input ledcs;		      	// 从memorio来的LED片选信号   !!!!!!!!!!!!!!!!!
    input[1:0] ledaddr;	        //  到LED模块的地址低端  !!!!!!!!!!!!!!!!!!!!
    input [16:0] ledwdata;	  	//  写到LED模块的数据
    output[23:0] ledout;		//  向板子上输出的24位LED信号
```



（4）其他说明：ledrst生效时，会将ledout的输出复位为0；为了使CPU在执行非显示指令时不会让之前的显示消失，只有当（ledcs & ledwrite）时才会对ledout做刷新，否则保持不变。

#### 3.Tubs

（1）子模块功能：完成七段数码显示管的显示。

（2）行为与时钟的关系：时序逻辑，敏感于时钟的下降沿。

（3）端口规格：

```verilog
module Tubs(
    input rst,              //复位
    input clk,              //Y18
    //input [1:0] digaddr, // 地址低端
    input [31:0] write_data,      //要显示的数字  
    input digwrite,	        // 写信号
    input digcs,		    // 从memorio来的DIG片选信号   !!!!!!!!!!!!!!!!!
    output [7:0] DIG,       //8个 扫描一个
    output [7:0] Y          //输出的内容
    );
```



（4）其他说明:  rst信号生效时，七段数码显示管会归零。与LED模块类似，为了使CPU在执行非显示指令时不会让之前的显示消失，只有当（digwrite & digcs）时才会对ledout做刷新，否则保持不变。



## 四、问题及总结

### （一）问题&不足

1. 在进行uart串口调试的过程中，可能是由于硬件的原因，曾多次造成电脑蓝屏等异常情况。
2. 该cpu为单周期cpu，硬件利用效率较多周期cpu低， 特别是利用单周期CPU做乘除法运算时退化为多次加减法。
3. 没有整合cache模块。
4. 没有加入pipeline。

### （二）总结

* 在这次的CPUproject中，我们首先利用lab课上完成的CPU组件进行整合，实现了一个简单的单周期CPU，第一次上板时与预期差距较大，后来经过debug发现是IO和Memory的问题，后来在整合uart模式和七段数码显示管模块时错误也集中于IO和Memory中data的提取和传递。
* 

## 开发人员

刘仁杰、朱世博。















