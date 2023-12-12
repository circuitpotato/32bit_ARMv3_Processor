----------------------------------------------------------------------------------
-- Company: NUS	
-- Engineer: (c) Rajesh Panicker
-- 
-- Create Date: 09/23/2015 06:49:10 PM
-- Module Name: ALU
-- Project Name: CG3207 Project
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool Versions: Vivado 2015.2
-- Description: ALU Module
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

entity ALU is port(
			Src_A		: in 	std_logic_vector(31 downto 0);
			Src_B		: in 	std_logic_vector(31 downto 0);
			ALUControl	: in	std_logic_vector(3 downto 0);      --Changed to 4 bits
			C_Flag      : in    std_logic;                         --Added as input to ALU  
			ALUResult	: out 	std_logic_vector(31 downto 0);
			ALUFlags	: out 	std_logic_vector(3 downto 0)
			);
end ALU;


architecture ALU_arch of ALU is
	signal S_wider 		: std_logic_vector(32 downto 0);
	signal Src_A_comp	: std_logic_vector(32 downto 0);
	signal Src_B_comp	: std_logic_vector(32 downto 0);
	signal ALUResult_i	: std_logic_vector(31 downto 0);
	signal C_0			: std_logic_vector(32 downto 0);
	signal N, Z, C, V  	: std_logic;
begin
	S_wider <= std_logic_vector( unsigned(Src_A_comp) + unsigned(Src_B_comp) + unsigned(C_0) );
	process(Src_A, Src_B, ALUControl, S_wider, C_Flag)
	begin
	    C_0 <= (others => '0'); -- default value, will help avoid latches
	    Src_A_comp <= '0' & Src_A; 
        Src_B_comp <= '0' & Src_B; 
        ALUResult_i <= Src_B; 
        V <= '0';
		case ALUControl is
			-- 0000 -> AND and TST
			when "0000" => 						
				ALUResult_i <= Src_A and Src_B;
			-- 0001 -> EOR and TEQ
			when "0001" => 						
				ALUResult_i <= Src_A xor Src_B;
			-- 0010 -> SUB and CMP
			when "0010" =>
			    C_0(0) <= '1';
				Src_B_comp <= '0' & not Src_B;
				ALUResult_i <= S_wider(31 downto 0);
				V <= ( Src_A(31) xor  Src_B(31) )  and ( Src_B(31) xnor S_wider(31) );
			-- 0011 -> RSB
			when "0011" =>
			    C_0(0) <= '1' ;     
                Src_A_comp <= '0' & (not Src_A);
                ALUResult_i <= S_wider(31 downto 0) ;
			-- 0100 -> ADD and CMN
			when "0100" => 
                ALUResult_i <= S_wider(31 downto 0);
                V <= ( Src_A(31) xnor  Src_B(31) )  and ( Src_B(31) xor S_wider(31) );
			-- 0101 -> ADC 
			when "0101" =>
			    C_0(0) <= '1' ;
			    ALUResult_i <= S_wider(31 downto 0);
			    V <= ( Src_A(31) xnor  Src_B(31) )  and ( Src_B(31) xor S_wider(31) );
			-- 0110 -> SBC
			when "0110" =>
			    if (C_Flag = '0' ) then
			        C_0 <= (others => '0');
			    else
			        C_0 <= (others => '1');
			    end if;
			    Src_B_comp <= '0' & not Src_B;
			    ALUResult_i <= S_wider(31 downto 0);
			    V <= ( Src_A(31) xnor  Src_B(31) )  and ( Src_B(31) xor S_wider(31) );
			-- 0111 -> RSC
			when "0111" =>
			    if (C_Flag = '0') then
			        C_0 <= (others => '0');
			    else
			        C_0 <= (others => '1');
			    end if;
			    Src_A_comp <= '0' & (not Src_A);
			    ALUResult_i <= S_wider(31 downto 0);
			    V <= ( Src_A(31) xnor  Src_B(31) )  and ( Src_B(31) xor S_wider(31) );
			-- 1100 -> ORR
			when "1100" =>
			    ALUResult_i <= Src_A or Src_B;
			-- 1101 -> MOV
			when "1101" =>
			    ALUResult_i <= Src_B;
			-- 1110 -> BIC
			when "1110" =>
			    ALUResult_i <= Src_A and not Src_B;
			-- 1111 -> MVN
		    when "1111" =>
		        ALUResult_i <= not Src_B;
		    when others => 
		        ALUResult_i <= (others => '-');
		end case;
	end process;
	N <= ALUResult_i(31);
	Z <= '1' when ALUResult_i = x"00000000" else '0';
	C <= S_wider(32);
	ALUResult <= ALUResult_i;
	ALUFlags <= N & Z & C & V;
end ALU_arch;			
