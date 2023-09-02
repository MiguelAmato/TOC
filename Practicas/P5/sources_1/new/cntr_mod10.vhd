library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cntr_mod10 is
  generic (k : integer := 10;            
           n : integer := 4);           
  port (rst  : in  std_logic;           
        clk  : in  std_logic;  
        ld   : in  std_logic;         
        cntr : out std_logic_vector(n-1 downto 0));
end cntr_mod10;

architecture cntr of cntr_mod10 is

  signal cntr_reg : unsigned(n-1 downto 0);
  
begin

  cntr <= std_logic_vector(cntr_reg);

  p_cntr_reg : process(clk, rst)
  begin
    if rst = '1' then
      cntr_reg <= (others => '0');
    elsif rising_edge(clk) then
        if ld = '1' then
            if cntr_reg < (k-1) then
                cntr_reg <= cntr_reg+1;
            else
                cntr_reg <= (others => '0');
            end if;
        end if;
    end if;
  end process p_cntr_reg;

end cntr;
