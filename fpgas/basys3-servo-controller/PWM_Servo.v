`timescale 1ns / 1ps

module PWM_Servo(
    input clk,
    input [4:0] switch,
    output out
    );
    
    reg [20:0] counter = 0;
    reg pwm_temp;
    
    always @(posedge clk) begin
    
        if (counter < 2000000) counter <= counter + 1;
        else counter <= 0; // reset counter to zero
        
    end
    
    always @(switch[4] or switch[3] or switch[2] or switch[1] or switch[0]) begin
    
//        if (~(switch[4] ^ switch[3] ^ switch[2] ^ switch[1] ^ switch[0])) begin
//            pwm_temp = 0;
//        end
        if (switch[0]) begin
            pwm_temp = (counter < 60000) ? 1:0;
        end
        if (switch[1]) begin
            pwm_temp = (counter < 105000) ? 1:0;
        end
        if (switch[2]) begin
            pwm_temp = (counter < 150000) ? 1:0;
        end
        if (switch[3]) begin
            pwm_temp = (counter < 195000) ? 1:0;
        end
        if (switch[4]) begin
            pwm_temp = (counter < 240000) ? 1:0;
        end

    end

    assign out = pwm_temp;

endmodule
