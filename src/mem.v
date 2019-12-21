`include "defines.v"
module mem(
	input wire rst,
	input wire[`RegAddrBus] wd_i,
	input wire wreg_i,
    input wire[`RegBus] wdata_i,
	input wire[`OpCode] opcode_i,
	input wire[`DataAddrBus] mem_addr_i,
	
	output reg[`RegAddrBus] wd_o,
	output reg wreg_o,
    output reg[`RegBus] wdata_o,
	output reg[`DataAddrBus] mem_addr_o,
	output reg[`RegBus] mem_data_o,
	output reg[`RegAddrBus] mem_wd,
	output reg [`OpCode] opcode_o,
	output reg mem_we_o,
	output reg mem_ce_o
);
	
	always @ (*) begin
		if (rst == `Enable)
		begin
			wd_o = `NOPRegAddr;
			opcode_o = `NoneOpcode;
			wreg_o = `Disable;
			wdata_o = `ZeroWord;
			mem_addr_o = `ZeroWord;
			mem_we_o = `Disable;
			mem_data_o = `ZeroWord;
			mem_ce_o = `Disable;
			mem_wd = `NOPRegAddr;
		end else
		begin
			wd_o = wd_i;
			wreg_o = wreg_i;
			opcode_o = opcode_i;
			wdata_o = wdata_i;
			mem_we_o = `Disable;
			mem_addr_o = `ZeroWord;
			mem_ce_o = `Disable;
			mem_wd = `NOPRegAddr;
			case (opcode_i)
				7'd15:begin	//lb
					mem_addr_o = mem_addr_i[31:0];
					mem_we_o = `Disable;
					mem_ce_o = `Enable;
					mem_wd = wd_i;
					wreg_o = `Disable;
				end
				7'd16:begin	//lh
					mem_addr_o = mem_addr_i[31:0];
					mem_we_o = `Disable;
					mem_ce_o = `Enable;
					mem_wd = wd_i;
					wreg_o = `Disable;
				end
				7'd17:begin	//lw
					mem_addr_o = mem_addr_i[31:0];
					mem_we_o = `Disable;
					mem_ce_o = `Enable;
					mem_wd = wd_i;
					wreg_o = `Disable;
				end
				7'd18:begin //lbu
					mem_addr_o = mem_addr_i[31:0];
					mem_we_o = `Disable;
					mem_ce_o = `Enable;
					mem_wd = wd_i;
					wreg_o = `Disable;
				end
				7'd19:begin	//lhu
					mem_addr_o = mem_addr_i[31:0];
					mem_we_o = `Disable;
					mem_ce_o = `Enable;
					mem_wd = wd_i;
					wreg_o = `Disable;
				end
				7'd20:begin	//sb
					mem_addr_o = mem_addr_i[31:0];
					mem_we_o = `Enable;
					mem_ce_o = `Enable;
					mem_data_o = wdata_i;
				end
				7'd21:begin	//sh
					mem_addr_o = mem_addr_i[31:0];
					mem_we_o = `Enable;
					mem_ce_o = `Enable;
					mem_data_o = wdata_i;
				end
				7'd22:begin	//sw
					mem_addr_o = mem_addr_i[31:0];
					mem_we_o = `Enable;
					mem_ce_o = `Enable;
					mem_data_o = wdata_i;
				end
			endcase
		end
	end

endmodule