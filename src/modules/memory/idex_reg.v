// idex_reg.v
// This module is the ID/EX pipeline register.


module idex_reg #(
  parameter DATA_WIDTH = 32
)(
  // TODO: Add flush or stall signal if it is needed

  //////////////////////////////////////
  // Inputs
  //////////////////////////////////////
  input clk,

  input [DATA_WIDTH-1:0] id_PC,
  input [DATA_WIDTH-1:0] id_pc_plus_4,

  // ex control
  input [1:0] id_jump,
  input id_branch,
  input [1:0] id_aluop,
  input id_alusrc,

  // mem control
  input id_memread,
  input id_memwrite,

  // wb control
  input id_memtoreg,
  input id_regwrite,

  input [DATA_WIDTH-1:0] id_sextimm,
  input [6:0] id_funct7,
  input [2:0] id_funct3,
  input [DATA_WIDTH-1:0] id_readdata1,
  input [DATA_WIDTH-1:0] id_readdata2,
  input [4:0] id_rs1,
  input [4:0] id_rs2,
  input [4:0] id_rd,
  input stall,
  input [DATA_WIDTH-1:0] NEXT_PC_,
  input flush,

  //////////////////////////////////////
  // Outputs
  //////////////////////////////////////
  output [DATA_WIDTH-1:0] ex_PC,
  output [DATA_WIDTH-1:0] ex_pc_plus_4,

  // ex control
  output ex_branch,
  output [1:0] ex_aluop,
  output ex_alusrc,
  output [1:0] ex_jump,

  // mem control
  output ex_memread,
  output ex_memwrite,

  // wb control
  output ex_memtoreg,
  output ex_regwrite,

  output [DATA_WIDTH-1:0] ex_sextimm,
  output [6:0] ex_funct7,
  output [2:0] ex_funct3,
  output [DATA_WIDTH-1:0] ex_readdata1,
  output [DATA_WIDTH-1:0] ex_readdata2,
  output [4:0] ex_rs1,
  output [4:0] ex_rs2,
  output [4:0] ex_rd,
  output ex_stall,
  output ex_flush,
  output [DATA_WIDTH-1:0] ex_NEXT_PC_
);

// TODO: Implement ID/EX pipeline register module

reg ex_PC;
reg ex_pc_plus_4;
reg ex_jump;
reg ex_branch;
reg ex_aluop;
reg ex_alusrc;
reg ex_memread;
reg ex_memwrite;
reg ex_memtoreg;
reg ex_regwrite;
reg ex_sextimm;
reg ex_funct7;
reg ex_funct3;
reg ex_readdata1;
reg ex_readdata2;
reg ex_rs1;
reg ex_rs2;
reg ex_rd;
reg ex_stall;
reg ex_NEXT_PC_;
reg ex_flush;

always @(posedge clk) begin
  if (ex_flush) begin
    ex_memwrite<=0;
    ex_regwrite<=0;
    ex_flush <= flush;
  end else begin
    ex_PC<=id_PC;
    ex_pc_plus_4<=id_pc_plus_4;
    ex_jump<=id_jump;
    ex_branch<=id_branch;
    ex_aluop<=id_aluop;
    ex_alusrc<=id_alusrc;
    ex_memread<=id_memread;
    ex_memwrite<=id_memwrite;
    ex_memtoreg<=id_memtoreg;
    ex_regwrite<=id_regwrite;
    ex_sextimm<=id_sextimm;
    ex_funct7<=id_funct7;
    ex_funct3<=id_funct3;
    ex_readdata1<=id_readdata1;
    ex_readdata2<=id_readdata2;
    ex_rs1<=id_rs1;
    ex_rs2<=id_rs2;
    ex_rd<=id_rd;
    ex_stall<=stall;
    ex_NEXT_PC_<=NEXT_PC_;
    ex_flush <= flush;
  end
  if (stall||flush||ex_flush) begin
    ex_memwrite<=0;
    ex_regwrite<=0;
    ex_branch<=0;
    ex_jump<=2'b00;
    ex_readdata1=0;
    ex_readdata2=0;
  end
end


endmodule
