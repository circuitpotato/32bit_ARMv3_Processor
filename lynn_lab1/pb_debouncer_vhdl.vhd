--Code by: circuitpotato
--Visit downtothecircuits.wordpress.com for more information
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pb_debouncer_vhdl is
    Port ( i_pb : in std_logic;             --push_button
           i_clk: in std_logic;             --clock
           
           o_single_pulse: out std_logic);  --output signal
end pb_debouncer_vhdl;

architecture Behavioral of pb_debouncer_vhdl is
    signal clk_3hz: std_logic;
    signal dff1_out: std_logic;
    signal dff2_out: std_logic;
    signal dff2_inv_out: std_logic;
    
    component clock_divide_vhdl is
        generic (i_number: integer:=0);
        Port    (i_clock: in std_logic;
                 o_clock: out std_logic);
    end component;    
    component dff_vhdl is
        Port ( i_d : in std_logic;
               i_clk: in std_logic;
               o_q: out std_logic);
    end component;
    
begin
    --count= (Freq_CLK / (2*Freq_desired )) - 1 
    clk3Hz: clock_divide_vhdl 
        generic map (i_number => 16666665)
        port map    (i_clock => i_clk, o_clock => clk_3hz);  
        
    dff1: dff_vhdl 
        port map (i_d=>i_pb, i_clk=>clk_3hz, o_q=>dff1_out);
    dff2: dff_vhdl
        port map (i_d=>dff1_out, i_clk=>clk_3hz, o_q=>dff2_out);
        
    dff2_inv_out <= not dff2_out;
    o_single_pulse <= dff2_inv_out and dff1_out;
end Behavioral;
