// forwarding.v

// This module determines if the values need to be forwarded to the EX stage.

// TODO: declare propoer input and output ports and implement the
// forwarding unit

module forwarding (
    input [4:0] rs1_ex,
    input [4:0] rs2_ex,
    input [4:0] rd_mem,
    input [4:0] rd_wb,
    input mem_reg_write,
    input wb_reg_write,

    output [1:0] forwarding_1,
    output [1:0] forwarding_2
);

reg forwarding_1;
reg forwarding_2;

always@(*) begin
    if((rs1_ex != 5'b00000)&&(rs1_ex == rd_mem)&& (mem_reg_write)) begin
        forwarding_1=2'b10;
    end
    else if ((rs1_ex != 5'b00000)&&(rs1_ex == rd_wb)&& (wb_reg_write)) begin
        forwarding_1=2'b01;
    end
    else begin
        forwarding_1=2'b00;
    end

    if((rs2_ex != 5'b00000)&&(rs2_ex == rd_mem)&& (mem_reg_write)) begin
        forwarding_2=2'b10;
    end
    else if ((rs2_ex != 5'b00000)&&(rs2_ex == rd_wb)&& (wb_reg_write)) begin
        forwarding_2=2'b01;
    end
    else begin
        forwarding_2=2'b00;
    end

end

endmodule
