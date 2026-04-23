#!/bin/bash

cd sim

echo "Compiling..."
iverilog -o sim.out ../src/cpu.v ../tb/tb_cpu.v

echo "Running..."
vvp sim.out

echo "Opening GTKWave..."
gtkwave wave.vcd
