# Notable Projects
| **Project** | **Environment** | **Languages/Tools** | **Summary** |
| :--- | :--- | :--- | :--- |
| **EFR32 Cyclic Redundancy Checker** | EFR32xG24 Microcontroller | Embedded C, Simplicity Studio | UART protocol reading a character from a serial terminal and compute checksums at two different points in time to verify data integrity. corruptData = true option demonstrates a positive reading for corrupted data. |
| **Adder-Subtractor Circuit and Testbench** | Cyclone IV E DE0-Nano FPGA | VHDL, Quartus Prime, ModelSim | Adder-subtractor circuit in VHDL with an AddSub input for choosing addition or subtraction and a Sel input for allowing accumulation. Testbench designed and waveforms formatted to allow for simulation prior to programming the FPGA. |
| **Servo Controller** | Basys3 FPGA | Verilog, Vivado | Servo rotational positions mapped to different FPGA switches such that a user may flip a switch to rotate the servo to a desired angle. |
| **Double Pendulum Calculator** | Computer | MATLAB, RK4, Image File Writing | Double pendulum specifications placed into a .csv is used as an input. 4th-order Runge-Kutta methods solve for the time evolution of the double pendulum system, and a GIF illustrating the time evolution is generated. |
