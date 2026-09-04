`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2026 10:59:15 AM
// Design Name: 
// Module Name: PWM_Servo_Testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PWM_Servo_Testbench(

    );
    
    reg clk = 0;
	reg [4:0] switch;
    wire out;
    PWM_Servo U1(clk, switch, out);
    always #5 clk = ~clk;
    
    initial begin
        switch[0] = 0;
        switch[1] = 0;
        switch[2] = 0;
        switch[3] = 0;
        switch[4] = 0;
        #100;
        switch[0] = 1;
        switch[1] = 0;
        switch[2] = 0;
        switch[3] = 0;
        switch[4] = 0;
        #100;
        switch[0] = 0;
        switch[1] = 1;
        switch[2] = 0;
        switch[3] = 0;
        switch[4] = 0;
        #100;
        switch[0] = 0;
        switch[1] = 0;
        switch[2] = 1;
        switch[3] = 0;
        switch[4] = 0;
        #100;
        switch[0] = 0;
        switch[1] = 0;
        switch[2] = 0;
        switch[3] = 1;
        switch[4] = 0;
        #100;
        switch[0] = 0;
        switch[1] = 0;
        switch[2] = 0;
        switch[3] = 0;
        switch[4] = 1;
    end
    
endmodule
