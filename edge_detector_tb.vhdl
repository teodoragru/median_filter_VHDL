library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detector_tb is
--  Port ( );
end edge_detector_tb;

architecture Behavioral of edge_detector_tb is
    
    constant C_CLK_PERIOD: time := 8 ns;
    
    component edge_detector is
        port ( 
            clk : in std_logic;
            reset : in std_logic;
            btn : in std_logic;
            edge : out std_logic
        );
    end component;
    
    signal clk_tb : std_logic := '1';
    signal reset : std_logic;
    signal btn : std_logic;
    signal edge : std_logic;
    
begin
    DUT : edge_detector 
        port map (
            clk => clk_tb,
            reset => reset,
            btn => btn,
            edge => edge
        );
    
    clk_tb <= not clk_tb after C_CLK_PERIOD/2;
    
    STIMULUS: process is
    begin
        reset <= '1';
        btn <= '0';
        wait for C_CLK_PERIOD*3.2;
        reset <= '0';
        wait for C_CLK_PERIOD*2;
        btn <= '1';
        wait for C_CLK_PERIOD*5;
        btn <= '0';
        wait for C_CLK_PERIOD*2;
        btn <= '1';
        wait for C_CLK_PERIOD*2;
        reset <= '1';
        wait;
    end process STIMULUS;
end Behavioral;