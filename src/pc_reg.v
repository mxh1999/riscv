`include "defines.v"
module pc_reg(
	input wire clk,
	input wire rst,
	input wire stall,
	input wire branch_flag_i,
	input wire[`InstAddrBus] branch_addr_i,
	input wire[7:0] data_from_mem,

	output reg[`InstAddrBus] pc_to_mem,
	output reg[`InstAddrBus] pc,
	output reg ce,
	output reg[`InstBus] if_inst
);
	
	reg[`InstAddrBus] now_pc;
	reg[3:0] tp;
	reg[`InstBus] inst;
	
	always @ (posedge clk) begin
		if (rst == `Enable)	begin
			tp <=4'b0000;
			now_pc <= `ZeroWord;
			inst <= `ZeroWord;
			pc <= `ZeroWord;
			ce <= `Disable;
			pc_to_mem <= `ZeroWord;
			if_inst <= `ZeroWord;
		end	else if (stall == `NoStop) begin
			if (branch_flag_i == `Branch) begin
				now_pc <= branch_addr_i;
				pc_to_mem <= branch_addr_i;
				ce <= `Enable;
				tp <= 4'b1000;
				pc <= `ZeroWord;
				if_inst <= `ZeroWord;
			end else begin
				case (tp)
				4'b0000:begin
					now_pc <= pc_to_mem;
					pc <= `ZeroWord;
					if_inst <= `ZeroWord;
					ce <= `Enable;
					tp <= 4'b1000;
				end
				4'b1000:begin
					ce <= `Disable;
					tp <= 4'b0001;
				end
				4'b0001:begin
					ce <= `Enable;
					inst[7:0] <= data_from_mem;
					pc_to_mem <= pc_to_mem + 4'h1;
					pc <= `ZeroWord;
					if_inst <= `ZeroWord;
					tp <= 4'b1001;
				end
				4'b1001:begin
					ce <= `Disable;
					tp <= 4'b0010;
				end
				4'b0010:begin
					ce <= `Enable;
					inst[15:8] <= data_from_mem;
					pc_to_mem <= pc_to_mem + 4'h1;
					pc <= `ZeroWord;
					if_inst <= `ZeroWord;
					tp <= 4'b1010;
				end
				4'b1010:begin
					ce <= `Disable;
					tp <= 4'b0011;
				end
				4'b0011:begin
					ce <= `Enable;
					inst[23:16] <= data_from_mem;
					pc_to_mem <= pc_to_mem + 4'h1;
					pc <= `ZeroWord;
					if_inst <= `ZeroWord;
					tp <= 4'b1011;
				end
				4'b1011:begin
					ce <= `Disable;
					tp <= 4'b0100;
				end
				4'b0100:begin
					ce <= `Enable;
					inst[31:24] <= data_from_mem;
					pc_to_mem <= pc_to_mem + 4'h1;
					pc <= now_pc;
					if_inst <= {data_from_mem,inst[23:0]};
					tp <= 4'b0000;
				end
				endcase
			end
		end else begin
			tp <=4'b0000;
			pc_to_mem <= now_pc;
			inst <= `ZeroWord;
			ce <= `Disable;
		end
	end
endmodule