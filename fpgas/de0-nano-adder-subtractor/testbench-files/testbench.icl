# Quit previously running testbench simulations
quit -sim
# Declare default "work" library
vlib work;

# Compile all VHDL files one directory up
vcom ../*.vhd

# Compile VHDL testbench file(s) in this directory
vcom *.vht

# Start simulating the testbench
vsim work.testbench -Lf 220model -Lf altera_mf

# Draw waveforms as specified in wave.do
do wave.do

# Run the testbench for 500 nanoseconds of simulation time
run 500 ns

