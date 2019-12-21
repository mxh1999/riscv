module regfile(
	input wire clk,
	input wire rst,
	input wire we,	//能否写
	input wire[`RegAddrBus] waddr,	//写入寄存器地址
	input wire[`RegBus]		wdata,	//写入寄存器的数据
	input wire re1,
	input wire[`RegAddrBus]	raddr1,
	output reg[`RegBus]		rdata1,
	input wire re2,
	input wire[`RegAddrBus]	raddr2,
	output reg[`RegBus]		rdata2
);

	reg[`RegBus] regs[0:`RegNum-1];
	integer i;
	always @ (posedge clk)
	begin
		if (rst == `Enable)	begin
			for (i=0;i<=31;i=i+1)	regs[i] <= 0;
		end else begin
			if ((we == `Enable)	&& (waddr != `RegNumLog2'h0))
				regs[waddr] <= 	wdata;
		end
	end

	always @ (*)
	begin
		if (rst == `Enable)
		begin
			rdata1 <= `ZeroWord;
		end else if (raddr1 == `RegNumLog2'h0)	begin
			rdata1 <= `ZeroWord;
		end else if ((raddr1 == waddr) && (we == `Enable) && (re1 == `Enable))	begin
			rdata1 <= wdata;
		end else if (re1 == `Enable) begin
			rdata1 <= regs[raddr1];
		end else begin
			rdata1 <= `ZeroWord;
		end
	end

	always @ (*)
	begin
		if (rst == `Enable)
		begin
			rdata2 <= `ZeroWord;
		end else if (raddr2 == `RegNumLog2'h0)	begin
			rdata2 <= `ZeroWord;
		end else if ((raddr2 == waddr) && (we == `Enable) && (re2 == `Enable))	begin
			rdata2 <= wdata;
		end else if (re2 == `Enable) begin
			rdata2 <= regs[raddr2];
		end else begin
			rdata2 <= `ZeroWord;
		end
	end

endmodule