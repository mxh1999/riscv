`include "defines.v"
module id_ex(
	input wire clk,
	input wire rst,
	input wire branch_flag_i,
	input wire[`InstAddrBus] id_pc,
	input wire[`OpCode] id_opcode,
	input wire[`RegBus] id_reg1,
	input wire[`RegBus] id_reg2,
	input wire[`RegAddrBus] id_wd,
	input wire id_wreg,
	input wire[`RegBus] id_imm,
	
	output reg[`InstAddrBus] ex_pc,
	output reg[`OpCode] ex_opcode,
	output reg[`RegBus] ex_reg1,
	output reg[`RegBus] ex_reg2,
	output reg[`RegAddrBus] ex_wd,
	output reg[`RegBus] ex_imm,
	output reg ex_wreg
);

	always @ (posedge clk)
	begin
		if (rst == `Enable || branch_flag_i == `Enable)
		begin
			ex_opcode <= 7'b0000000;
			ex_reg1 <= `ZeroWord;
			ex_reg2 <= `ZeroWord;
			ex_imm <= `ZeroWord;
			ex_wd <= `NOPRegAddr;
			ex_wreg <= `Disable;
			ex_pc <= `ZeroWord;
		end else begin
			ex_opcode <= id_opcode;
			ex_reg1 <= id_reg1;
			ex_reg2 <= id_reg2;
			ex_wd <= id_wd;
			ex_wreg <= id_wreg;
			ex_pc <= id_pc;
			ex_imm <= id_imm;
		end
	end
endmodule