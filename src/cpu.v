// RISCV32I CPU top module
// port modification allowed for debugging purposes

module cpu(
    input  wire                 clk_in,			// system clock signal
    input  wire                 rst_in,			// reset signal
	  input  wire					        rdy_in,			// ready signal, pause cpu when low

    input  wire [ 7:0]          mem_din,		// data input bus
    output wire [ 7:0]          mem_dout,		// data output bus
    output wire [31:0]          mem_a,			// address bus (only 17:0 is used)
    output wire                 mem_wr,			// write/read signal (1 for write)

	output wire [31:0]			dbgreg_dout		// cpu register output (debugging demo)
);

// implementation goes here

// Specifications:
// - Pause cpu(freeze pc, registers, etc.) when rdy_in is low
// - Memory read takes 2 cycles(wait till next cycle), write takes 1 cycle(no need to wait)
// - Memory is of size 128KB, with valid address ranging from 0x0 to 0x20000
// - I/O port is mapped to address higher than 0x30000 (mem_a[17:16]==2'b11)
// - 0x30000 read: read a byte from input
// - 0x30000 write: write a byte to output (write 0x00 is ignored)
// - 0x30004 read: read clocks passed since cpu starts (in dword, 4 bytes)
// - 0x30004 write: indicates program stop (will output '\0' through uart tx)
	wire stall_i;
	wire ce;
	wire branch_flag;
	wire[`InstAddrBus] branch_addr;
	
	wire[7:0] data_br_if;
	wire[`InstAddrBus] pc_if_br;
	wire[`InstAddrBus] pc_if_ifid;
	wire[`InstBus] inst_if_ifid;
	
	wire[`InstAddrBus] pc_ifid_id;
	wire[`InstBus] inst_ifid_id;
	
	wire[`RegBus] reg1_reg_id;
	wire[`RegBus] reg2_reg_id;
	wire reg1_re_id_reg;
	wire reg2_re_id_reg;
	wire[`RegAddrBus] reg1_addr_id_reg;
	wire[`RegAddrBus] reg2_addr_id_reg;
	wire[`OpCode] opcode_id_idex;
	wire[`RegBus] reg1_id_idex;
	wire[`RegBus] reg2_id_idex;
	wire[`RegAddrBus] wd_id_idex;
	wire wreg_id_idex;
	wire[`RegBus] imm_id_idex;
	wire stall_id_ctrl;
	wire[`InstAddrBus] pc_id_idex;
	
	wire[`InstAddrBus] pc_idex_ex;
	wire[`OpCode] opcode_idex_ex;
	wire[`RegBus] reg1_idex_ex;
	wire[`RegBus] reg2_idex_ex;
	wire[`RegAddrBus] wd_idex_ex;
	wire[`RegBus] imm_idex_ex;
	wire wreg_idex_ex;
	
	wire stall_ex_ctrl;
	wire wreg_ex_exmem;
	wire[`RegBus] data_ex_exmem;
	wire[`RegAddrBus] wd_ex_exmem;
	wire[`OpCode] opcode_ex_exmem;
	wire[`DataAddrBus] mem_addr_ex_exmem;
	
	wire[`RegAddrBus] wd_exmem_mem;
	wire wreg_exmem_mem;
	wire[`RegBus] data_exmem_mem;
	wire[`OpCode] opcode_exmem_mem;
	wire[`DataAddrBus] mem_addr_exmem_mem;
	
	wire wreg_mem_memwb;
	wire[`RegBus] data_mem_memwb;
	wire[`RegAddrBus] wd_mem_memwb;
	wire[`DataAddrBus] mem_addr_mem_for;
	wire[`RegBus] data_mem_for;
	wire[`RegAddrBus] wd_mem_for;
	wire[`OpCode] opcode_mem_for;
	wire we_mem_for;
	wire ce_mem_for;
	
	wire[`RegAddrBus] wd_for_memwb;
	wire wreg_for_memwb;
	wire[`RegBus] data_for_memwb;
	wire stall_for_memwb;
	
	wire[`DataAddrBus] l_addr_for_br;
	wire le_for_br;
	wire[7:0] l_data_for_br;
	wire[`DataAddrBus] w_addr_for_br;
	wire we_for_br;
	wire[7:0] w_data_for_br;
	
	wire[`RegAddrBus] wd_memwb_reg;
	wire wreg_memwb_reg;
	wire[`RegBus] data_memwb_reg;
	wire stall_memwb_ctrl;
	
	pc_reg pc_reg0(
		.clk(clk_in),
		.ce(ce),
		.rst(rst_in),
		.stall(stall_i),
		.branch_flag_i(branch_flag),
		.branch_addr_i(branch_addr),
		.data_from_mem(data_br_if),
		.pc_to_mem(pc_if_br),
		.pc(pc_if_ifid),
		.if_inst(inst_if_ifid)
	);
	if_id if_id0(
		.clk(clk_in),
		.rst(rst_in),
		.stall(stall_i),
		.if_pc(pc_if_ifid),
		.if_inst(inst_if_ifid),
		.branch_flag_i(branch_flag),
		.id_pc(pc_ifid_id),
		.id_inst(inst_ifid_id)
	);
	id id0(
		.rst(rst_in),
		.branch_flag_i(branch_flag),
		.pc_i(pc_ifid_id),
		.inst_i(inst_ifid_id),
		.ex_wreg_i(wreg_ex_exmem),
		.ex_wdata_i(data_ex_exmem),
		.ex_wd_i(wd_ex_exmem),
		.mem_wreg_i(wreg_mem_memwb),
		.mem_wdata_i(data_mem_memwb),
		.mem_wd_i(wd_mem_memwb),
		.reg1_data_i(reg1_reg_id),
		.reg2_data_i(reg2_reg_id),
		.pc_o(pc_id_idex),
		.reg1_read_o(reg1_re_id_reg),
		.reg2_read_o(reg2_re_id_reg),
		.reg1_addr_o(reg1_addr_id_reg),
		.reg2_addr_o(reg2_addr_id_reg),
		.opcode_o(opcode_id_idex),
		.reg1_o(reg1_id_idex),
		.reg2_o(reg2_id_idex),
		.wd_o(wd_id_idex),
		.wreg_o(wreg_id_idex),
		.imm(imm_id_idex),
		.stallreq(stall_id_ctrl)
	);
	id_ex id_ex0(
		.clk(clk_in),
		.rst(rst_in),
		.branch_flag_i(branch_flag),
		.id_pc(pc_id_idex),
		.id_opcode(opcode_id_idex),
		.id_reg1(reg1_id_idex),
		.id_reg2(reg2_id_idex),
		.id_wd(wd_id_idex),
		.id_wreg(wreg_id_idex),
		.id_imm(imm_id_idex),
		.ex_pc(pc_idex_ex),
		.ex_opcode(opcode_idex_ex),
		.ex_reg1(reg1_idex_ex),
		.ex_reg2(reg2_idex_ex),
		.ex_wd(wd_idex_ex),
		.ex_imm(imm_idex_ex),
		.ex_wreg(wreg_idex_ex)
	);
	ex ex0(
		.rst(rst_in),
		.opcode_i(opcode_idex_ex),
		.reg1_i(reg1_idex_ex),
		.reg2_i(reg2_idex_ex),
		.wd_i(wd_idex_ex),
		.wreg_i(wreg_idex_ex),
		.pc_i(pc_idex_ex),
		.imm_i(imm_idex_ex),
		.stallres(stall_ex_ctrl),
		.wd_o(wd_ex_exmem),
		.wreg_o(wreg_ex_exmem),
		.wdata_o(data_ex_exmem),
		.opcode_o(opcode_ex_exmem),
		.mem_addr_o(mem_addr_ex_exmem),
		.branch_flag_o(branch_flag),
		.branch_addr_o(branch_addr)
	);
	ex_mem ex_mem0(
		.clk(clk_in),
		.rst(rst_in),
		.ex_wd(wd_ex_exmem),
		.ex_wreg(wreg_ex_exmem),
		.ex_wdata(data_ex_exmem),
		.ex_opcode(opcode_ex_exmem),
		.ex_mem_addr(mem_addr_ex_exmem),
		.mem_wd(wd_exmem_mem),
		.mem_wreg(wreg_exmem_mem),
		.mem_wdata(data_exmem_mem),
		.mem_opcode(opcode_exmem_mem),
		.mem_mem_addr(mem_addr_exmem_mem)
	);
	mem mem0(
		.rst(rst_in),
		.wd_i(wd_exmem_mem),
		.wreg_i(wreg_exmem_mem),
		.wdata_i(data_exmem_mem),
		.opcode_i(opcode_exmem_mem),
		.mem_addr_i(mem_addr_exmem_mem),
		.wd_o(wd_mem_memwb),
		.wreg_o(wreg_mem_memwb),
		.wdata_o(data_mem_memwb),
		.mem_addr_o(mem_addr_mem_for),
		.mem_data_o(data_mem_for),
		.mem_wd(wd_mem_for),
		.opcode_o(opcode_mem_for),
		.mem_we_o(we_mem_for),
		.mem_ce_o(ce_mem_for)
	);
	mem_for mem_for0(
		.rst(rst_in),
		.clk(clk_in),
		.opcode_i(opcode_mem_for),
		.addr_i(mem_addr_mem_for),
		.data_i(data_mem_for),
		.wd_i(wd_mem_for),
		.mem_we_i(we_mem_for),
		.mem_ce_i(ce_mem_for),
		.l_wd(wd_for_memwb),
		.l_wreg(wreg_for_memwb),
		.l_wdata(data_for_memwb),
		.st(stall_for_memwb),
		.l_addr(l_addr_for_br),
		.le(le_for_br),
		.l_data(l_data_for_br),
		.w_addr(w_addr_for_br),
		.w_data(w_data_for_br),
		.we(we_for_br)
	);
	bf_ram bf_ram0(
		.ce(ce),
		.if_addr(pc_if_br),
		.if_data(data_br_if),
		.l_addr(l_addr_for_br),
		.le(le_for_br),
		.l_data(l_data_for_br),
		.w_addr(w_addr_for_br),
		.w_data(w_data_for_br),
		.we(we_for_br),
		.mem_din(mem_din),
		.mem_dout(mem_dout),
		.mem_addr(mem_a),
		.mem_wr(mem_wr)
	);
	mem_wb mem_wb0(
		.clk(clk_in),
		.rst(rst_in),
		.mem_wd(wd_mem_memwb),
		.mem_wreg(wreg_mem_memwb),
		.mem_wdata(data_mem_memwb),
		.l_wd(wd_for_memwb),
		.l_wreg(wreg_for_memwb),
		.l_wdata(data_for_memwb),
		.st(stall_for_memwb),
		.wb_wd(wd_memwb_reg),
		.wb_wreg(wreg_memwb_reg),
		.wb_wdata(data_memwb_reg),
		.stallres(stall_memwb_ctrl)
	);
	regfile regfile0(
		.clk(clk_in),
		.rst(rst_in),
		.we(wreg_memwb_reg),
		.waddr(wd_memwb_reg),
		.wdata(data_memwb_reg),
		.re1(reg1_re_id_reg),
		.raddr1(reg1_addr_id_reg),
		.rdata1(reg1_reg_id),
		.re2(reg2_re_id_reg),
		.raddr2(reg2_addr_id_reg),
		.rdata2(reg2_reg_id)
	);
	ctrl ctrl0(
		.rst(rst_in),
		.stallreq_stop(stall_id_ctrl),
		.stallreq_start1(stall_ex_ctrl),
		.stallreq_start2(stall_memwb_ctrl),
		.stall(stall_i)
	);
	
always @(posedge clk_in)
  begin
    if (rst_in)
      begin
      
      end
    else if (!rdy_in)
      begin
      
      end
    else
      begin
      
      end
  end

endmodule