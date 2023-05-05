// hazard.v

// This module determines if pipeline stalls or flushing are required

// TODO: declare propoer input and output ports and implement the
// hazard detection unit

module hazard (
    input ex_taken,
    input [31:0] ex_PC_PLUS_4,
    input [31:0] ex_PC_BRANCH,
    input [1:0] ex_jump,
    input [31:0] ex_jalr_out,
    input [31:0] pc_plus_4,
    input [4:0] ex_writereg,
    input ex_mem_read,
    input [4:0] id_rs1,
    input [4:0] id_rs2,
    input [31:0] jalr_out,
    input [31:0] pc,
  
    output stall,
    output stall_reg_position,
    output reg [31:0] NEXT_PC,
    output flush
);
reg stall;
reg stall_reg_position;
reg flush;

always @(*) begin
    if ((!ex_taken)&&(ex_jump==2'b00)) begin
        flush=0;
        NEXT_PC=pc_plus_4;
    end else if ((ex_taken)||(ex_jump==2'b10)) begin
        flush=1;
        NEXT_PC=ex_PC_BRANCH;
    end else if (ex_jump==2'b11) begin
        flush=1;
        NEXT_PC=jalr_out;
    end else begin
        flush=0;
        NEXT_PC=pc_plus_4;
    end


    if ((ex_writereg != 5'b00000)&&(ex_mem_read)&&((id_rs1==ex_writereg)||(id_rs2==ex_writereg))) begin
        stall=1;
        NEXT_PC=pc;
        if(id_rs1==ex_writereg) begin
            stall_reg_position=0;
        end else if (id_rs2==ex_writereg) begin
            stall_reg_position=1;
        end
    end else begin
        stall=0;
    end

end




endmodule
