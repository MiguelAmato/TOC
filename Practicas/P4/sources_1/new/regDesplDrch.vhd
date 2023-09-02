library IEEE;
use IEEE.std_logic_1164.all;

entity regDespDrch is 
    port (  clk, rst, load, despl: in std_logic;
            I: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0) );
end regDespDrch;

architecture circuit of regDespDrch is 
    signal aux : std_logic_vector(7 downto 0);
begin
    process(clk, rst)
    begin
        if rst = '1' then 
            aux <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                if despl = '0' then
                    aux <= I;
                else 
                    aux <= '0' & aux(7 downto 1);
                end if;
            end if;
        end if;
    end process;
    
    O <= aux;
end circuit; 