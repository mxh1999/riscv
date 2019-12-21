/**
  in order to test the ability of mem, we just monotonically 
  increment addr. Do write and read periodically. 
*/
module delayed_fetch_test(
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

  clk_div clk_div0(clk, dclk); 
  ram ram0(.clk_in(dclk), 
           .en_in(1'b1), 
           .r_nw_in(wr), 
           .a_in(addr), 
           .d_in(dw), 
           .d_out(dread)); 
  
  // test whether we can get data by writing for one cycle. 
  // read and write repeatedly to adjcent mem addr. 
  initial begin 
    addr <= 17'b0; 
    dw <= 8'b0001; 
    rw <= 1'b0; // write first 
    rst <= 1'b1; 
  end 

  always @ (posedge dclk) begin 
    if (rst == 1'b1) begin 
      rst <= 1'b0; 
    end else begin 
      if (rw == 1'b0) begin 
        // after write, we read. 
        rw <= 1'b1; 
      end else begin 
        // increment and write 
        rw <= 1'b0; 
        addr <= addr + 1'b1; 
        dw <= dw + 1'b1; 
      end 
    end 
  end 
endmodule 

module clk_div(
  input wire clk, 
  output wire dclk 
); 
  reg[26:0] cnt; initial cnt <= 26'b0; 

  always @ (posedge clk) begin 
    cnt <= cnt + 1'b1; 
  end
  assign dclk = cnt[26];  
endmodule 