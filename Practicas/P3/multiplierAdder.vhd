library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplierAdder is 
    port (
        x: in std_logic_vector(3 downto 0);
        y: in std_logic_vector(3 downto 0);
        z: out std_logic_vector(7 downto 0)
    );
end multiplierAdder;

architecture circuitAdder of multiplierAdder is
    
    component adder8b is
    port(   a: in std_logic_vector(7 downto 0);
            b: in std_logic_vector(7 downto 0);
            c: out std_logic_vector(7 downto 0) ); 
    end component;
    
    signal y0, y1, y2, y3: unsigned(3 downto 0);
    signal i3, i2, i1, i0: unsigned(7 downto 0);
    signal o1, o2: std_logic_vector(7 downto 0); 
    
begin 
    
    y0 <= (others => y(0));
    y1 <= (others => y(1));
    
    i0 <= "0000" & (unsigned(x) and y0);
    i1 <= "000" & (unsigned(x) and y1) & "0";
     
    adder1: adder8b port map (
        a => std_logic_vector(i0(7 downto 0)),
        b => std_logic_vector(i1(7 downto 0)),
        c => o1   
    );
    
    y2 <= (others => y(2));
    
    i2 <= "00" & (unsigned(x) and y2) & "00";
    
    adder2: adder8b port map (
        a => std_logic_vector(i2(7 downto 0)),
        b => o1,
        c => o2   
    );
    
    y3 <= (others => y(3));
    
    i3 <= "0" & (unsigned(x) and y3) & "000";
    
    adder3: adder8b port map (
        a => std_logic_vector(i3(7 downto 0)),
        b => o2,
        c => z   
    );

end circuitAdder;