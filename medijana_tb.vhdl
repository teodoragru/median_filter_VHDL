library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



package t_array_definition is
    type t_array is array (8 downto 0) of std_logic_vector(7 downto 0);
end t_array_definition;

package body t_array_definition is
    
end package body t_array_definition;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.t_array_definition.all;

entity medijana_tb is
--  Port ( );
end medijana_tb;

architecture Behavioral of medijana_tb is
    constant C_CLK_PERIOD: time := 10 ms;
    component medijana is
        port ( 
            clk : in std_logic;
            a : in t_array;
            med : out std_logic_vector(7 downto 0)
        );
    end component;
    signal a : t_array;
    signal med : std_logic_vector(7 downto 0);
    signal clk : std_logic := '1';
begin
    DUT : medijana 
            port map (
                clk => clk,
                a => a,
                med => med
            );
    
    clk <= not clk after C_CLK_PERIOD/2;
    
    STIMULUS: process is
        begin
            a(0) <= "00000111";
            a(1) <= "00000011";
            a(2) <= "00000101";
            a(3) <= "00000001";
            a(4) <= "00000100";
            a(5) <= "00000010";
            a(6) <= "00000110";
            a(7) <= "00000000";
            a(8) <= "00001001";
--            in_signal <= '0';
            wait for C_CLK_PERIOD;
            
            a(5) <= "11110001";
            a(6) <= "00010101";
            a(7) <= "00001100";
            
            wait for C_CLK_PERIOD;
             
             
            a(0) <= "11110001";
            a(1) <= "01101100";
            a(2) <= "01011000";
--           
            wait;
        end process STIMULUS;
end Behavioral;