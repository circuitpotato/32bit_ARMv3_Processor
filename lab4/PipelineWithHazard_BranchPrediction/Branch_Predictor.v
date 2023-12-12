`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2023 08:40:50 PM
// Design Name: 
// Module Name: Branch_Predictor
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


module Branch_Predictor
    #(
        parameter ADDR_WIDTH = 6
    )
    (
        input CLK,
        
        input BTA_mispredict,
        input Branch_mispredict,
        
        input [31:0] PCE,
        input [31:0] ALUResultE,
        input PCSrcE,
        
        input [31:0] PCF,
        output reg [31:0] PrALUResultF = 1'b0,
        output reg PrPCSrcF = 1'b0
    );
    
    wire [ADDR_WIDTH-1 : 0] PCE_truncated = PCE[ADDR_WIDTH-1 : 0];
    wire [ADDR_WIDTH-1 : 0] PCF_truncated = PCF[ADDR_WIDTH-1 : 0];
    
    reg  BHT [0 : (2**ADDR_WIDTH)-1];
    wire PHT [0 : (2**ADDR_WIDTH)-1];
    reg enable [0 : (2**ADDR_WIDTH)-1];
    reg taken [0 : (2**ADDR_WIDTH)-1];
    
    reg [31:0] BTB [0 : (2**ADDR_WIDTH)-1];
    genvar i, j;
    integer k, l;
    initial begin
        for(k = 0; k < 2**ADDR_WIDTH; k = k+1) begin // initialise LUT to all zeroes
			BHT[k] = 1'b0; 
			taken[k] = 1'b0;
			enable[k] = 1'b0;
			BTB[k] = 1'b0;
		end
    end
    
   generate
       // every possible branch pattern --> create saturating counter.
       for(i = 0; i < 2**ADDR_WIDTH; i = i+1) begin 

            Saturating_Counter  #(ADDR_WIDTH, i) SaturatingCounter(
                 CLK,
                 enable[i],
                 taken[i],
                 PHT[i]
            );

        end
    endgenerate
    
    always @ (posedge CLK) begin
        for(k = 0; k < 2**ADDR_WIDTH; k = k+1) begin 

            taken[k] <= 1'b0;
            enable[k] <= 1'b0;

        end
                        
        taken[PCE_truncated] <= PCSrcE;
        enable[PCE_truncated] <= Branch_mispredict;
        
        
        // reflect the history
        BHT[PCE_truncated] <= PCSrcE;
        if (BTA_mispredict) begin
            BTB[PCE_truncated] <= ALUResultE;
        end
    end
    
    always @ (*) begin
        PrALUResultF = BTB[PCF_truncated];
        PrPCSrcF = PHT[PCF_truncated];
    end
    
endmodule









