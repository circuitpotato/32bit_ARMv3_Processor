--This module is to generate an enable signal for different display frequency based on pushbuttons
-- Fill in the blank to complete this module 
-- (c) Gu Jing and Rajesh Panicker, ECE, NUS

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Clock_Enable is
-- fundamental clock 100 MHz
-- button BTNU for 4Hz speed
-- button BTNC for pause
-- output signal used to enable the reading of next memory data
    Port( clk : in std_logic;
          btnU : in std_logic;
          btnC : in std_logic;
          enable : out std_logic);
end Clock_Enable;

architecture Behavioral of Clock_Enable is
    -- threshold = (Freq_CLK / (2*Freq_desired )) - 1
    constant threshold1: std_logic_vector(25 downto 0):= std_logic_vector(to_unsigned(500000,26));   -- 1 Hz, 50k is just a threshold for simulation
    constant threshold2: std_logic_vector(25 downto  0):=std_logic_vector(to_unsigned(12499999,26));   -- 4 Hz 
    
    signal threshold: std_logic_vector(25 downto 0):= threshold1;
    signal counter: std_logic_vector(25 downto 0):= (others  => '0');

begin
    
    enable <= '1' when counter = threshold else '0';
    
    process (clk) begin
        if rising_edge(clk) then
            if counter = threshold then
                counter <= (others => '0');
            else
                if btnC = '0' then
                    counter <= std_logic_vector(unsigned(counter) + 1);
                    if btnU = '0' then
                        threshold <= threshold1;
                    else
                        threshold <= threshold2;
                    end if;
                end if;            
            end if;
        end if;
    end process;

end Behavioral;
