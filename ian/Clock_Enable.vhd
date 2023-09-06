--This module is to generate an enable signal for different display frequency based on pushbuttons
-- Fill in the blank to complete this module 
-- (c) Gu Jing and Rajesh Panicker, ECE, NUS

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


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
    -- define reg counter to be able to count to certain threshold value
    -- 26 bit counter 
    signal counter : std_logic_vector(25 downto 0) := (others => '0');
    -- 16 bit counter for simulation
--    signal counter : std_logic_vector(15 downto 0) := (others => '0');
    -- define reg threshold to allow 4hz or 1hz frequency -> 0.745Hz(1Hz) is 2^26 (100..000), -> 2.98Hz(4Hz) is 2^24 (00100...000)
    signal frq_1hz, frq_4hz : std_logic := '0';
begin
process(clk)
    begin
        if (rising_edge(clk)) then
            counter <= std_logic_vector(unsigned(counter)+1);
            --Record count of this cycle
            frq_1hz <= counter(25); --Check 26th bit of counter (0.745Hz)
            frq_4hz <= counter(23); --check 24th bit of counter (2.98Hz)
            --for simulation 
--            frq_1hz <= counter(15); 
--            frq_4hz <= counter(13); 
            -- btnU pressed
            if (btnU = '1') then
                --Checking if 24th bit has changed since last cycle, to toggle enable at 2.98Hz (4Hz)
--                if (frq_4hz /= counter(13)) then        --simulation
                if (frq_4hz /= counter(23)) then
                    enable <= '1';
                else
                    enable <= '0';
                end if;
            -- btnC pressed
            elsif (btnC = '1') then
                enable <= '0';
            -- No btn pressed
            else
                --Checking if 26th bit has changed since last cycle, to toggle enable at 0.745Hz (1Hz)
--                if (frq_1hz /= counter(15)) then      --simulation
                if (frq_1hz /= counter(25)) then
                    enable <= '1';
                else
                    enable <= '0';
                end if;
            end if;
        end if;
end process;
end Behavioral;
