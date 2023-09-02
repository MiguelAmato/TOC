library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cap is
  port (
        rst, clk: in std_logic;
        cap1, cap2: out std_logic
        );
end cap;

architecture cdr of cap is

    signal c1: unsigned(3 downto 0);
    signal c2: unsigned(3 downto 0);
    signal cap1_reg, cap2_reg: std_logic;
    
begin

    p_cap1: process(rst, clk)
    begin
        if rst = '1' then
            c1 <= (others => '0');
            cap1_reg <= '0';
        elsif rising_edge(clk) then
            if c1 = "0010" then -- 33,333,333 millones aprox "0001111111001010000001010101"
                c1 <= (others => '0');
                cap1_reg <= not cap1_reg;
            else
                c1 <= c1 + 1;
                cap1_reg <= cap1_reg;
            end if;
        end if;
    end process; 
     
    p_cap2: process(rst, clk)
    begin
        if rst = '1' then
            c2 <= (others => '0');
            cap2_reg <= '0';
        elsif rising_edge(clk) then
            if c2 = "0110" then -- 50 millones "0010111110101111000010000000"
                c2 <= (others => '0');
                cap2_reg <= not cap2_reg;
            else
                c2 <= c2 + 1;
                cap2_reg <= cap2_reg;
            end if;
        end if;
    end process; 
    cap1 <= cap1_reg;
    cap2 <= cap2_reg; 
end cdr;
    