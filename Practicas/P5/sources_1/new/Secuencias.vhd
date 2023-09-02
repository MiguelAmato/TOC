library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Secuencias is
    port (
        clk, rst, ini: in std_logic; 
        control_led: in std_logic_vector(1 downto 0);
        leds: out std_logic_vector(9 downto 0)
    );
end Secuencias;

architecture gs of Secuencias is

    -- Control leds
    constant atrae      : std_logic_vector(1 downto 0) := "00";
    constant apaga      : std_logic_vector(1 downto 0) := "01";
    constant gana       : std_logic_vector(1 downto 0) := "10";
    constant pierde     : std_logic_vector(1 downto 0) := "11";
    
    -- Informacion a tener en cuenta (Tiempos empleados para cada secuencia)
    constant t_atraer   : unsigned(27 downto 0) := "0001001100010010110100000000"; -- 0,2 seg
    constant t_final    : unsigned(27 downto 0) := "0011111110010100000010101010"; -- 0,6 seg
    
    -- Senales secuencia
    signal s_atraer, s_ganar, s_perder : std_logic_vector(9 downto 0);
    
    -- Contador 
    signal cntr_0 : unsigned(27 downto 0);
    signal cntr_f : unsigned(27 downto 0);
    
    -- Control desplazamiento y alternancia
    signal desplazar : std_logic;
    signal alternar : std_logic;
    
begin

    -- Contador desplazamiento
    p_despl: process(clk, rst)
    begin
        if rst = '1' then
            cntr_0 <= (others => '0');
            desplazar <= '0'; 
        elsif rising_edge(clk) then
            if cntr_0 = (24 downto 8 => '1', 7 downto 0 => '0') then -- cuidado
                cntr_0 <= (others => '0');
                desplazar <= '1';
            else
                cntr_0 <= cntr_0 + 1;
                desplazar <= '0';
            end if;
        end if;
    end process; 
    
    -- Contador alternancia
    p_alter: process(clk, rst)
    begin
        if rst = '1' then
            cntr_f <= (others => '0');
            alternar <= '0'; 
        elsif rising_edge(clk) then
            if cntr_f = (24 downto 8 => '1', 7 downto 0 => '0') then -- cuidado
                cntr_f <= (others => '0');
                alternar <= '1';
            else
                cntr_f <= cntr_f + 1;
                alternar <= '0';
            end if;
        end if;
    end process;
    
    -- Secuencia atraer
     p_atraer: process(rst, clk)
     begin
        if rst = '1' then
            s_atraer <= (others => '0');
        elsif rising_edge(clk) then
            if ini = '1' then
                s_atraer <= "0000000000";
            else
                if desplazar = '1' then
                    if s_atraer(0) = '1' then
                        s_atraer <= '0' & s_atraer(9 downto 1);
                    else 
                        s_atraer <= '1' & s_atraer(9 downto 1);
                    end if;
                else
                    s_atraer <= s_atraer;
                end if; 
            end if;
        end if;
    end process;
    
    -- Secuencia alternar
    p_alternar: process(rst, clk)
    begin
        if rst = '1' then
            s_ganar <= (others => '0');
            s_perder <= (others => '0');
        elsif rising_edge(clk) then
            if ini = '1' then
                s_ganar <= "1111111111";
                s_perder <= "0101010101";
            else 
                if alternar = '1' then 
                    s_ganar <= not s_ganar;
                    s_perder <= not s_perder;
                else 
                    s_ganar <= s_ganar;
                    s_perder <= s_perder;
                end if;
            end if;
        end if;
    end process;
    
    -- Seleccion de secuencia para los leds
    process(control_led)
    begin
        if control_led = atrae then
            leds <= s_atraer;
        elsif control_led = apaga then
            leds <= (others => '0');
        elsif control_led = gana then
            leds <= s_ganar;
        elsif control_led = pierde then
            leds <= s_perder;
        else 
            leds <= (others => '0');
        end if;
    end process;
    
end gs;