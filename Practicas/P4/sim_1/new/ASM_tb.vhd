library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity simul is
end simul;

architecture Behavioral of simul is

component ASM is
    port(
        clk, rst: in std_logic;
        init: in std_logic;
        a_in, b_in: in std_logic_vector(3 downto 0);
        display : out  STD_LOGIC_VECTOR (6 downto 0);
        done: out std_logic_vector(15 downto 0);
        display_enable : out  STD_LOGIC_VECTOR (3 downto 0)
    );
end component;

-- Inputs
  signal clk, rst: std_logic;
  signal ini: std_logic;
  signal b, a: std_logic_vector(3 downto 0);
  -- Outputs
 signal led: std_logic_vector(15 downto 0);
 signal seg: std_logic_vector(6 downto 0);
 signal dis_en: std_logic_vector(3 downto 0);
--Constante
  constant clk_period : time := 10ns; 


begin

moduloMult: ASM
port map(
    rst => rst,
    clk => clk,
    a_in => a,
    b_in => b, 
    init => ini,
    done => led,
    display => seg,
    display_enable => dis_en
    );

  -- Input clock
  p_clk : process
  begin
    clk <= '0', '1' after 5 ns;
    wait for 10 ns;
  end process p_clk;

       p_sim : process
    begin
    rst <= '1';
    ini <= '1';
    a <= "0011";
    b <= "0011";
    wait for 40 ns;
    rst <= '0';
    wait for 40 ns;
    ini <= '0';
    wait for 80 ns;
    ini <= '1';
    wait;
    end process p_sim;


end Behavioral;