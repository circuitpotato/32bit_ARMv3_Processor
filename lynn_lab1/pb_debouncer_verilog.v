`timescale 1ns / 1ps
module pb_debouncer_verilog(
    input i_pb,
    input i_clk,
    output o_single_pulse
    );
    
    wire clk_3hz;
    wire dff1_out;
    wire dff2_out;
    wire dff2_inv_out;
    
    //count= (Freq_CLK / (2*Freq_desired )) - 1 
    clock_divide_verilog #(.i_number(16666665)) clk3Hz(.i_clock(i_clk), .o_my_clock(clk_3hz));
    
    dff_verilog dff1(.i_d(i_pb), .i_clk(clk_3hz), .o_q(dff1_out));
    dff_verilog dff2(.i_d(dff1_out), .i_clk(clk_3hz), .o_q(dff2_out));
    
    assign dff2_inv_out = ! dff2_out;
    assign o_single_pulse = dff2_inv_out & dff1_out;
    
endmodule
