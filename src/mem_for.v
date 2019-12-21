`include "defines.v"
module mem_for(
	input wire rst,
	input wire clk,
	input wire[`OpCode] opcode_i,
	input wire[`RegBus] addr_i,
	input wire[`RegBus] data_i,
	input wire[`RegAddrBus] wd_i,
	input wire mem_we_i,
	input wire mem_ce_i,
	
	output reg[`RegAddrBus] l_wd,
	output reg l_wreg,
	output reg[`RegBus] l_wdata,
	
	output reg st,
	
	output reg[`DataAddrBus] l_addr,
	output reg le,
	input wire[7:0] l_data,
	output reg[`DataAddrBus] w_addr,
	output reg[7:0] w_data,
	output reg we
);
	reg[3:0] tp;
	reg[`OpCode] op;
	reg[`RegBus] addr;
	reg[`DataBus] data;
	reg[`RegAddrBus] wd;
	
	always @ (posedge clk) begin
		if (rst == `Enable) begin
			l_wd <= `NOPRegAddr;
			l_wreg <= `Disable;
			l_wdata <= `ZeroWord;
			st <= `Disable;
			l_addr <= `ZeroWord;
			le <= `Disable;
			w_addr <= `ZeroWord;
			w_data <= 8'b00000000;
			we <= `Disable;
			tp <= 4'b0000;
			op <= `NoneOpcode;
			data <= `ZeroWord;
			addr <= `ZeroWord;
			wd <= `NOPRegAddr;
		end else if (mem_ce_i == `Enable) begin
			op <= opcode_i;
			addr <= addr_i;
			data <= data_i;
			wd <= wd_i;
			tp <= 4'b0001;
		end	else begin
			case (tp)
			4'b0000:begin//dead
				le <= `Disable;
				l_addr <= `ZeroWord;
				w_addr <= `ZeroWord;
				we <= `Disable;
				w_data <= `ZeroWord;
				l_wd <= `NOPRegAddr;
				l_wreg <= `Disable;
				l_wdata <= `ZeroWord;
				st <= `Disable;
			end
			4'b0001:begin
				st <= `Disable;
				l_wd <= `NOPRegAddr;
				l_wreg <= `Disable;
				l_wdata <= `ZeroWord;
				if (op==7'd15 || op==7'd16 || op==7'd17 || op==7'd18 || op==7'd19) begin
					l_addr <= addr;
					le <= `Enable;
					w_addr <= `ZeroWord;
					w_data <= `ZeroWord;
					we <= `Disable;
				end else begin
					l_addr <= `ZeroWord;
					le <= `Disable;
					w_addr <= `ZeroWord;
					w_data <= `ZeroWord;
					we <= `Disable;
					addr <= addr - 32'h1;
				end
				tp <= 4'b0010;
			end
			4'b0010:begin
				st <= `Disable;
				l_wd <= `NOPRegAddr;
				l_wreg <= `Disable;
				l_wdata <= `ZeroWord;
				addr <= addr + 32'h1;
				tp <= 4'b0011;
			end
			4'b0011:begin
				st <= `Disable;
				l_wd <= `NOPRegAddr;
				l_wreg <= `Disable;
				l_wdata <= `ZeroWord;
				if (op == 7'd15 || op == 7'd16 || op == 7'd17 || op == 7'd18 || op == 7'd19) begin
					data[7:0] <= l_data;
					if (op == 7'd15 || op == 7'd18) begin
						l_addr <= `ZeroWord;
						le <= `Disable;
					end else begin
						l_addr <= addr;
						le <= `Enable;
					end
					w_addr <= `ZeroWord;
					w_data <= `ZeroWord;
					we <= `Disable;
				end else begin
					l_addr <= `ZeroWord;
					le <= `Disable;
					w_addr <= addr;
					w_data <= data[7:0];
					we <= `Enable;
				end
				if (op == 7'd15 || op == 7'd18 || op == 7'd20) begin
					tp <= 4'b1111;
				end else begin
					tp <= 4'b0100;
				end
			end
			4'b0100:begin
				st <= `Disable;
				l_wd <= `NOPRegAddr;
				l_wreg <= `Disable;
				l_wdata <= `ZeroWord;
				addr <= addr + 4'h1;
				tp <= 4'b0101;
			end
			4'b0101:begin
				st <= `Disable;
				l_wd <= `NOPRegAddr;
				l_wreg <= `Disable;
				l_wdata <= `ZeroWord;
				if (op == 7'd15 || op == 7'd16 || op == 7'd17 || op == 7'd18 || op == 7'd19) begin
					data[15:8] <= l_data;
					if (op == 7'd16 || op == 7'd19) begin
						l_addr <= `ZeroWord;
						le <= `Disable;
					end else begin
						l_addr <= addr;
						le <= `Enable;
					end
					w_addr <= `ZeroWord;
					w_data <= `ZeroWord;
					we <= `Disable;
				end else begin
					l_addr <= `ZeroWord;
					le <= `Disable;
					w_addr <= addr;
					w_data <= data[15:8];
					we <= `Enable;
				end
				if (op == 7'd16 || op == 7'd19 || op == 7'd21) begin
					tp <= 4'b1111;
				end else begin
					tp <= 4'b0110;
				end
			end
			4'b0110:begin
				st <= `Disable;
				l_wd <= `NOPRegAddr;
				l_wreg <= `Disable;
				l_wdata <= `ZeroWord;
				addr <= addr + 4'h1;
				tp <= 4'b0111;
			end
			4'b0111:begin
				st <= `Disable;
				l_wd <= `NOPRegAddr;
				l_wreg <= `Disable;
				l_wdata <= `ZeroWord;
				if (op==7'd15 || op==7'd16 || op==7'd17 || op==7'd18 || op==7'd19) begin
					data[23:16] <= l_data;
					l_addr <= addr;
					le <= `Enable;
					w_addr <= `ZeroWord;
					w_data <= `ZeroWord;
					we <= `Disable;
				end else begin
					l_addr <= `ZeroWord;
					le <= `Disable;
					w_addr <= addr;
					w_data <= data[23:16];
					we <= `Enable;
				end
				tp <= 4'b1000;
			end
			4'b1000:begin
				st <= `Disable;
				l_wd <= `NOPRegAddr;
				l_wreg <= `Disable;
				l_wdata <= `ZeroWord;
				addr <= addr + 32'h1;
				tp <= 4'b1001;
			end
			4'b1001:begin
				st <= `Disable;
				l_wd <= `NOPRegAddr;
				l_wreg <= `Disable;
				l_wdata <= `ZeroWord;
				if (op==7'd15 || op==7'd16 || op==7'd17 || op==7'd18 || op==7'd19) begin
					data[31:24] <= l_data;
					l_addr <= `ZeroWord;
					le <= `Disable;
					w_addr <= `ZeroWord;
					w_data <= `ZeroWord;
					we <= `Disable;
				end else begin
					l_addr <= `ZeroWord;
					le <= `Disable;
					w_addr <= addr;
					w_data <= data[31:24];
					we <= `Enable;
				end
				tp <= 4'b1111;
			end
			4'b1111:begin
				l_addr <= `ZeroWord;
				le <= `Disable;
				w_addr <= `ZeroWord;
				w_data <= `ZeroWord;
				we <= `Disable;
				st <= `Enable;
				l_wd <= wd;
				l_wreg <= `Enable;
				case (op)
				7'd15:begin
					l_wdata <= {{25{data[7]}},data[6:0]};
				end
				7'd16:begin
					l_wdata <= {{17{data[15]}},data[14:0]};
				end
				7'd17:begin
					l_wdata <= data;
				end
				7'd18:begin
					l_wdata <= {{24{1'b0}},data[7:0]};
				end
				7'd19:begin
					l_wdata <= {{16{1'b0}},data[15:0]};
				end
				endcase
				tp <= 4'b0000;
			end
			endcase
		end
	end
endmodule