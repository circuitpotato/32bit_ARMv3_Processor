-- This module should contain the corresponding Memory data generated from Hex2ROM
-- and choose the memory data to be displayed based on enable signal  
-- Fill in the blank to complete this module 
-- (c) Gu Jing and Rajesh Panicker, ECE, NUS

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Get_MEM is
-- fundamental clock 100MHz
-- enable signal to read the next content
-- 32 bits memory contents for 7-segments display
-- 1-bit signal rerequied for LEDs, indicating which half of the Memory data is displaying on LEDs
    Port ( clk : in std_logic;
           enable : in std_logic;
           data : out std_logic_vector(31 downto 0);
	       upper_lower : out std_logic
	);
end Get_MEM;

architecture Behavioral of Get_MEM is
	-- declare address for INSTR_MEM and DATA_CONST_MEM
    signal addr : std_logic_vector(8 downto 0) := (others => '0');
	
	-- declare INSTR_MEM and DATA_CONST_MEM
    type MEM_128x32 is array (0 to 127) of std_logic_vector (31 downto 0); 
    
----------------------------------------------------------------
-- Instruction Memory
----------------------------------------------------------------
constant INSTR_MEM : MEM_128x32 := (		x"E59F11F8", 
											x"E59F21F8", 
											x"E59F3214", 
											x"E5924000", 
											x"E5814000", 
											x"E2533001", 
											x"1AFFFFFD", 
											x"E1A0100F", 
											x"E59F0204", 
											x"E58F57D4", 
											x"E59F57D0", 
											x"E59F21F4", 
											x"E5820000", 
											x"E5820004", 
											x"EAFFFFFE", 
											others => x"00000000");

----------------------------------------------------------------
-- Data (Constant) Memory
----------------------------------------------------------------
constant DATA_CONST_MEM : MEM_128x32 := (	x"00000C00", 
											x"00000C04", 
											x"00000C08", 
											x"00000C0C", 
											x"00000C10", 
											x"00000C14", 
											x"00000C18", 
											x"00000000", 
											x"000000FF", 
											x"00000002", 
											x"00000800", 
											x"ABCD1234", 
											x"65570A0D", 
											x"6D6F636C", 
											x"6F742065", 
											x"33474320", 
											x"2E373032", 
											x"000A0D2E", 
											x"00000230", 
											others => x"00000000");

	
begin

-- determine upper_lower by corresponding input
    upper_lower <= addr(0);

-- determine corresponding memory data that should be displayed on 7-segments
    data(31 downto 0) <= instr_mem(to_integer(unsigned(addr(7 downto 1)))) when addr(8) = '0' else data_const_mem(to_integer(unsigned(addr(7 downto 1))));
        

-- determine memory index "addr" accordingly
process(clk) 	-- Note : Do NOT replace clk with enable. If you do so, enable is no longer an enable but a clock, and then you are using a clock divider (entire circuit doesnt run on the same clock). 
		-- Please see towards the end of Lab 1 manual for more info/hints on how to use enable
begin
    if rising_edge(clk) then
        if enable = '1' then
            addr <= std_logic_vector(unsigned(addr) + 1);
        end if;
    end if;
end process;

end Behavioral;
