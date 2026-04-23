`timescale 1ns/1ps

module cpu(input clk, input reset);

    reg [15:0] PC;
    reg [15:0] IM[0:255];

    reg [15:0] R[0:3];
    reg [15:0] STACK[0:255];
    reg [7:0] SP;

    reg [15:0] instr;
    reg [3:0] op;
    reg [1:0] rs, rt, rd;
    reg [5:0] imm;

    integer i;

    initial begin
        for (i=0; i<256; i=i+1) begin
            IM[i]=0;
            STACK[i]=0;
        end
        for (i=0; i<4; i=i+1)
            R[i]=0;
        SP = 255;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 0;
            SP <= 255;
            for (i=0; i<4; i=i+1)
                R[i] <= 0;
        end
        else begin
            instr = IM[PC];

            op  = instr[15:12];
            rs  = instr[11:10];
            rt  = instr[9:8];
            rd  = instr[7:6];
            imm = instr[5:0];

            case(op)

                4'b0000: begin
                    R[rd] <= R[rs] + R[rt];
                    STACK[SP] <= R[rs] + R[rt];
                    $display("ADD: R%0d = %0d + %0d = %0d → stack[%0d]",
                        rd, R[rs], R[rt], R[rs]+R[rt], SP);
                    SP <= SP - 1;
                end

                4'b0001: begin
                    R[rd] <= R[rs] - R[rt];
                    STACK[SP] <= R[rs] - R[rt];
                    $display("SUB: R%0d = %0d - %0d = %0d → stack[%0d]",
                        rd, R[rs], R[rt], R[rs]-R[rt], SP);
                    SP <= SP - 1;
                end

                4'b0100: begin
                    R[rd] <= R[rs] + {{10{imm[5]}}, imm};
                    STACK[SP] <= R[rs] + {{10{imm[5]}}, imm};
                    $display("ADDI: R%0d = %0d + %0d = %0d → stack[%0d]",
                        rd, R[rs], {{10{imm[5]}}, imm},
                        R[rs] + {{10{imm[5]}}, imm}, SP);
                    SP <= SP - 1;
                end

                default: ;
            endcase

            PC <= PC + 1;
        end
    end

endmodule
