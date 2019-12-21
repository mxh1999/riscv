
module fetch_test(
  input wire clk, 
  output wire rw_sig, 
  output wire[7:0] dread // output data read 
); 
	wire dclk; 
  reg rw; // 1 for read, 0 for write 
  reg[16:0] addr; 
  reg[7:0] dw; 
  reg rst; // define reset signal to synchronize starting up. 
  assign rw_sig = rw; 

  ram ram0(.clk_in(clk), 
           .en_in(1'b1), 
           .r_nw_in(wr), 
           .a_in(addr), 
           .d_in(dw), 
           .d_out(dread)); 
  
  // test whether we can get data by writing for one cycle. 
  // read and write repeatedly to adjcent mem addr. 
  initial begin 
    addr <= 17'b0; 
    dw <= 8'b10011101; 
    rw <= 1'b1; // read first 
    rst <= 1'b1; 
  end 

  always @ (posedge clk) begin 
    if (rst == 1'b1) begin 
      rst <= 1'b0; 
      rw <= 1'b1; // write for exactly one cycle. 
    end else begin 
      rw <= 1'b1; // remain read. 
    end 
  end 
endmodule 
