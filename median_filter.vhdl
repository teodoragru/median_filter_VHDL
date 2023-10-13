library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package t_array_definition is
    type t_array is array (8 downto 0) of std_logic_vector(7 downto 0);
end t_array_definition;

package body t_array_definition is
    
end package body t_array_definition;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package fifo_definition is
    type fifo is array (252 downto 0) of std_logic_vector(7 downto 0);
end fifo_definition;

package body fifo_definition is
    
end package body fifo_definition;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package RAM_definitions_PK is
    impure function clogb2 (depth: in natural) return integer;
end RAM_definitions_PK;

package body RAM_definitions_PK is
    --  The following function calculates the address width based on specified RAM depth
    impure function clogb2( depth : natural) return integer is
        variable temp    : integer := depth;
        variable ret_val : integer := 0;
    begin
        while temp > 1 loop
            ret_val := ret_val + 1;
            temp    := temp / 2;
        end loop;
        return ret_val;
    end function;
end package body RAM_definitions_PK;




library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
library work;
use work.RAM_definitions_PK.all;
use work.t_array_definition.all;
use work.fifo_definition.all;

entity median_filter is
port (
	clk			: in	std_logic;		
	reset			: in	std_logic;		
	tx			: out	std_logic;		
	start_transfer  : in	std_logic;
	start_medijana : in	std_logic
);
end median_filter;

architecture Behavioral of median_filter is
    
    signal edge1	:	std_logic;
    signal edge2	:	std_logic;
    
    signal read	:	std_logic;
    signal write	:	std_logic;
    
    signal data	:	std_logic_vector(7 downto 0);
    
    signal addrr	:	std_logic_vector((clogb2(256 * 256) - 1) downto 0);
    signal addrw	:	std_logic_vector((clogb2(256 * 256) - 1) downto 0);
    
    signal tx_dvalid	:	std_logic;
    signal busy_prev	:	std_logic;
    
    signal busy : std_logic;

    type State_t is ( stIdle, stSend, stMedian);
    signal state_reg, next_state : State_t;
    
    signal a : t_array;
    signal fifo1 : fifo; --- array of 253 bytes
    signal fifo2 : fifo; --- array of 253 bytes
    signal med : std_logic_vector(7 downto 0);
    
    
    component im_ram is 
        generic (
        G_RAM_WIDTH : integer := 8;            		   
        G_RAM_DEPTH : integer := 256*256; 				        
        G_RAM_PERFORMANCE : string := "LOW_LATENCY"   
    );
     port (
        addra : in std_logic_vector((clogb2(G_RAM_DEPTH)-1) downto 0);     
        addrb : in std_logic_vector((clogb2(G_RAM_DEPTH)-1) downto 0);     
        dina  : in std_logic_vector(G_RAM_WIDTH-1 downto 0);		  
        clka  : in std_logic;                       			  
        wea   : in std_logic;                       			  
        enb   : in std_logic;                       			  
        rstb  : in std_logic;                       			  
        regceb: in std_logic;                       			  
        doutb : out std_logic_vector(G_RAM_WIDTH-1 downto 0) 		  
    );
    end component;
    
    component edge_detector is 
        port ( 
        clk : in std_logic;
        reset : in std_logic;
        btn : in std_logic;
        edge : out std_logic
    );
    end component;

    component uart_tx is 
        generic (
            CLK_FREQ	: integer := 125;		
            SER_FREQ	: integer := 115200		
        );
        port (
         
            clk			: in	std_logic;		
            rst			: in	std_logic;	
            tx			: out	std_logic;		
            par_en		: in	std_logic;	
            tx_dvalid   : in	std_logic;					
            tx_data		: in	std_logic_vector(7 downto 0);
            tx_busy     : out   std_logic                       
        );
    end component;
    
    component medijana is 
        port ( 
            clk : in std_logic;
            a : in t_array;
            med : out std_logic_vector(7 downto 0)
  );
    end component;
    
    
