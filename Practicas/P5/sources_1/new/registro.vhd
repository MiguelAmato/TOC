library IEEE;
use IEEE.std_logic_1164.all;

entity registro is 
    port (  clk, rst, load, ini: in std_logic;
            I: in std_logic_vector(3 downto 0);
            O: out std_logic_vector(3 downto 0) );
end registro;

architecture circuit of registro is 

begin
    
    process(clk, rst)
    begin
    if rst = '1' then 
        O <= (others => '0');
    elsif rising_edge(clk) then
        if ini = '1' then
            O <= (others => '0');
        else
            if load = '1' then
                O <= I;
            end if;
        end if;
    end if;
    end process;
    
end circuit;  