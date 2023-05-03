// simple_cpu.v
// a pipelined RISC-V microarchitecture (RV32I)

///////////////////////////////////////////////////////////////////////////////////////////
//// [*] In simple_cpu.v you should connect the correct wires to the correct ports
////     - All modules are given so there is no need to make new modules
////       (it does not mean you do not need to instantiate new modules)
////     - However, you may have to fix or add in / out ports for some modules
////     - In addition, you are still free to instantiate simple modules like multiplexers,
////       adders, etc.
///////////////////////////////////////////////////////////////////////////////////////////

module simple_cpu
#(parameter DATA_WIDTH = 32)(
  input clk,
  input rstn
);

///////////////////////////////////////////////////////////////////////////////
// TODO:  Declare all wires / registers that are needed
///////////////////////////////////////////////////////////////////////////////
// e.g., wire [DATA_WIDTH-1:0] if_pc_plus_4;
// 1) Pipeline registers (wires to / from pipeline register modules)
// 2) In / Out ports for other modules
// 3) Additional wires for multiplexers or other mdoules you instantiate

wire [DATA_WIDTH-1:0] instruction;
wire [DATA_WIDTH-1:0] id_instruction;
reg [DATA_WIDTH-1:0] PC;
wire [DATA_WIDTH-1:0] id_PC;
wire [DATA_WIDTH-1:0] ex_PC;    // program counter (32 bits)
wire [DATA_WIDTH-1:0] PC_PLUS_4;
wire [DATA_WIDTH-1:0] id_PC_PLUS_4;
wire [DATA_WIDTH-1:0] ex_PC_PLUS_4;
wire [DATA_WIDTH-1:0] mem_PC_PLUS_4;
wire [DATA_WIDTH-1:0] wb_PC_PLUS_4;
wire [DATA_WIDTH-1:0] NEXT_PC;
wire [DATA_WIDTH-1:0] PC_BRANCH;
wire [DATA_WIDTH-1:0] mem_PC_BRANCH;
wire [31:0] branch_out;
wire [31:0] jalr_out;

///////////////////////////////////////////////////////////////////////////////
// Instruction Fetch (IF)
///////////////////////////////////////////////////////////////////////////////



