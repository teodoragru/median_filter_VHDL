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

entity medijana is
  port ( 
    clk : in std_logic;
    a : in t_array;
    med : out std_logic_vector(7 downto 0)
  );
end medijana;

architecture Behavioral of medijana is
    
    signal a1,a2,a3,a4,a5,a6,a7,a8,a_med : t_array;
    
begin


    PROC1: process(clk) is
    
    
    begin
    if rising_edge(clk) then
    p1: for i in 0 to 3 loop  
             
            if a(2*i) > a(2*i+1) then
                a1(2*i+1) <= a(2*i);
                a1(2*i) <= a(2*i + 1);
            else 
                a1(2*i) <= a(2*i);
                a1(2*i+1) <= a(2*i+1);               
            end if;
        end loop p1;
    a1(8) <= a(8); 
    end if;
    end process;    
            
    
    PROC2: process(clk) is
  
    begin    
    if rising_edge(clk) then 
        p2: for i in 0 to 1 loop  
 
            if a1(4*i) > a1(4*i+2) then
                a2(4*i+2) <= a1(4*i);
                a2(4*i) <= a1(4*i + 2);
            else 
                a2(4*i) <= a1(4*i);
                a2(4*i+2) <= a1(4*i+2);
            end if;
            
              
            if a1(4*i+1) > a1(4*i+3) then
                a2(4*i + 3) <= a1(4*i + 1);
                a2(4*i + 1) <= a1(4*i + 3);
            else
                a2(4*i + 1) <= a1(4*i + 1);
                a2(4*i + 3) <= a1(4*i + 3);
                
            end if;
            
        end loop p2;
        a2(8) <= a1(8);
        end if;
        end process;
    
    

   PROC3: process(clk) is
        
       begin  
       if rising_edge(clk) then
         p3: for i in 0 to 1 loop  
            
            if a2(4*i + 1) > a2(4*i+2) then
                a3(4*i + 1) <= a2(4*i + 2);
                a3(4*i + 2) <= a2(4*i + 1);
             else
                a3(4*i + 1) <= a2(4*i + 1);
                a3(4*i + 2) <= a2(4*i + 2);
                
            end if;
        a3(0) <= a2(0);
        a3(3) <= a2(3);
        a3(4) <= a2(4);
        a3(7) <= a2(7);
        a3(8) <= a2(8);
         end loop p3;
         end if;
     end process;
    
    PROC4: process(clk) is

    begin 
    if rising_edge(clk) then
       p4: for i in 0 to 3 loop  
          
            if a3(i) > a3(i + 4) then
                a4(i) <= a3(i+4);
                a4(i + 4) <= a3(i);
            else
                a4(i) <= a3(i);
                a4(i + 4) <= a3(i+4);
            end if;
       end loop p4;
       a4(8) <= a3(8);
       end if;
       end process;
    

  PROC5: process(clk) is
  
    begin
    if rising_edge(clk) then
    p5: for i in 0 to 1 loop  
            if a4(i+2) > a4(i + 4) then
                a5(i+2) <= a4(i+4);
                a5(i + 4) <= a4(i+2);
            else
                a5(i+2) <= a4(i+2);
                a5(i + 4) <= a4(i+4);
            end if;
       end loop p5;
    a5(0) <= a4(0);
    a5(1) <= a4(1);
    a5(6) <= a4(6);
    a5(7) <= a4(7);
    a5(8) <= a4(8);
    end if;
       end process;
    PROC6: process(clk) is
    begin
    if rising_edge(clk) then
    p6: for i in 0 to 2 loop  
        
            if a5(2*i+1) > a5(2*i+2) then
                a6(2*i+1) <= a5(2*i+2);
                a6(2*i+2) <= a5(2*i+1);
            else
                a6(2*i+1) <= a5(2*i+1);
                a6(2*i+2) <= a5(2*i+2);
            end if;
           
       end loop p6;
       a6(7) <= a5(7);
       if a5(0) > a5(8) then
            a6(0) <= a5(8);
            a6(8) <= a5(0);
       else
            a6(0) <= a5(0);
            a6(8) <= a5(8);
       end if; 
       end if;
       end process;

     PROC7: process(clk) is
    variable k : integer range 0 to 9;
    begin
    if rising_edge(clk) then
    a7(0) <= a6(0);
    a7(1) <= a6(1);
    a7(2) <= a6(2);
    a7(3) <= a6(3);
    a7(5) <= a6(5);
    a7(6) <= a6(6);
    a7(7) <= a6(7);
    if a6(4) > a6(8) then
            a7(4) <= a6(8);
            a7(8) <= a6(4);
       else
            a7(4) <= a6(4);
            a7(8) <= a6(8);
       end if;
        

       end if;
    end process;
   PROC8: process(clk) is
    
    begin
    if rising_edge(clk) then
    p8: for i in 0 to 1 loop  
            if a7(i+2) > a7(i+4) then
                a8(i+2) <= a7(i+4);
                a8(i+4) <= a7(i+2);
            else
                a8(i+2) <= a7(i+2);
                a8(i + 4) <= a7(i+4);
            end if;
       end loop p8;
    a8(0) <= a7(0);
    a8(1) <= a7(1);
    a8(6) <= a7(6);
    a8(7) <= a7(7);
    a8(8) <= a7(8);
    end if;
    end process;
    PROC9: process(clk) is
    begin
    if rising_edge(clk) then
    if a8(3) > a8(4) then
            med <= a8(3);
       else
            med <= a8(4);
    end if;
    end if;
    end process;
end Behavioral;