----------------------------------------------------------------------------------
-- Company:        Universidad Complutense de Madrid
-- Engineer:       Miguel Antonio Amato Hermo
-- 
-- Create Date:    29/09/2021
-- Design Name:    Practica 1b 
-- Module Name:    parallel_reg - rtl
-- Project Name:   Practica 2
-- Target Devices: 
-- Tool versions:  
-- Description:    Registro
-- Dependencies: 
-- Revision: 
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity registro is 
    port (  clk, rst, load: in std_logic;
            I: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0) );
end registro;

architecture circuit of registro is 

begin
    
    process(clk, rst)
    begin
    if rst = '0' then 
        O <= (others => '0');
    elsif rising_edge(clk) then
        if load = '1' then
            O <= I;
        end if;
    end if;
    end process;
    
end circuit;  