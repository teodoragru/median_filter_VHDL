library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detector is
    port ( 
        clk : in std_logic;
        reset : in std_logic;
        btn : in std_logic;
        edge : out std_logic
    );
end edge_detector;

architecture Behavioral of edge_detector is
    type State_t is (stIdle, stEdge, stWait);
    signal state_reg, next_state : State_t;
begin
    
    STATE_TRANSITION: process (clk, reset) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state_reg <= stIdle;
            else
                state_reg <= next_state;            
            end if;
        end if;
    end process STATE_TRANSITION;
    
    NEXT_STATE_LOGIC: process (btn, state_reg) is
    begin
        case state_reg is
            when stIdle =>
                if btn = '0' then
                    next_state <= stIdle;
                else
                    next_state <= stEdge;
                end if;
            when stEdge =>
                if btn = '0' then
                    next_state <= stIdle;
                else
                    next_state <= stWait;
                end if;            
            when stWait =>
                if btn = '0' then
                    next_state <= stIdle;
                else
                    next_state <= stWait;
                end if;
        end case;
    end process NEXT_STATE_LOGIC;
    
    OUTPUT_LOGIC: process (state_reg) is
    begin
        if state_reg = stEdge then
            edge <= '1';
        else
            edge <= '0';
        end if;
    end process OUTPUT_LOGIC;
    
end Behavioral;