begin
    RAM_M:
        im_ram
            port map (
                addrb  => addrr,
                clka   => clk,
                addra => addrw,
                dina => med,
                wea => write,
                enb => '1',
                rstb => reset,
                regceb   => '1',
                doutb  => data
            );
        
    UART_M:
        uart_tx
            port map (
                rst  => reset,
                clk   => clk,
                tx => tx,
                tx_dvalid => tx_dvalid,
                tx_busy => busy,
                tx_data => data,
                par_en   => '0'
            );        
    TRANSFER_DETECTOR_P:
        edge_detector
            port map (
                reset  => reset,
                clk   => clk,
                btn => start_transfer,
                edge => edge1
            );
    MEDIANA_DETECTOR_P:
        edge_detector
            port map (
                reset  => reset,
                clk   => clk,
                btn => start_medijana,
                edge => edge2
            );   
    
    MEDIANA_P:
        medijana  
            port map(
              clk => clk,
              a => a,
              med => med
            );     
          
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
    
    NEXT_STATE_LOGIC: process (edge1, edge2, state_reg, addrr, addrw) is
    begin
        case state_reg is
            when stIdle =>
                if edge1 = '1'  then
                    next_state <= stSend;
                else
                    if edge2 = '1' then
                        next_state <= stMedian;
                    else 
                        next_state <= stIdle;
                    end if;
                end if;
            when stSend =>
                if busy = '0' and  to_integer(unsigned(addrr)) = 2 ** addrr'length - 1 then
                    next_state <= stIdle;
                else
                    next_state <= stSend;
                end if;
            when stMedian =>
                if to_integer(unsigned(addrw)) = 2 ** addrw'length - 257 then
                    next_state <= stIdle;
                else 
                    next_state <= stMedian;
                end if;   
        end case;
    end process NEXT_STATE_LOGIC;
    
    
     CNT_PROC: process(reset, clk) is
        variable addrr_var : integer range 0 to 256*256 - 1;
        variable addrw_var : integer range 0 to 256*256 - 1;
    begin
        addrr_var := to_integer(unsigned(addrr));
        addrw_var := to_integer(unsigned(addrw));
        if reset = '1' then
            addrr <= (others => '0');
            addrw <= "0000000100000001";
        else
            if rising_edge(clk) then
                if state_reg = stSend then
                    write <= '0';
                    if busy_prev = '1' and busy = '0' then
                        addrr_var := addrr_var + 1;
                        addrr <= std_logic_vector(to_unsigned(addrr_var, addrr'length));      
                    end if;
                else
                    if state_reg = stMedian then
                        if addrr_var >= 523 then
                            write <= '1';
                            addrr_var := addrr_var + 1;
                            addrw_var := addrw_var + 1;
                            addrr <= std_logic_vector(to_unsigned(addrr_var, addrr'length));
                            addrw <= std_logic_vector(to_unsigned(addrw_var, addrw'length));
                        else
                            write <= '0';
                            addrr_var := addrr_var + 1;
                            addrr <= std_logic_vector(to_unsigned(addrr_var, addrr'length));
                        end if;   
                    else
                        addrw <= "0000000100000001";
                        addrr <= (others => '0');
                        write <= '0';
                    end if;
                end if;
                busy_prev <= busy;
            end if;           
        end if;
        
    end process;
    FILTER_PROC: process (clk) is
    variable addrr_var : integer range 0 to 256*256 - 1;
    begin
        addrr_var := to_integer(unsigned(addrr));
        if rising_edge(clk) then
            if state_reg = stMedian then
                case addrr_var is
                    when 0 to 2 |256 to 258 |512 to 514 =>  
                        a(addrr_var mod 253) <= data;
                    when 3 to 255 =>                           
                        fifo1(addrr_var - 3) <= data;              
                    when 259 to 511 =>               
                        fifo2(addrr_var- 259) <= data;     
                    when others =>
                        a(0) <= a(1);
                        a(1) <= a(2);
                        a(2) <= fifo1(0);
                        
                        a(3) <= a(4);
                        a(4) <= a(5);
                        a(5) <= fifo2(0);
                        
                        a(6) <= a(7);
                        a(7) <= a(8);
                        a(8) <= data;
                        
                        LOOP_1: for i in 0 to 251 loop
                            fifo2(i) <= fifo2(i + 1);
                            fifo1(i) <= fifo1(i + 1);
                         end loop LOOP_1;    
                        
                        fifo1(252) <= a(3);
                        fifo2(252) <= a(6);
                end case;          
            end if;
        end if;
        
    end process;
    

    OUTPUT_LOGIC: process (state_reg) is
    begin
        if state_reg = stSend then
            tx_dvalid <= '1';
        else
            tx_dvalid <= '0';
        end if;
         
    end process OUTPUT_LOGIC;
    

    
end Behavioral;