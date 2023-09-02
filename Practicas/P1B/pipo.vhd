library IEEE;
use IEEE.std_logic_1164.all;

entity pipo is 

    port (  clk, rst_reg, load: in std_logic;
            rst_divider: in std_logic;
            I: in std_logic_vector(3 downto 0);
            O: out std_logic_vector(3 downto 0) );
        
end pipo;

architecture circuit_pipo of pipo is
    
    component parallel_reg is
        port (      clk, rst, load: in std_logic;
                    I: in std_logic_vector(3 downto 0);
                    O: out std_logic_vector(3 downto 0) );
    end component;
    
    component divisor is
        port (
                rst        : in  std_logic;         -- asynch reset
                clk_100mhz : in  std_logic;         -- 100 MHz input clock
                clk_1hz    : out std_logic          -- 1 Hz output clock
              );
    end component;
    
    signal clk_1hz: std_logic;
    
begin

    registro: parallel_reg port map (
        clk => clk_1hz,
        rst => rst_reg,
        load => load,
        I => I,
        O => O
    );

    divider: divisor port map (
        rst => rst_divider,
        clk_100mhz => clk,
        clk_1hz => clk_1hz
    );
    
end circuit_pipo;