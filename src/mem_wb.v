`include "defines.v"
module mem_wb(
	input wire clk,
	input wire rst,
	
	input wire[`RegAddrBus] mem_wd,
	input wire mem_wreg,
	input wire[`RegBus] mem_wdata,
	
	input wire[`RegAddrBus] l_wd,
	input wire l_wreg,
	input wire[`RegBus] l_wdata,
	
	input wire st,
	
	output reg[`RegAddrBus] wb_wd,
	output reg wb_wreg,
	output reg[`RegBus] wb_wdata,
	
	output reg stallres
);

always @ (posedge clk)
begin
	if (rst == `Enable) begin
		wb_wd <= `NOPRegAddr;
		wb_wreg <= `Disable;
		wb_wdata <= `ZeroWord;
		stallres <= `Disable;
	end else if (l_wreg == `Enable) begin
		wb_wd <= l_wd;
		wb_wreg <= l_wreg;
		wb_wdata <= l_wdata;
		stallres <= `Enable;
	end else begin
		wb_wd <= mem_wd;
		wb_wreg <= mem_wreg;
		wb_wdata <= mem_wdata;
		//stallres <= `Enable;
		if (st == `Enable) begin
			stallres <= `Enable;
		end else begin
			stallres <= `Disable;
		end
	end
end

endmodule