/* m_pc_plus_4_adder */
adder m_pc_plus_4_adder(
  .in_a   (PC),
  .in_b   (32'h0000_0004),

  .result (PC_PLUS_4)
);


always @(posedge clk) begin
  if (rstn == 1'b0) begin
    PC <= 32'h00000000;
  end
  else PC <= NEXT_PC;
end

assign NEXT_PC=PC_PLUS_4;

/* instruction: read current instruction from inst mem */
instruction_memory m_instruction_memory(
  .address    (PC),

  .instruction(instruction)
);

/* forward to IF/ID stage registers */
ifid_reg m_ifid_reg(
  // TODO: Add flush or stall signal if it is needed
  .clk            (clk),
  .if_PC          (PC),
  .if_pc_plus_4   (PC_PLUS_4),
  .if_instruction (instruction),

  .id_PC          (id_PC),
  .id_pc_plus_4   (id_PC_PLUS_4),
  .id_instruction (id_instruction)
);


//////////////////////////////////////////////////////////////////////////////////
// Instruction Decode (ID)
//////////////////////////////////////////////////////////////////////////////////

/* m_hazard: hazard detection unit */
hazard m_hazard(
  // TODO: implement hazard detection unit & do wiring
);
wire [31:0] readdata1, readdata2;
wire [31:0] ex_readdata1, ex_readdata2;
wire [31:0] mem_readdata2;
// 5 bits for each (because there exist 32 registers)
wire [4:0] readreg1, readreg2, writereg;
wire [4:0] ex_readreg1, ex_readreg2, ex_writereg;
wire [4:0] mem_writereg;
wire [4:0] wb_writereg;

wire [6:0] opcode;
wire [6:0] funct7;
wire [6:0] ex_funct7;
wire [2:0] funct3;
wire [2:0] ex_funct3;
wire [2:0] mem_funct3;

wire branch;
wire mem_read;
wire mem_to_reg;
wire [1:0] alu_op;
wire mem_write;
wire alu_src;
wire reg_write;
wire [1:0] jump;

wire ex_branch;
wire [1:0] ex_alu_op;
wire ex_mem_read;
wire ex_mem_to_reg;
wire ex_mem_write;
wire ex_alu_src;
wire ex_reg_write;
wire [1:0] ex_jump;

wire [31:0] sextimm;
wire [31:0] ex_sextimm;

assign opcode = id_instruction[6:0];

assign funct7 = id_instruction[31:25];
assign funct3 = id_instruction[14:12];

/* m_control: control unit */
control m_control(
  .opcode     (opcode),

  .jump       (jump),
  .branch     (branch),
  .alu_op     (alu_op),
  .alu_src    (alu_src),
  .mem_read   (mem_read),
  .mem_to_reg (mem_to_reg),
  .mem_write  (mem_write),
  .reg_write  (reg_write)
);

/* m_imm_generator: immediate generator */
immediate_generator m_immediate_generator(
  .instruction(id_instruction),

  .sextimm    (sextimm)
);

assign readreg1 = id_instruction[19:15];
assign readreg2 = id_instruction[24:20];
assign writereg  = id_instruction[11:7];

wire [DATA_WIDTH-1:0] write_data;
wire wb_reg_write;

/* m_register_file: register file */
register_file m_register_file(
  .clk        (clk),
  .readreg1   (readreg1),
  .readreg2   (readreg2),
  .writereg   (wb_writereg),
  .wen        (wb_reg_write),
  .writedata  (write_data),

  .readdata1  (readdata1),
  .readdata2  (readdata2)
);

/* forward to ID/EX stage registers */
idex_reg m_idex_reg(
  // TODO: Add flush or stall signal if it is needed
  .clk          (clk),
  .id_PC        (id_PC),
  .id_pc_plus_4 (id_PC_PLUS_4),
  .id_jump      (jump),
  .id_branch    (branch),
  .id_aluop     (alu_op),
  .id_alusrc    (alu_src),
  .id_memread   (mem_read),
  .id_memwrite  (mem_write),
  .id_memtoreg  (mem_to_reg),
  .id_regwrite  (reg_write),
  .id_sextimm   (sextimm),
  .id_funct7    (funct7),
  .id_funct3    (funct3),
  .id_readdata1 (readdata1),
  .id_readdata2 (readdata2),
  .id_rs1       (readreg1),
  .id_rs2       (readreg2),
  .id_rd        (writereg),

  .ex_PC        (ex_PC),
  .ex_pc_plus_4 (ex_PC_PLUS_4),
  .ex_jump      (ex_jump),
  .ex_branch    (ex_branch),
  .ex_aluop     (ex_alu_op),
  .ex_alusrc    (ex_alu_src),
  .ex_memread   (ex_mem_read),
  .ex_memwrite  (ex_mem_write),
  .ex_memtoreg  (ex_mem_to_reg),
  .ex_regwrite  (ex_reg_write),
  .ex_sextimm   (ex_sextimm),
  .ex_funct7    (ex_funct7),
  .ex_funct3    (ex_funct3),
  .ex_readdata1 (ex_readdata1),
  .ex_readdata2 (ex_readdata2),
  .ex_rs1       (ex_readreg1),
  .ex_rs2       (ex_readreg2),
  .ex_rd        (ex_writereg)
);

//////////////////////////////////////////////////////////////////////////////////
// Execute (EX) 
//////////////////////////////////////////////////////////////////////////////////

/* m_branch_target_adder: PC + imm for branch address */
adder m_branch_target_adder(
  .in_a   (ex_PC),
  .in_b   (ex_sextimm),

  .result (PC_BRANCH)
);

wire ex_taken;
wire mem_taken;
wire ex_alu_check;
wire [3:0] ex_alu_func;
wire [31:0] ex_alu_in2;

/* m_branch_control : checks T/NT */
branch_control m_branch_control(
  .branch(ex_branch),
  .check(ex_alu_check),

  .taken(ex_taken)
);

/* alu control : generates alu_func signal */
alu_control m_alu_control(
  .alu_op   (ex_alu_op),
  .funct7   (ex_funct7),
  .funct3   (ex_funct3),

  .alu_func (ex_alu_func)
);

mux_2x1 m_mux_2x1(
  .select(ex_alu_src),
  .in1(ex_readdata2),
  .in2(ex_sextimm),
  
  .out(ex_alu_in2)
);

wire [31:0] ex_alu_in1;
wire [31:0] ex_alu_result;
wire [31:0] mem_alu_result;
wire [31:0] wb_alu_result;

assign ex_alu_in1 = ex_readdata1;

/* m_alu */
alu m_alu(
  .alu_func (ex_alu_func),
  .in_a     (ex_alu_in1), 
  .in_b     (ex_alu_in2), 

  .result   (ex_alu_result),
  .check    (ex_alu_check)
);

forwarding m_forwarding(
  // TODO: implement forwarding unit & do wiring
);

wire mem_mem_read;
wire mem_mem_write;
wire mem_mem_to_reg;
wire mem_reg_write;
wire [1:0] mem_alu_op;
wire mem_alu_src;
wire [1:0] mem_jump;

/* forward to EX/MEM stage registers */
exmem_reg m_exmem_reg(
  // TODO: Add flush or stall signal if it is needed
  .clk            (clk),
  .ex_pc_plus_4   (ex_PC_PLUS_4),
  .ex_pc_target   (PC_BRANCH),
  .ex_taken       (ex_taken), 
  .ex_jump        (ex_jump),
  .ex_memread     (ex_mem_read),
  .ex_memwrite    (ex_mem_write),
  .ex_memtoreg    (ex_mem_to_reg),
  .ex_regwrite    (ex_reg_write),
  .ex_alu_result  (ex_alu_result),
  .ex_writedata   (ex_readdata2),
  .ex_funct3      (ex_funct3),
  .ex_rd          (ex_writereg),
  
  .mem_pc_plus_4  (mem_PC_PLUS_4),
  .mem_pc_target  (mem_PC_BRANCH),
  .mem_taken      (mem_taken), 
  .mem_jump       (mem_jump),
  .mem_memread    (mem_mem_read),
  .mem_memwrite   (mem_mem_write),
  .mem_memtoreg   (mem_mem_to_reg),
  .mem_regwrite   (mem_reg_write),
  .mem_alu_result (mem_alu_result),
  .mem_writedata  (mem_readdata2),
  .mem_funct3     (mem_funct3),
  .mem_rd         (mem_writereg)
);


//////////////////////////////////////////////////////////////////////////////////
// Memory (MEM) 
//////////////////////////////////////////////////////////////////////////////////

wire [1:0] maskmode ;
assign maskmode = mem_funct3[1:0];
wire [DATA_WIDTH-1:0] read_data;
wire [DATA_WIDTH-1:0] wb_read_data;

/* m_data_memory : main memory module */
data_memory m_data_memory(
  .clk         (clk),
  .address     (mem_alu_result),
  .write_data  (mem_readdata2),
  .mem_read    (mem_mem_read),
  .mem_write   (mem_mem_write),
  .maskmode    (maskmode),
  .sext        (mem_funct3[2]),

  .read_data   (read_data)
);

wire wb_mem_to_reg;
wire [1:0] wb_jump;

/* forward to MEM/WB stage registers */
memwb_reg m_memwb_reg(
  // TODO: Add flush or stall signal if it is needed
  .clk            (clk),
  .mem_pc_plus_4  (mem_PC_PLUS_4),
  .mem_jump       (mem_jump),
  .mem_memtoreg   (mem_mem_to_reg),
  .mem_regwrite   (mem_reg_write),
  .mem_readdata   (read_data),
  .mem_alu_result (mem_alu_result),
  .mem_rd         (mem_writereg),

  .wb_pc_plus_4   (wb_PC_PLUS_4),
  .wb_jump        (wb_jump),
  .wb_memtoreg    (wb_mem_to_reg),
  .wb_regwrite    (wb_reg_write),
  .wb_readdata    (wb_read_data),
  .wb_alu_result  (wb_alu_result),
  .wb_rd          (wb_writereg)
);

//////////////////////////////////////////////////////////////////////////////////
// Write Back (WB) 
//////////////////////////////////////////////////////////////////////////////////

wire[31:0] write_data_;

mux_2x1 m_mux_2x1_2(
  .select(wb_mem_to_reg),
  .in1(wb_alu_result),
  .in2(wb_read_data),
  
  .out(write_data_)
);

mux_2x1 m_mux_2x1_3(
  .select(wb_jump[1]),
  .in1(write_data_),
  .in2(wb_PC_PLUS_4),
  
  .out(write_data)
);

endmodule
