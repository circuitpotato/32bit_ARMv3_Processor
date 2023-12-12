
//----------------------------------------------------------------
// Instruction Memory
//----------------------------------------------------------------
initial begin
			INSTR_MEM[0] = 32'hE59F1218; 
			INSTR_MEM[1] = 32'hE59F2208; 
			INSTR_MEM[2] = 32'hE59F31FC; 
			INSTR_MEM[3] = 32'hE59F41F4; 
			INSTR_MEM[4] = 32'hE5841000; 
			INSTR_MEM[5] = 32'hE0511003; 
			INSTR_MEM[6] = 32'h1AFFFFFC; 
			INSTR_MEM[7] = 32'hE59FA1FC; 
			INSTR_MEM[8] = 32'hEA000001; 
			INSTR_MEM[9] = 32'hE584A000; 
			INSTR_MEM[10] = 32'hE05AA003; 
			INSTR_MEM[11] = 32'h4AFFFFF3; 
			INSTR_MEM[12] = 32'h5AFFFFFB; 
			INSTR_MEM[13] = 32'hEAFFFFFE; 
			for(i = 14; i < 128; i = i+1) begin 
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

