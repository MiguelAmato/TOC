library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_Tragaperras is
end TB_Tragaperras;

architecture beh of TB_Tragaperras is

component ASM is
    port(
        clk, rst: in std_logic;
        init, fin: in std_logic;
        display : out  STD_LOGIC_VECTOR (6 downto 0);
        display_enable : out  STD_LOGIC_VECTOR (3 downto 0);
        leds: out std_logic_vector(9 downto 0)
    );
end component ASM;

signal rst, clk, inicio, fin : std_logic;
signal led : std_logic_vector(9 downto 0);
signal display : std_logic_vector(6 downto 0);
signal display_enable : std_logic_vector(3 downto 0);

constant clk_period : time := 10ns; 

begin

UBT : ASM
port map(
    rst => rst,
    clk => clk,
    init => inicio,
    fin => fin,
    leds => led,
    display => display,
    display_enable => display_enable
);

p_clk : process 
  begin
     clk <= '0';
     wait for clk_period/2;
     clk <= '1';
     wait for clk_period/2;
end process p_clk;
  
p_sim : process
    begin
    rst <= '1';
    inicio <= '0';
    fin <= '0';
    wait for 20 ns;
    rst <= '0';
    inicio <= '1';
    wait for 100 ns;
    inicio <= '0';
    wait for 200 ns;
    fin <= '1';
    wait for 20 ns;
    rst <= '0';
    inicio <= '1';
    wait for 100 ns;
    inicio <= '0';
    wait for 200 ns;
    fin <= '1';
    wait for 20 ns;
    rst <= '0';
    inicio <= '1';
    wait for 100 ns;
    inicio <= '0';
    wait for 200 ns;
    fin <= '1';
    wait for 20 ns;
    rst <= '0';
    inicio <= '1';
    wait for 100 ns;
    inicio <= '0';
    wait for 200 ns;
    fin <= '1';
    wait;
end process p_sim;

end beh;