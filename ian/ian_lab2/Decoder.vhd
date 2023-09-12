----------------------------------------------------------------------------------
-- Company: NUS	
-- Engineer: (c) Rajesh Panicker
-- 
-- Create Date: 09/23/2015 06:49:10 PM
-- Module Name: Decoder
-- Project Name: CG3207 Project
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool Versions: Vivado 2015.2
-- Description: Decoder Module
-- 
-- Dependencies: NIL
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--	License terms :
--	You are free to use this code as long as you
--		(i) DO NOT post it on any public repository;
--		(ii) use it only for educational purposes;
--		(iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of ARM Holdings or other entities.
--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
--		(v)	acknowledge that the program was written based on the microarchitecture described in the book Digital Design and Computer Architecture, ARM Edition by Harris and Harris;
--		(vi) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course CG3207 at the National University of Singapore);
--		(vii) retain this notice in this file or any files derived from this.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Decoder is port(
			Rd			: in 	std_logic_vector(3 downto 0);
			Op			: in 	std_logic_vector(1 downto 0);
			Funct		: in 	std_logic_vector(5 downto 0);
			PCS			: out	std_logic;
			RegW		: out	std_logic;
			MemW		: out	std_logic;
			MemtoReg	: out	std_logic;
			ALUSrc		: out	std_logic;
			ImmSrc		: out	std_logic_vector(1 downto 0);
			RegSrc		: out	std_logic_vector(1 downto 0);
			NoWrite		: out	std_logic;
			ALUControl	: out	std_logic_vector(1 downto 0);
			FlagW		: out	std_logic_vector(1 downto 0)
			);
end Decoder;

architecture Decoder_arch of Decoder is
	signal ALUOp 			: std_logic;
	signal Branch 			: std_logic;
	
	
	--<extra signals, if any>
begin

--<decoding logic here>
	-- Main Decoder
    Branch <= '1' when (Op = "10") else '0';
    
    MemtoReg <= '1' when (Op = "01" and Funct(0)= '1') else 
                '-' when (Op = "01" and Funct(0) = '0') else '0'; 
    
    MemW <= '1' when (Op = "01" and Funct(0) = '0') else '0';
    
    ALUsrc <= '0' when (Op = "00" and Funct(5) = '0') else '1';
    
    ImmSrc <= "00" when (Op = "00" and Funct(5) = '1') else
               "01" when (Op = "01") else
               "--" when (Op = "00" and Funct(5) = '0') else "10";
    
    RegW <= '0' when ((Op = "01" and Funct(0) = '0') or (Op = "10")) else '1';
    
    RegSrc(0) <= '1' when (Op = "10") else '0';
    RegSrc(1) <= '0' when (Op = "00" and Funct(5) = '0') else
                 '1' when (Op = "01" and Funct(0) = '0') else '-';  
        
    ALUOp <= '1' when (Op = "00") else '0';
    
	-- PC Logic
	PCS <= '1' when ((Rd = "1111" and RegW = '1') or (Branch = '1')) else '0';

	-- Alu Decoder
	ALUControl <= "00" when (ALUOp = '0') else
					"00" when ((ALUOp = '1') and Funct(4 downto 1) = "0100") else
					"01" when ((ALUOp = '1') and Funct(4 downto 1) = "0010") else
					"10" when ((ALUOp = '1') and Funct(4 downto 1) = "0000") else
					"11"
	
	FlagW <= "00" when (ALUOp = '0') else
				"11" when ((ALUOp = '1') and (Funct(4 downto 1) = ("0100" or "0010")) and (Funct(0) = '1')) else
				"10" when ((ALUOp = '1') and (Funct(4 downto 1) = ("0000" or "1100")) and (Funct(0) = '1')) else
				"00"

end Decoder_arch;