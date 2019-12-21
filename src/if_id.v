`include "defines.v"
module if_id(
	input wire clk,
	input wire rst,
	input wire stall,
	input wire[`InstAddrBus] if_pc,
	input wire[`InstBus] if_inst,
	input wire branch_flag_i,
	output reg[`InstAddrBus] id_pc,
	output reg[`InstBus] id_inst
);

	always @ (posedge clk)
	begin
		if (rst == `Enable) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		end else if (branch_flag_i == `Branch) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		end else if (stall == `NoStop) begin
			id_pc <= if_pc;
			id_inst <= if_inst;
		end else begin 
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		end
	end
endmodule