This is a folder for myself riscv source code compilation. 

It use a makefile to invoke riscv compilation toolchain installed in /opt/riscv/bin. The toolchain compiles .s code to both .bin and .data, of which the .bin file can be used by FPGA controller and .data can be examined directly. 

command:
1. make name.bin  # you get .bin file 
2. make name.data # you get .data file 

Tests with '_' are designed by WuZH.

Debug log: 
1. in _ld_st.s test, I fail to distinguish signed/unsigned extension in LOAD instruction. I have passed! 
2. in _ld_stall.s test, I make a mistake on MEM LOAD data hazard. I should have wired EX's input aluop back to ID, but I actually wire EX's output aluop back to ID, which leads to one clock cycle mis-matching. assign fwregMEM_ID_i = wreg_MEM_i;assign fwaddrMEM_ID_i = wbaddr_MEM_i; assign fwdataMEM_ID_i = wbdata_MEM_o; 
3. **My MEM module is kind of special, because it behaves like a 粗颗粒度的 combinational logic. The usual combinational logic responds to outer input driver instantly, but my MEM only responds at posedge of faster clock. It cannot respond to outer driver at the posedge but with a little bit latent.**