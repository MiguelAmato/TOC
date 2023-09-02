----------------------------------------------------------------------------------
library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

-------------------------------------------------------------------------------
-- Entity
-------------------------------------------------------------------------------
entity tb_mult8 is
end tb_mult8;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------

architecture beh of tb_mult8 is
  -- Component Declaration for the Unit Under Test (UUT)
  component multiplierAdder is 
    port (
        clk, rst: std_logic;
        x: in std_logic_vector(3 downto 0);
        y: in std_logic_vector(3 downto 0);
        z: out std_logic_vector(7 downto 0)
    );
end component;

  -- Inputs
  signal X : std_logic_vector(3 downto 0) := (others => '0');
  signal Y : std_logic_vector(3 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

  -- Outputs
  signal Z : std_logic_vector(7 downto 0);

  -- Expected output
  signal Z_1, Z_2, Z_3 : std_logic_vector(7 downto 0) :=  (others =>'0');

   -- Clock period definitions
   constant clk_period : time := 10 ns;


begin

	-- Instantiate the Unit Under Test (UUT)
 -- Instantiate the Unit Under Test (UUT)
   uut: multiplierAdder PORT MAP (
          clk => clk,
          rst => rst,
          x => X,
          y => Y,
          z => Z
        );



   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

-- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      rst <= '1';
      wait until falling_edge(clk);	
      rst <= '0';
     
      -- First mult
      wait until falling_edge(clk);	
      X   <= std_logic_vector(to_unsigned(3, 4));
      Y   <= std_logic_vector(to_unsigned(4, 4));
      Z_1 <= std_logic_vector(to_unsigned(4*3, 8));

      wait until falling_edge(clk);	

      -- Second mult
      X   <= std_logic_vector(to_unsigned(15, 4));
      Y   <= std_logic_vector(to_unsigned(15, 4));
      Z_2 <= std_logic_vector(to_unsigned(15*15, 8));

      -- Results for 1st
      wait until falling_edge(clk);	
      assert Z = Z_1
        report "Error multiplying, "&integer'image(to_integer(unsigned(Z)))&
               " is not " &integer'image(to_integer(unsigned(Z_1)))
        severity error;

      -- Third mult
      X   <= std_logic_vector(to_unsigned(5, 4));
      Y   <= std_logic_vector(to_unsigned(7, 4));
      Z_3 <= std_logic_vector(to_unsigned(5*7, 8));
      
      -- Results for 2nd
      wait until falling_edge(clk);	
      assert Z = Z_2
        report "Error multiplying, "&integer'image(to_integer(unsigned(Z)))&
               " is not " &integer'image(to_integer(unsigned(Z_2)))
        severity error;

      -- Results for 3nd
      wait until falling_edge(clk);	
      assert Z = Z_3
        report "Error multiplying, "&integer'image(to_integer(unsigned(Z)))&
               " is not " &integer'image(to_integer(unsigned(Z_3)))
        severity error;

      wait;
   end process;

END;
