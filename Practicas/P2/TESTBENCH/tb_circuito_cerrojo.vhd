library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_circuito_cerrojo is
end tb_circuito_cerrojo;

architecture beh of tb_circuito_cerrojo is

component cerrojo

  port ( clk, rst, boton: in std_logic;
         switches: in std_logic_vector(7 downto 0);
         leds: out std_logic_vector(15 downto 0);
         display: out std_logic_vector(6 downto 0);
         an: out std_logic_vector(3 downto 0)
        );
end component;

--Entradas
signal clk, rst: std_logic;
signal boton: std_logic;
signal Switches: std_logic_vector(7 downto 0);

--Salidas
signal led: std_logic_vector(15 downto 0);
signal Disp7seg: std_logic_vector(6 downto 0);
signal an: std_logic_vector(3 downto 0);

--Constante
  constant clk_period : time := 40ns; 

begin

    circuito : cerrojo port map(
        clk => clk,
        rst => rst,
        boton => boton,
        switches => Switches,
        leds => led,
        display => Disp7seg,
        an => an
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
    boton <= '1';
    Switches <= "01010101";
    wait for 0.2 sec;
    boton <= '0';
    wait for 0.2 sec; 
    boton <= '1';
    Switches <= "01010100";
    wait for 0.2 sec; 
    boton <= '0';
    wait for 0.2 sec;
    boton <= '1';
    Switches <= "01010101"; 
    wait for 0.2 sec;
    boton <= '0';
    wait;
    end process p_sim;

end beh;