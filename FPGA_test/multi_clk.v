module multi_clk_test(
  input wire clk, 
  output wire[7:0] dbg_inst
); 
  wire dclk; 
  clk_div clk_div0(.clk(clk), 
          .dclk(dclk));

  wire ce; 
  wire[15:0] addr; 
  wire[7:0] inst; 
  decoder decoder0(.dclk(dclk), 
                   .ce(ce), 
                   .addr(addr), 
                   .inst(inst), 
                   .dbg_inst(dbg_inst)); 
  
  wire[15:0] ram_addr; 
  wire[1:0] data; 
  wire ram_ce; 
  inst_fetch inst_fetch0(.clk(clk), 
                         .addr(addr), 
                         .if_ce(ce), 
                         .ram_addr(ram_addr), 
                         .ram_ce(ram_ce), 
                         .din(data), 
                         .inst(inst)); 
  
  fake_ram fake_ram0(.clk(clk), 
                     .addr(ram_addr), 
                     .ce(ram_ce), 
                     .dout(data)); 
endmodule 

module clk_div(
  input wire clk, 
  output wire dclk 
); 
  reg[1:0] cnt; // initial cnt <= 2'b0; 

  always @ (posedge clk) begin 
    cnt <= cnt + 1'b1; 
  end
  assign dclk = cnt[0] & cnt[1]; 
endmodule 

module decoder(
  input wire dclk, 
  output reg ce, 
  output reg[15:0] addr, 
  input wire[7:0] inst, 
  output reg[7:0] dbg_inst
); 
  reg once; 
  
//  initial begin 
//    once <= 1'b0; 
//    ce <= 1'b0; 
//  end 

  always @ (posedge dclk) begin 
    if (once == 1'b0) begin 
      once <= 1'b1; 
      ce <= 1'b1; 
      addr <= 16'b0;       
    end else begin 
      ce <= 1'b0; 
      dbg_inst <= inst; 
    end 
  end 
endmodule 

module inst_fetch(
  input wire clk, 
  input wire[15:0] addr, 
  input wire if_ce, 

  output reg[15:0] ram_addr, 
  output reg ram_ce, 
  input wire[1:0] din, 

  output reg[7:0] inst 
);

  reg[1:0] cnt; 
//  initial begin 
//    ram_ce <= 1'b0; 
//    cnt <= 2'b00; 
//    ram_addr <= 16'b0; 
//  end 
  
//  always @ (addr) begin
//    if (if_ce == 1'b1) begin 
//      ram_ce <= 1'b1;
//      cnt <= 2'b00; 
//      ram_addr <= addr; 
//    end  
//  end 

  always @ (posedge clk) begin 
    if (ram_ce == 1'b1) begin 
      case (cnt) 
        2'b00: begin 
          inst[1:0] <= din; 
          cnt <= cnt + 1'b1; 
          ram_addr <= addr + 16'h1; 
        end 
        2'b01: begin 
          inst[3:2] <= din; 
          cnt <= cnt + 1'b1; 
          ram_addr <= addr + 16'h2; 
        end 
        2'b10: begin 
          inst[5:4] <= din; 
          cnt <= cnt + 1'b1; 
          ram_addr <= addr + 16'h3; 
        end 
        2'b11: begin 
          inst[7:6] <= din; 
          cnt <= cnt + 1'b1; 
          ram_addr <= 16'b0; 
          ram_ce <= 1'b0; 
        end 
        default: begin 
        end 
      endcase 
    end 
  end 
endmodule 

module fake_ram(
  input wire clk, 
  input wire[15:0] addr, 
  input wire ce, 
  output reg[1:0] dout 
);
  reg[1:0] ram[255:0]; 
  initial begin 
    ram[0] <= 2'b01; ram[1] <= 2'b10; 
    ram[2] <= 2'b11; ram[3] <= 2'b11; 
    ram[4] <= 2'b10; ram[5] <= 2'b01; 
    ram[6] <= 2'b01; ram[7] <= 2'b10; 
  end 

  always @ (posedge clk) begin 
    if (ce == 1'b1) begin 
      dout <= ram[addr]; 
    end else begin 
      dout <= 2'b0; 
    end 
  end 
endmodule 