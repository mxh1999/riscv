`include "defines.v"
module ex(
	input wire rst,
	input wire[`OpCode] opcode_i,
	input wire[`RegBus] reg1_i,
	input wire[`RegBus] reg2_i,
	input wire[`RegAddrBus] wd_i,
	input wire wreg_i,
	input wire[`InstAddrBus] pc_i,
	input wire[`RegBus] imm_i,
	
	output reg stallres,
	output reg[`RegAddrBus] wd_o,
	output reg wreg_o,
	output reg[`RegBus] wdata_o,
	output reg[`OpCode] opcode_o,
	output reg[`DataAddrBus] mem_addr_o,
	
	output reg branch_flag_o,
	output reg [`InstAddrBus] branch_addr_o
);
	always @ (*) begin
		stallres = `Disable;
		opcode_o = opcode_i;
		if (rst == `Enable) begin
			opcode_o = `NoneOpcode;
			wdata_o = `ZeroWord;
			wd_o = `NOPRegAddr;
			wreg_o = `Disable;
			mem_addr_o = `ZeroWord;
			branch_addr_o = `ZeroWord;
			branch_flag_o = `Disable;
		end else begin
			opcode_o = opcode_i;
			wd_o = wd_i;
			wdata_o = `ZeroWord;
			wreg_o = wreg_i;
			mem_addr_o = `ZeroWord;
			branch_addr_o = `ZeroWord;
			branch_flag_o = `Disable;
			case (opcode_i)
			7'd1:begin	//add
				wdata_o = reg1_i + reg2_i;
			end
			7'd2:begin	//sub
				wdata_o = reg1_i - reg2_i;
			end
			7'd3:begin	//sll
				wdata_o = reg1_i << reg2_i[4:0];
			end
			7'd4:begin	//slt
				wdata_o = ($signed(reg1_i) < $signed(reg2_i)) ? 1'b1: 1'b0;
			end
			7'd5:begin	//sltu
				wdata_o = (reg1_i < reg2_i) ? 1'b1 : 1'b0;
			end
			7'd6:begin	//srl
				wdata_o = reg1_i >> reg2_i[4:0];
			end
			7'd7:begin	//sra
				wdata_o = $signed(reg1_i) >>> reg2_i[4:0];
			end
			7'd8:begin	//xor
				wdata_o = reg1_i ^ reg2_i;
			end
			7'd9:begin	//or
				wdata_o = reg1_i | reg2_i;
			end
			7'd10:begin	//and
				wdata_o = reg1_i & reg2_i;
			end
			7'd11:begin	//lui
				wdata_o = reg1_i;
			end
			7'd12:begin	//auipc
				wdata_o = reg1_i + pc_i;
			end
			7'd13:begin	//jal
				branch_addr_o = pc_i + reg1_i;
				branch_flag_o = `Enable;
				wdata_o = pc_i + 4'h4;
				stallres = `Enable;
			end
			7'd14:begin	//jalr
				branch_addr_o = imm_i + reg1_i;
				branch_addr_o[0]=1'b0;
				branch_flag_o = `Enable;
				wdata_o = pc_i + 4'h4;
				stallres = `Enable;
			end
			7'd15:begin	//lb
				mem_addr_o = reg1_i + imm_i;
			end
			7'd16:begin	//lh
				mem_addr_o = reg1_i + imm_i;
			end
			7'd17:begin	//lw
				mem_addr_o = reg1_i + imm_i;
			end
			7'd18:begin	//lbu
				mem_addr_o = reg1_i + imm_i;
			end
			7'd19:begin	//lhu
				mem_addr_o = reg1_i + imm_i;
			end
			7'd20:begin //sb
				mem_addr_o = reg1_i + imm_i;
				wdata_o = reg2_i;
			end
			7'd21:begin	//sh
				mem_addr_o = reg1_i + imm_i;
				wdata_o = reg2_i;
			end
			7'd22:begin	//sw
				mem_addr_o = reg1_i + imm_i;
				wdata_o = reg2_i;
			end
			7'd23:begin	//beq
				if (reg1_i == reg2_i) begin
					branch_addr_o = pc_i + imm_i;
					branch_flag_o = `Enable;
				end
				stallres = `Enable;
			end
			7'd24:begin	//bne
				if (reg1_i != reg2_i) begin
					branch_addr_o = pc_i + imm_i;
					branch_flag_o = `Enable;
				end
				stallres = `Enable;
			end
			7'd25:begin	//blt
				if (reg1_i < reg2_i) begin
					branch_addr_o = pc_i + imm_i;
					branch_flag_o = `Enable;
				end
				stallres = `Enable;
			end
			7'd26:begin	//bge
				if (reg1_i >= reg2_i) begin
					branch_addr_o = pc_i + imm_i;
					branch_flag_o = `Enable;
				end
				stallres = `Enable;
			end
			7'd27:begin	//bltu
				if ($unsigned(reg1_i) < $unsigned(reg2_i)) begin
					branch_addr_o = pc_i + imm_i;
					branch_flag_o = `Enable;
				end
				stallres = `Enable;
			end
			7'd28:begin	//bgeu
				if ($unsigned(reg1_i) >= $unsigned(reg2_i)) begin
					branch_addr_o = pc_i + imm_i;
					branch_flag_o = `Enable;
				end
				stallres = `Enable;
			end
			endcase
		end
	end
endmodule