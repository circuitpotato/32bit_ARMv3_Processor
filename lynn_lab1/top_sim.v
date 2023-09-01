`timescale 1ns / 1ps
module top_sim();

    reg clk, btnU, btnC;
    wire [15:0] led;
    wire dp;  			
    wire [7:0] anode;	
    wire [6:0] cathode;
    
    // clk period of 100 MHz is 10ns
    parameter clock_period = 10;
    
    top uut(clk, btnU, btnC, led, dp, anode, cathode);
    
    // simulating without pushbuttons    
    initial begin
        btnU = 0;
        btnC = 0;
    end
    
    //Simulate clk
    initial
    begin
        clk = 1'b1;
        forever #(clock_period/2) clk = ~clk;
    end 

endmodule
