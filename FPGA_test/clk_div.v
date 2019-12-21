module dclk_test(
  input wire clk, 
  output wire[2:0] dgt
); 
	wire dclk; 
  clk_div clk_div0(clk, dclk); 
  fetch fetch0(dclk, dgt); 
endmodule 

module fetch(
  input wire dclk, 
  output reg[2:0] dgt 
); 
  initial dgt <= 3'b0; 
  always @ (posedge dclk) begin 
    dgt <= dgt + 1'b1; 
  end 
endmodule 

module clk_div(
  input wire clk, 
  output wire dclk 
); 
  reg[27:0] cnt; initial cnt <= 28'b0; 

  always @ (posedge clk) begin 
    cnt <= cnt + 1'b1; 
  end
  assign dclk = cnt[27];  
endmodule 