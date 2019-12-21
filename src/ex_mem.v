module ex_mem(
	input wire clk,
	input wire rst,
	input wire[`RegAddrBus] ex_wd,
	input wire ex_wreg,
	input wire[`RegBus] ex_wdata,
	input wire[`OpCode] ex_opcode,
	input wire[`DataAddrBus] ex_mem_addr,
	
	output reg[`RegAddrBus] mem_wd,
	output reg mem_wreg,
	output reg[`RegBus] mem_wdata,
	output reg[`OpCode] mem_opcode,
	output reg[`DataAddrBus] mem_mem_addr
);

	always @ (posedge clk)
	begin
		if (rst == `Enable)
		begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `Disable;
			mem_wdata <= `ZeroWord;
			mem_opcode <= `NoneOpcode;
			mem_mem_addr <= `ZeroWord;
		end else begin
			mem_wd <= ex_wd;
			mem_wreg <= ex_wreg;
			mem_wdata <= ex_wdata;
			mem_opcode <= ex_opcode;
			mem_mem_addr <= ex_mem_addr;
		end
	end

endmodule