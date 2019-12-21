`include "defines.v"

module bf_ram(
	input wire[`InstAddrBus] if_addr,
	input wire ce,
	output reg[7:0] if_data,
	input wire[`InstAddrBus] l_addr,
	input wire le,
	output reg[7:0] l_data,
	input wire[`InstAddrBus] w_addr,
	input wire[7:0] w_data,
	input wire we,
	
	input  wire[7:0] mem_din,
    output reg[7:0] mem_dout,
    output reg[31:0] mem_addr,
    output reg mem_wr
);
	always @ (*) begin
		if (we == `Enable) begin
			mem_addr = w_addr;
			mem_dout = w_data;
			mem_wr = 1'b1;
		end else begin
			mem_wr = 1'b0;
			if (le == `Enable) begin
				mem_addr = l_addr;
			end else if (ce == `Enable) begin
				mem_addr = if_addr;
			end
		end
	end
	
	always @ (*) begin
		if_data = mem_din;
		l_data = mem_din;
	end
	
endmodule