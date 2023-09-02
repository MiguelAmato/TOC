library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplierNumeric is 
    port (
        X: in std_logic_vector(3 downto 0);
        Y: in std_logic_vector(3 downto 0);
        Z: out std_logic_vector(7 downto 0)
    );
end multiplierNumeric;

architecture circuitNumeric of multiplierNumeric is
begin
    Z <= std_logic_vector(unsigned(X) * unsigned(Y));
end circuitNumeric;
