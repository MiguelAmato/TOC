library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DataPath is
    port (
        clk, rst: in std_logic;
        a_in, b_in: in std_logic_vector(7 downto 0);
        control: in std_logic_vector(4 downto 0);
        status: out std_logic_vector(3 downto 0);
        acc: out std_logic_vector(7 downto 0)
        ); 
end DataPath;

architecture dp of DataPath is
    
-- A algunas de las senales internas les he llamado mux y reg
-- porque estoy asumiendo que a la hora de la sintesis se crearan
-- multiplexores y registros.
     
-- Senal de control de multiplexores
    signal ini: std_logic; 
    
-- Senales de control registros
    signal ld_a, ld_b, ld_acc, ld_n: std_logic;
    
-- Senales de estado
    signal n_max: std_logic;     
     
-- Senales internas
    -- a
    signal a_out: std_logic_vector(7 downto 0);
    -- b
    signal b_out: std_logic_vector(7 downto 0);
    -- acc
    signal acc_out: std_logic_vector(7 downto 0);
    -- n
    signal n_out: std_logic_vector(2 downto 0);

    begin
    
-- El vector de control asigna los valores a las senales internas
    (ini, ld_a, ld_b, ld_acc, ld_n) <= control;
    
-- Registro con desplazamiento a la izquierda (a)
    p_a: process(clk, rst, a_out) 
    begin
        if rst = '1' then 
            a_out <= (others => '0');
        elsif rising_edge(clk) then
            if ld_a = '1' then
                if ini = '1' then
                    a_out <= a_in;
                else 
                    a_out <= a_out(6 downto 0) & '0';
                end if;
            end if;
        end if;
    end process;
    
-- Registro con desplazamiento a la derecha (b)
    p_b: process(clk, rst, b_out) 
    begin
        if rst = '1' then 
            b_out <= (others => '0');
        elsif rising_edge(clk) then
            if ld_b = '1' then
                if ini = '1' then
                    b_out <= b_in;
                else 
                    b_out <= '0' & b_out(7 downto 1);
                end if;
            end if;
        end if;
    end process;
    
-- Proceso del acumulador
    p_acc: process(clk, rst, acc_out) 
    begin
        if rst = '1' then 
            acc_out <= (others => '0');
        elsif rising_edge(clk) then
            if ld_acc = '1' then
                if ini = '1' then 
                    acc_out <= (others => '0');
                else
                    acc_out <= std_logic_vector(unsigned(acc_out) + unsigned(a_out));
                end if;
            end if;
        end if;
    end process;
    
    p_n: process(clk, rst) 
    begin
        if rst = '1' then
            n_out <= (others => '0');
        elsif rising_edge(clk) then
            if ini = '1' then
                n_out <= (others => '0');
            elsif ld_n = '1' then
                if n_out < "100" then
                    n_out <= std_logic_vector(unsigned(n_out) + 1);
                end if;
            end if;
        end if;
    end process;
    
    -- Asignamos los valores para las senales de estado
    status <= (n_out(2), n_out(1), n_out(0), b_out(0));
    acc <= acc_out;
    
end dp;
        
      