//exmem_reg.v


module exmem_reg #(
  parameter DATA_WIDTH = 32
)(
  // TODO: Add flush or stall signal if it is needed

  //////////////////////////////////////
  // Inputs
  //////////////////////////////////////
  input clk,

  input [DATA_WIDTH-1:0] ex_pc_plus_4,
  input [DATA_WIDTH-1:0] ex_pc_target,
  input ex_taken,

  // mem control
  input ex_memread,
  input ex_memwrite,

  // wb control
  input [1:0] ex_jump,
  input ex_memtoreg,
  input ex_regwrite,
  
  input [DATA_WIDTH-1:0] ex_alu_result,
  input [DATA_WIDTH-1:0] ex_writedata,
  input [2:0] ex_funct3,
  input [4:0] ex_rd,

  input [DATA_WIDTH-1:0] ex_jalr,
  
  //////////////////////////////////////
  // Outputs
  //////////////////////////////////////
  output [DATA_WIDTH-1:0] mem_pc_plus_4,
  output [DATA_WIDTH-1:0] mem_pc_target,
  output mem_taken,

  // mem control
  output mem_memread,
  output mem_memwrite,

  // wb control
  output [1:0] mem_jump,
  output mem_memtoreg,
  output mem_regwrite,
  
  output [DATA_WIDTH-1:0] mem_alu_result,
  output [DATA_WIDTH-1:0] mem_writedata,
  output [2:0] mem_funct3,
  output [4:0] mem_rd,
  
  output [DATA_WIDTH-1:0] mem_jalr
);

reg mem_pc_plus_4;
reg mem_pc_target;
reg mem_taken;
reg mem_jump;
reg mem_memread;
reg mem_memwrite;
reg mem_memtoreg;
reg mem_regwrite;
reg mem_funct3;
reg mem_alu_result;
reg mem_writedata;
reg mem_rd;
reg mem_jalr;



always @(posedge clk) begin
  mem_pc_plus_4<=ex_pc_plus_4;
  mem_pc_target<=ex_pc_target;
  mem_taken<=ex_taken;
  mem_jump<=ex_jump;
  mem_memread<=ex_memread;
  mem_memwrite<=ex_memwrite;
  mem_memtoreg<=ex_memtoreg;
  mem_regwrite<=ex_regwrite;
  mem_funct3<=ex_funct3;
  mem_alu_result<=ex_alu_result;
  mem_writedata<=ex_writedata;
  mem_rd<=ex_rd;
  mem_jalr<=ex_jalr;
end

// TODO: Implement EX / MEM pipeline register module

endmodule
