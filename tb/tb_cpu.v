`timescale 1ns/1ps

module tb;

    reg clk = 0, reset;
    cpu uut(clk, reset);

    always #5 clk = ~clk;

    integer i;

    initial begin
        // GTKWave dump
        $dumpfile("../sim/wave.vcd");
        $dumpvars(0, tb);

        reset = 1;
        #10 reset = 0;

        // PROGRAM
        uut.IM[0] = 16'b0100_00_00_01_000101; // R1=5
        uut.IM[1] = 16'b0100_00_00_10_001010; // R2=10
        uut.IM[2] = 16'b0000_01_10_11_000000; // R3=15
        uut.IM[3] = 16'b0001_11_01_00_000000; // R0=10

        $display("\n===== EXECUTION WITH STACK TRACE =====\n");

        for (i=0; i<6; i=i+1) begin
            @(negedge clk);
            $display("PC=%0d | R0=%0d R1=%0d R2=%0d R3=%0d | SP=%0d",
                uut.PC,
                uut.R[0],
                uut.R[1],
                uut.R[2],
                uut.R[3],
                uut.SP
            );
            $display("--------------------------------------");
        end

        #20;
        $finish;
    end

endmodule
