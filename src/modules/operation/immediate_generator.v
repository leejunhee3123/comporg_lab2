// immediate_generator.v

module immediate_generator #(
  parameter DATA_WIDTH = 32
)(
  input [31:0] instruction,

  output reg [DATA_WIDTH-1:0] sextimm
);

wire [6:0] opcode;
wire [2:0] funct3;
assign opcode = instruction[6:0];
assign funct3 = instruction[14:12];

always @(*) begin
  case (opcode)
    //////////////////////////////////////////////////////////////////////////
    // TODO : Generate sextimm using instruction
    7'b0010011 : sextimm = $signed(instruction[31:20]);
    7'b0000011 : sextimm = $signed(instruction[31:20]);
    7'b0100011 : sextimm = $signed({instruction[31:25],instruction[11:7]});
    7'b1100011 : begin
      if (funct3 == 3'b110 ) begin
        sextimm={19'h00000,instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
      end else if (funct3 == 3'b111) begin
        sextimm={19'h00000,instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
      end else begin
        sextimm=$signed({instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0});
      end
    end
    7'b1101111 : sextimm=$signed({instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0});
    7'b1100111 : sextimm=$signed({instruction[31:20]});

    //////////////////////////////////////////////////////////////////////////
    default:    sextimm = 32'h0000_0000;
  endcase
end


endmodule