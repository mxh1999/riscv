`include "defines.v"
module id(
	input wire rst,
	input wire branch_flag_i,
	input wire[`InstAddrBus] pc_i,
	input wire[`InstBus] inst_i,
	
	input wire ex_wreg_i,
	input wire[`RegBus] ex_wdata_i,
	input wire[`RegAddrBus] ex_wd_i,
	
	input wire mem_wreg_i,
	input wire[`RegBus] mem_wdata_i,
	input wire[`RegAddrBus] mem_wd_i,
	
	input wire[`RegBus] reg1_data_i,
	input wire[`RegBus] reg2_data_i,
	
	output reg[`InstAddrBus] pc_o,
	output reg reg1_read_o,
	output reg reg2_read_o,
	output reg[`RegAddrBus] reg1_addr_o,
	output reg[`RegAddrBus] reg2_addr_o,
	
	output reg[`OpCode] opcode_o,
	output reg[`RegBus] reg1_o,
	output reg[`RegBus] reg2_o,
	output reg[`RegAddrBus] wd_o,
	output reg wreg_o,
	output reg[`RegBus] imm,
	
	output reg stallreq
);

	wire[6:0] op1=inst_i[6:0];
	wire[2:0] op2=inst_i[14:12];
	wire[6:0] op3=inst_i[31:25];
	
	wire [`RegBus] imm_jal;
	wire [`RegBus] imm_jalr;
	wire [`RegBus] imm_b;
	assign imm_jal = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
	assign imm_jalr = {{20{inst_i[31]}}, inst_i[31:20]};
	assign imm_b = {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
	
	always @ (*) begin
		stallreq = `Disable;
		pc_o = pc_i;
		if (rst == `Enable || branch_flag_i == `Branch) begin
			pc_o = `ZeroWord;
			opcode_o = 7'b0000000;
			reg1_o = `ZeroWord;
			reg2_o = `ZeroWord;
			wd_o = `NOPRegAddr;
			wreg_o = `Disable;
			reg1_read_o = `Disable;
			reg2_read_o = `Disable;
			reg1_addr_o = `NOPRegAddr;
			reg2_addr_o = `NOPRegAddr;
			imm = `ZeroWord;
		end else begin
			opcode_o = 7'b0000000;
			reg1_o = `ZeroWord;
			reg2_o = `ZeroWord;
			wd_o = `NOPRegAddr;
			wreg_o = `Disable;
			reg1_read_o = `Disable;
			reg2_read_o = `Disable;
			reg1_addr_o = `NOPRegAddr;
			reg2_addr_o = `NOPRegAddr;
			imm = `ZeroWord;
			wd_o = inst_i[11:7];
			wreg_o = `Disable;
			reg1_read_o = `Disable;
			reg2_read_o = `Disable;
			reg1_addr_o = inst_i[19:15];
			reg2_addr_o = inst_i[24:20];
			imm = `ZeroWord;
			case (op1)
			7'b0110011:begin		//add,sub,sll,slt,sltu,xor,srl,sra,or,and
				wreg_o = `Enable;
				case (op2)
					3'b000:begin	//add,sub
						opcode_o = (op3 == 7'b0000000) ? (7'd1) : (7'd2);
					end
					3'b001:begin	//sll
						opcode_o = 7'd3;
					end
					3'b010:begin	//slt
						opcode_o = 7'd4;
					end
					3'b011:begin	//sltu
						opcode_o = 7'd5;
					end
					3'b100:begin	//xor
						opcode_o = 7'd8;
					end
					3'b101:begin	//srl,sra
						opcode_o = (op3 == 7'b0000000) ? 7'd6: 7'd7;
					end
					3'b110:begin	//or
						opcode_o = 7'd9;
					end
					3'b111:begin	//and
						opcode_o = 7'd10;
					end
				endcase
				reg1_read_o = `Enable;
				reg2_read_o = `Enable;
				//stallreq = `Enable;
			end
			7'b0010011:begin	//andi,slti,sltiu,xori,ori,andi,slli,srli,srai
				wreg_o = `Enable;
				case (op2)
					3'b000:begin	//addi
						imm = {{21{inst_i[31]}},inst_i[30:20]};
						opcode_o = 7'd1;
					end
					3'b010:begin	//slti
						imm = {{21{inst_i[31]}},inst_i[30:20]};
						opcode_o = 7'd4;
					end
					3'b011:begin	//sltiu
						imm = {20'b0,inst_i[31:20]};
						opcode_o = 7'd4;
					end
					3'b100:begin	//xori
						imm = {{21{inst_i[31]}},inst_i[30:20]};
						opcode_o = 7'd8;
					end
					3'b110:begin	//ori
						imm = {{21{inst_i[31]}},inst_i[30:20]};
						opcode_o = 7'd9;
					end
					3'b111:begin	//andi
						imm = {{21{inst_i[31]}},inst_i[30:20]};
						opcode_o = 7'd10;
					end
					3'b001:begin	//slli
						imm = {27'b0,inst_i[24:20]};
						opcode_o = 7'd3;
					end
					3'b101:begin	//srli,srai
						imm = {27'b0,inst_i[24:20]};
						opcode_o = (op3 == 7'b0000000) ? 7'd6: 7'd7;
					end
				endcase
				reg1_read_o = `Enable;
				//stallreq = `Enable;
			end
			7'b0110111:begin	//lui
				wreg_o = `Enable;
				imm = {inst_i[31:12],{12{1'b0}}};
				opcode_o = 7'd11;
				//stallreq = `Enable;
			end
			7'b0010111:begin	//auipc
				wreg_o = `Enable;
				imm = {inst_i[31:12],{12{1'b0}}};
				opcode_o = 7'd12;
				//stallreq = `Enable;
			end
			7'b1101111:begin	//jal
				wreg_o = `Enable;
				opcode_o = 7'd13;
				imm = imm_jal;
				stallreq = `Enable;
			end
			7'b1100111:begin	//jalr
				wreg_o = `Enable;
				opcode_o = 7'd14;
				imm = imm_jalr;
				reg1_read_o = `Enable;
				stallreq = `Enable;
			end
			7'b1100011:begin	//beq,bne,blt,bltu,bge,bgeu
				wreg_o = `Disable;
				wd_o = `NOPRegAddr;
				opcode_o = 7'd0;
				reg1_read_o = `Enable;
				reg2_read_o = `Enable;
				imm = imm_b;
				stallreq = `Enable;
				case (op2)
				3'b000:begin	//beq
					opcode_o = 7'd23;
					
				end
				3'b001:begin	//bne
					opcode_o = 7'd24;
				end
				3'b100:begin	//blt
					opcode_o = 7'd25;
				end
				3'b101:begin	//bge
					opcode_o = 7'd26;
				end
				3'b110:begin	//bltu
					opcode_o = 7'd27;
				end
				3'b111:begin	//bgeu
					opcode_o = 7'd28;
				end
				endcase
			end
			7'b0000011:begin	//lb,lh,lw,lbu,lhu
				wreg_o = `Enable;
				reg1_read_o = `Enable;
				imm = {{21{inst_i[31]}},inst_i[30:20]};
				stallreq = `Enable;
				case (op2)
				3'b000:begin	//lb
					opcode_o = 7'd15;
				end
				3'b001:begin	//lh
					opcode_o = 7'd16;
				end
				3'b010:begin	//lw
					opcode_o = 7'd17;
				end
				3'b100:begin	//lbu
					opcode_o = 7'd18;
				end
				3'b101:begin	//lhu
					opcode_o = 7'd19;
				end
				endcase
			end
			7'b0100011:begin	//sb,sh,sw
				reg1_read_o = `Enable;
				reg2_read_o = `Enable;
				imm = {{21{inst_i[31]}},inst_i[30:25],inst_i[11:7]};
				stallreq = `Enable;
				case (op2)
				3'b000:begin	//sb
					opcode_o = 7'd20;
				end
				3'b001:begin	//sh
					opcode_o = 7'd21;
				end
				3'b010:begin	//sw
					opcode_o = 7'd22;
				end
				endcase
			end
			endcase
		end
	end
	
	always @ (*) begin
		if (rst== `Enable) begin
			reg1_o = `ZeroWord;
		end else if ((reg1_read_o == `Enable) && (ex_wreg_i == `Enable) && (ex_wd_i == reg1_addr_o) && (ex_wd_i != 5'b00000)) begin
			reg1_o = ex_wdata_i;
		end else if ((reg1_read_o == `Enable) && (mem_wreg_i == `Enable) && (mem_wd_i == reg1_addr_o) && (mem_wd_i != 5'b00000)) begin
			reg1_o = mem_wdata_i;
		end else if (reg1_read_o == `Enable) begin
			reg1_o = reg1_data_i;
		end else if (reg1_read_o == `Disable) begin
			reg1_o = imm;
		end else begin
			reg1_o = `ZeroWord;
		end
	end
	always @ (*) begin
		if (rst== `Enable) begin
			reg2_o = `ZeroWord;
		end else if ((reg2_read_o == `Enable) && (ex_wreg_i == `Enable) && (ex_wd_i == reg2_addr_o) && (ex_wd_i != 5'b00000)) begin
			reg2_o = ex_wdata_i;
		end else if ((reg2_read_o == `Enable) && (mem_wreg_i == `Enable) && (mem_wd_i == reg2_addr_o) && (mem_wd_i != 5'b00000)) begin
			reg2_o = mem_wdata_i;
		end else if (reg2_read_o == `Enable) begin
			reg2_o = reg2_data_i;
		end else if (reg2_read_o == `Disable) begin
			reg2_o = imm;
		end else begin
			reg2_o = `ZeroWord;
		end
	end
endmodule