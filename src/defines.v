`define Enable		1'b1
`define Disable		1'b0
`define ZeroWord	32'h0	//32bit0

`define OpCode 6:0
`define Funct3 2:0
`define Funct7 6:0
`define NoneOpcode 7'b0000000
`define NoneFun3 3'b000
`define NoneFun7 7'b0000000

`define AluOpBus	7:0		//译码阶段输出aluop_o的宽度
`define AluSelBus	2:0		//译码阶段输出alusel_o的宽度
`define InstValid	1'b0	//指令有效
`define InstInvalid	1'b1	//指令无效
`define True_v		1'b1	
`define False_v		1'b0

`define InstAddrBus	31:0	//ROM地址总线宽度
`define InstBus		31:0	//ROM数据总线宽度
`define InstMemNum	131071	//ROM实际大小128K
`define InstMemLog2	17

`define RegAddrBus	4:0		//Regfile地址线宽度
`define RegBus		31:0	//Regfile数据线宽度
`define RegWidth	32		//通用寄存器宽度
`define DoubleRegWidth	64	//两倍通用寄存器宽度
`define DoubleRegBus 63:0	//两倍通用寄存器数据线宽度
`define RegNum		32		//通用寄存器数量
`define RegNumLog2	5		//寻址寄存器所用的地址位数
`define NOPRegAddr	5'b00000

`define Branch 1'b1
`define NotBranch 1'b0
`define Stop 1'b1
`define NoStop 1'b0

`define Mask 3:0
`define NoneMask 4'b0000

`define DataAddrBus 31:0
`define DataBus 31:0
`define DataMemNum 131071
`define DataMemNumLog2 17