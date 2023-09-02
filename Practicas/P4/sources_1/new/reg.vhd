library IEEE;
use IEEE.std_logic_1164.all;

entity reg is 
    port (  clk, rst, load: in std_logic;
            I: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0) );
end reg;

architecture circuit of reg is 

begin
    process(clk, rst)
    begin
    if rst = '1' then 
        O <= (others => '0');
    elsif rising_edge(clk) then
        if load = '1' then
            O <= I;
        end if;
    end if;
    end process;
end circuit;  