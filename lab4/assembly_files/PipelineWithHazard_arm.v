
//----------------------------------------------------------------
// Instruction Memory
//----------------------------------------------------------------
initial begin
			INSTR_MEM[0] = 32'hE59FA21C; 
			INSTR_MEM[1] = 32'hE59FB21C; 
			INSTR_MEM[2] = 32'hE59F7204; 
			INSTR_MEM[3] = 32'hE59F81F8; 
			INSTR_MEM[4] = 32'hE59F91F8; 
			INSTR_MEM[5] = 32'hE59F41EC; 
			INSTR_MEM[6] = 32'hE59F51E0; 
			INSTR_MEM[7] = 32'hE5847000; 
			INSTR_MEM[8] = 32'hE5952000; 
			INSTR_MEM[9] = 32'hE1520007; 
			INSTR_MEM[10] = 32'h1AFFFFFB; 
			INSTR_MEM[11] = 32'hE00A100B; 
			INSTR_MEM[12] = 32'hE5841000; 
			INSTR_MEM[13] = 32'hE02A100B; 
			INSTR_MEM[14] = 32'hE5841000; 
			INSTR_MEM[15] = 32'hE04A1009; 
			INSTR_MEM[16] = 32'hE5841000; 
			INSTR_MEM[17] = 32'hE06A100B; 
			INSTR_MEM[18] = 32'hE5841000; 
			INSTR_MEM[19] = 32'hE08A100B; 
			INSTR_MEM[20] = 32'hE5841000; 
			INSTR_MEM[21] = 32'hE59F21D4; 
			INSTR_MEM[22] = 32'hE0921008; 
			INSTR_MEM[23] = 32'hE0AA100B; 
			INSTR_MEM[24] = 32'hE5841000; 
			INSTR_MEM[25] = 32'hE0921007; 
			INSTR_MEM[26] = 32'hE0CA100B; 
			INSTR_MEM[27] = 32'hE5841000; 
			INSTR_MEM[28] = 32'hE0921007; 
			INSTR_MEM[29] = 32'hE0EA100B; 
			INSTR_MEM[30] = 32'hE5841000; 
			INSTR_MEM[31] = 32'hE1120007; 
			INSTR_MEM[32] = 32'h0AFFFFFF; 
			INSTR_MEM[33] = 32'hE5844000; 
			INSTR_MEM[34] = 32'hE1320002; 
			INSTR_MEM[35] = 32'h0AFFFFFF; 
			INSTR_MEM[36] = 32'hE5845000; 
			INSTR_MEM[37] = 32'hE1520002; 
			INSTR_MEM[38] = 32'h0AFFFFFF; 
			INSTR_MEM[39] = 32'hE5844000; 
			INSTR_MEM[40] = 32'hE1720007; 
			INSTR_MEM[41] = 32'h3AFFFFFF; 
			INSTR_MEM[42] = 32'hE5845000; 
			INSTR_MEM[43] = 32'hE18A100B; 
			INSTR_MEM[44] = 32'hE5841000; 
			INSTR_MEM[45] = 32'hE1A01008; 
			INSTR_MEM[46] = 32'hE5841000; 
			INSTR_MEM[47] = 32'hE1C21008; 
			INSTR_MEM[48] = 32'hE5841000; 
			INSTR_MEM[49] = 32'hE1E0100A; 
			INSTR_MEM[50] = 32'hE5841000; 
			INSTR_MEM[51] = 32'hEAFFFFD2; 
			INSTR_MEM[52] = 32'hEAFFFFFE; 
			for(i = 53; i < 128; i = i+1) begin 
				INSTR_MEM[i] = 32'h0; 
			end
end

//----------------------------------------------------------------
// Data (Constant) Memory
//----------------------------------------------------------------
initial begin
			DATA_CONST_MEM[0] = 32'h00000C04; 
			DATA_CONST_MEM[1] = 32'h00000C00; 
			DATA_CONST_MEM[2] = 32'h00000C18; 
			DATA_CONST_MEM[3] = 32'h00000001; 
			DATA_CONST_MEM[4] = 32'h00000003; 
			DATA_CONST_MEM[5] = 32'h00000000; 
			DATA_CONST_MEM[6] = 32'h00000005; 
			DATA_CONST_MEM[7] = 32'h00000007; 
			DATA_CONST_MEM[8] = 32'h00000009; 
			DATA_CONST_MEM[9] = 32'h0000000A; 
			DATA_CONST_MEM[10] = 32'h00000008; 
			DATA_CONST_MEM[11] = 32'h0123ABCD; 
			DATA_CONST_MEM[12] = 32'hFFFFFFFF; 
			for(i = 13; i < 128; i = i+1) begin 
				DATA_CONST_MEM[i] = 32'h0; 
			end
end

