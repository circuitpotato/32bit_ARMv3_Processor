----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.11.2023 20:14:35
-- Design Name: 
-- Module Name: Saturating_Counter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Saturating_Counter is
    generic( ADDR_WIDTH : integer := 6; -- 64 bits 
             ADDR : integer := 9);
    Port ( CLK : in std_logic;
           enable: in std_logic;
           taken: in std_logic;
           PCSrc: out std_logic);
end Saturating_Counter;

architecture Behavioral of Saturating_Counter is
    type state_t is (state_twice_taken, state_once_taken, state_once_not_taken, state_twice_not_taken);
    signal state, n_state : state_t;
    
begin
    state_process: process (state, taken) is
    begin
        case state is 
            when state_twice_taken => 
                if taken = '1' then 
                    n_state <= state_twice_taken;
                else 
                    n_state <= state_once_taken;
                end if;
                
            when state_once_taken => 
                if taken = '1' then
                    n_state <= state_twice_taken;
                else
                    n_state <= state_twice_not_taken;
                end if;
                
            when state_once_not_taken =>
                if taken = '1' then
                    n_state <= state_twice_taken; 
                else 
                    n_state <= state_twice_not_taken;
                end if;     
                
            when state_twice_not_taken => 
                if taken = '1' then
                    n_state <= state_once_not_taken;
                else
                    n_state <= state_twice_not_taken;
                end if; 
        end case;
    end process; 
    
    PCSrc <= '1' when (state = state_twice_taken or state = state_once_taken) else '0';
    
    process (CLK) 
    begin
        if rising_edge(CLK) then
            if enable = '1' then 
                state <= n_state;
            else
                state <= state;
            end if;
        end if;
    end process;


end Behavioral;
