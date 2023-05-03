// hazard.v

// This module determines if pipeline stalls or flushing are required

// TODO: declare propoer input and output ports and implement the
// hazard detection unit

module hazard (

    input mem_taken,
    input [31:0] mem_PC_PLUS_4,
    input [31:0] mem_PC_BRANCH,
    input [1:0] mem_jump,
    input [31:0] mem_jalr_out,
    input [31:0] id_pc,


    output flush
);

reg NEXT_PC;
reg flush;
reg id_memwrite;
reg id_regwrite;
reg ex_memwrite;
reg ex_regwrite;

always @(*) begin
    if ((!mem_taken)&&(mem_jump==2'b00)) begin
        flush=0;
    end else if ((mem_taken)||(mem_jump==2'b10)) begin
        flush=1;
    end else if (mem_jump==2'b11) begin
        flush=1;
    end


end




endmodule
