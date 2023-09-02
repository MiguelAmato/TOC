library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ControlUnit is 
    port (
        clk, rst: in std_logic;
        init: in std_logic;
        done: out std_logic;
        status: in std_logic_vector(4 downto 0);
        control: out std_logic_vector(5 downto 0)
    );
end ControlUnit;

architecture cu of ControlUnit is

    type tEstados is (s0, s1, s2, s3, s4, s5, s6, s7);
    signal estado, sig_estado: tEstados;
    
    signal b_lsb: std_logic;
    signal n: std_logic_vector(2 downto 0);
    signal neg: std_logic;
   
    constant inver  : std_logic_vector(5 downto 0) := "000001";
    constant ld_n   : std_logic_vector(5 downto 0) := "000010";
    constant ld_acc : std_logic_vector(5 downto 0) := "000100";
    constant ld_b   : std_logic_vector(5 downto 0) := "001000";
    constant ld_a   : std_logic_vector(5 downto 0) := "010000";
    constant ini    : std_logic_vector(5 downto 0) := "100000";
    
begin
    
    (neg ,n(2), n(1), n(0), b_lsb) <= status;
    
    process (clk, rst) 
    begin
        if rst = '1' then
            estado <= s0;
        elsif rising_edge(clk) then
            estado <= sig_estado;
        end if;
    end process;
    
    process (estado, init, n, b_lsb, neg) 
    begin
        case estado is
        when s0 =>
            if init = '1' then
                sig_estado <= s1;
            else
                sig_estado <= s0;
            end if;
        when s1 =>
            sig_estado <= s2; 
        when s2 =>
            sig_estado <= s3;    
        when s3 =>
            if n >= "100" then
                sig_estado <= s6;
            else
                if b_lsb = '1' then
                    sig_estado <= s4;
                else
                    sig_estado <= s5;
                end if;
            end if;
        when s4 =>
            sig_estado <= s3;
        when s5 =>
            sig_estado <= s3;
        when s6 =>
            if neg = '1' then
                sig_estado <= s7;
            else 
                sig_estado <= s0;
            end if;
        when s7 => 
            sig_estado <= s0;
        end case;
    end process;
    
    process (estado) 
    begin
        case estado is
        when s0 =>
            done <= '1';
            control <= (others => '0');
        when s1 =>
            done <= '0';
            control <=  ini or ld_a or ld_b or ld_acc;
        when s2 =>
            done <= '0';
            control <= (others => '0');
        when s3 =>
            done <= '0';
            control <= (others => '0');
        when s4 =>
            done <= '0';
            control <= ld_a or ld_b or ld_acc or ld_n;
        when s5 =>
            done <= '0';
            control <= ld_a or ld_b or ld_n;
        when s6 =>
            done <= '0';
            control <= (others => '0');
        when s7 =>
            done <= '0';
            control <= inver;
        end case;
    end process;

end cu;