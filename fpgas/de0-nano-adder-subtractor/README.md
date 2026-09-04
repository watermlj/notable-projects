# DE0-Nano Adder Subtractor Circuit
This circuit adds or subtracts two n-bit numbers (defaults to 16 bits).
An AddSub input allows the user to choose whether to add or subtract the numbers.
A Sel input allows the user to choose whether to perform normal operations or accumulate. (i.e. Sel = 0 does Z <= A + B, Sel = 1 does Z <= Z + B)
A VHDL testbench is also specified alongside a compilation file for ModelSim, allowing for verification of behavior prior to the programming of an FPGA or other device.
