// ifid_reg.v
// This module is the IF/ID pipeline register.


module ifid_reg #(
  parameter DATA_WIDTH = 32
)(
  // TODO: Add flush or stall signal if it is needed

  //////////////////////////////////////
  // Inputs
  //////////////////////////////////////
  input clk,

  input [DATA_WIDTH-1:0] if_PC,
  input [DATA_WIDTH-1:0] if_pc_plus_4,
  input [DATA_WIDTH-1:0] if_instruction,
  input stall,
  input [DATA_WIDTH-1:0] id_PC_forstall,
  input [DATA_WIDTH-1:0] id_pc_plus_4_forstall,
  input [DATA_WIDTH-1:0] id_instruction_forstall,

  //////////////////////////////////////
  // Outputs
  //////////////////////////////////////
  output [DATA_WIDTH-1:0] id_PC,
  output [DATA_WIDTH-1:0] id_pc_plus_4,
  output [DATA_WIDTH-1:0] id_instruction
);

// TODO: Implement IF/ID pipeline register module

reg id_PC;
reg id_pc_plus_4;
reg id_instruction;

always @(posedge clk) begin
    if (stall==1) begin
      id_PC<=id_PC_forstall;
      id_pc_plus_4<=id_pc_plus_4_forstall;
      id_instruction<=id_instruction_forstall;
    end else begin
      id_PC<=if_PC;
      id_pc_plus_4<=if_pc_plus_4;
      id_instruction<=if_instruction;
    end
end


endmodule
