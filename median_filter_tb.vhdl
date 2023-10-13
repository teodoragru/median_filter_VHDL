library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity median_filter_tb is
--  Port ( );
end median_filter_tb;

architecture Behavioral of median_filter_tb is

    constant C_CLK_PERIOD: time := 8 ns;
    
    component  median_filter is
        port ( 
            clk : in std_logic;
            reset : in std_logic;
            start_medijana : in std_logic;
            
            tx : out std_logic
        );
    end component;
    
    
    signal reset :  std_logic := '1';
    signal clk : std_logic  := '1' ;
    
    signal start_medijana : std_logic := '0';
    signal tx : std_logic;

begin
    DUT : entity work.median_filter(Behavioral)
        port map (
            clk => clk,
            reset => reset,
            start_medijana => start_medijana,
            tx => tx
        );
    
    clk <= not clk after C_CLK_PERIOD/2;
    
    STIMULUS: process is
    begin
        reset <= '1';
        start_medijana <= '0';
        wait for 5*C_CLK_PERIOD;
        
        reset <= '0';
        wait for 5*C_CLK_PERIOD;
        
        start_medijana <= '1';
        wait for 50*C_CLK_PERIOD;
        start_medijana <= '0';
        wait for 100000*C_CLK_PERIOD;
        
        start_medijana <= '1';
        wait for 50*C_CLK_PERIOD;
        start_medijana <= '0';
        
        wait;
    end process STIMULUS;

end Behavioral;