`timescale 1ns / 1ps

module lab1_sim_verilog();

    reg clk, btnU, btnC;
    wire dp; 
    wire [15:0] led;	
    wire [7:0] anode;	
    wire [6:0] cathode;
    
    Top uut (.clk(clk), .btnU(btnU), .btnC(btnC), .led(led), .dp(dp), .anode(anode), .cathode(cathode));
    //Clock_Enable uut (.clk(clk), .btnU(btnU), .btnC(btnC), .enable(enable));
    
    initial begin
        clk = 0;
        btnU = 0;
        btnC = 0;
        #1000000; //1ms delay
        //press btnC for pause, hold for 1ms
        btnU = 0;   
        btnC = 1;
        #1000000; //1ms delay
        //Release btnC, wait 1ms
        btnU = 0;   
        btnC = 0;
        #1000000; //1ms delay
        //press btnU for speed up, wait 5ms
        btnU = 1;   
        btnC = 0;
        #5000000; //5ms delay
        //Release and reset all buttons
        btnU = 0;   
        btnC = 0;
    end
    
    always begin
    //100MHz clock
        clk = 1;
        #5;
        clk = 0;
        #5;
    end

endmodule
