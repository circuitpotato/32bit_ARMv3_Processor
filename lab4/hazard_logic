----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.11.2023 14:20:17
-- Design Name: 
-- Module Name: hazard_unit - Behavioral
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

entity hazard_logic is
    Port ( RA1E : in std_logic_vector(3 downto 0);
           RA2E : in std_logic_vector(3 downto 0);
           RA1D : in std_logic_vector(3 downto 0);
           RA2D : in std_logic_vector(3 downto 0);
           WA3E : in std_logic_vector(3 downto 0);
           MemtoRegE : in std_logic;
           RegWriteE : in std_logic;
           RegWriteM : in std_logic;
           RegWriteW : in std_logic;
           WA3M : in std_logic_vector(3 downto 0);
           WA3W : in std_logic_vector(3 downto 0);
           RA2M : in std_logic_vector(3 downto 0);
           MemWriteM : in std_logic;
           MemtoRegW : in std_logic;
           PCSrcE : in std_logic;
           MemtoRegD : in std_logic;
           
           FlushD : out std_logic;
           StallF : out std_logic;
           StallD : out std_logic;
           FlushE : out std_logic;
           ForwardAE : out std_logic_vector(1 downto 0);
           ForwardBE : out std_logic_vector(1 downto 0);
           ForwardM : out std_logic
    );
end hazard_logic;

architecture Behavioral of hazard_logic is
    signal Match_1E_M: std_logic;    
    signal Match_2E_M: std_logic;
    signal Match_1E_W: std_logic;
    signal Match_2E_W: std_logic;
    signal Match_12_D_E: std_logic;
    signal ldrstall: std_logic;
    signal PCWrPendingF: std_logic;

begin
    
    Match_1E_M <= '1' when (RA1E = WA3M) else '0';
    Match_2E_M <= '1' when (RA2E = WA3M) else '0';
    Match_1E_W <= '1' when (RA1E = WA3W) else '0';
    Match_2E_W <= '1' when (RA2E = WA3W) else '0';
    
    PCWrPendingF <= PCSrcE;
    
    
    -- data forwarding
    ForwardAE <= "10" when (Match_1E_M = '1' and RegWriteM = '1') else 
                 "01" when (Match_1E_W = '1' and RegWriteW = '1') else 
                 "00";
    
    ForwardBE <= "10" when (Match_2E_M = '1' and RegWriteM = '1') else
                 "01" when (Match_2E_W = '1' and RegWriteW = '1') else 
                 "00";
    
                 
    -- Load Store forwarding    
    ForwardM <= '1' when ((RA2M = WA3W) and MemWriteM = '1' and MemtoRegW = '1' and RegWriteW = '1') else '0';
    
    -- Load and Use hazard condition
    Match_12_D_E <= '1' when ((RA1D = WA3E) or ((RA2D = WA3E) and (not MemtoRegD = '1'))) else '0';
    ldrstall <= Match_12_D_E and MemtoRegE and RegWriteE;
    
    StallF <= ldrstall;
    StallD <= ldrstall;
    FlushE <= ldrstall or PCSrcE;  
    FlushD <= PCSrcE;


end Behavioral;
