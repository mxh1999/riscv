module LED(
  input wire s1, 
  input wire s2, 
  output wire led
); 
  assign led = s1 ^ s2; 
endmodule 