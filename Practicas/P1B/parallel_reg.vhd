----------------------------------------------------------------------------------
-- Company:        Universidad Complutense de Madrid
-- Engineer:       Miguel Antonio Amato Hermo
-- 
-- Create Date:    29/09/2021
-- Design Name:    Practica 1b 
-- Module Name:    parallel_reg - rtl
-- Project Name:   Practica 1b 
-- Target Devices: 
-- Tool versions:  
-- Description:    Registro
-- Dependencies: 
-- Revision: 
-- Additional Comments: En las transparencias aparece el rst en la lista de sensibilidad pero luego el rst es asincrono
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity parallel_reg is 
    port (  clk, rst, load: in std_logic;
            I: in std_logic_vector(3 downto 0);
            O: out std_logic_vector(3 downto 0) );
end parallel_reg;

architecture circuit of parallel_reg is 

begin
    
    process(clk)
    begin
    
    if rising_edge(clk) then
        if rst = '1' then
            O <= "0000";
        elsif load = '1' then
            O <= I;
        end if;
    end if;
    end process;
    
end circuit;  