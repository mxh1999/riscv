`include "defines.v"

module ctrl(
	input wire rst,
	input wire stallreq_stop,
	input wire stallreq_start1,
	input wire stallreq_start2,
	output reg stall
);

	always @ (*)
	begin
		if (rst == `Enable) begin
			stall = 1'b0;
		end else
		begin
			if (stallreq_stop == `Enable) begin
				stall = 1'b1;
			end else if (stallreq_start1 == `Enable || stallreq_start2 == `Enable) begin
				stall <= 1'b0;
			end
		end
	end
	
endmodule