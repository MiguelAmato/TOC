library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ControlUnit is 
    port (
        clk, rst: in std_logic;
        init: in std_logic;
        fin: in std_logic;
        status: in std_logic_vector(1 downto 0);
        control: out std_logic_vector(3 downto 0);
        control_led: out std_logic_vector(1 downto 0)
    );
end ControlUnit;

architecture cu of ControlUnit is

    type tEstados is (atraer, iniciar, acabar, ganar, perder);
    signal estado, sig_estado: tEstados;
    
-- Senales de status
    -- Si los dos resultados son iguales esta a 1
    signal eq: std_logic;
    -- Tiempo del contador de los estados ganar y perder
    signal tiempo: std_logic;
    
-- Senales de control
    -- Control
    constant tiempo_en  : std_logic_vector(3 downto 0) := "0001";    
    constant cont_en    : std_logic_vector(3 downto 0) := "0010";
    constant ini        : std_logic_vector(3 downto 0) := "0100";
    constant reset_sec  : std_logic_vector(3 downto 0) := "1000";
    
    -- Control leds
    constant atrae      : std_logic_vector(1 downto 0) := "00";
    constant apaga      : std_logic_vector(1 downto 0) := "01";
    constant gana       : std_logic_vector(1 downto 0) := "10";
    constant pierde     : std_logic_vector(1 downto 0) := "11";
    
begin
   
   -- Damos valores desde el vector status
   (eq, tiempo) <= status;
   
    process (clk, rst) 
    begin
        if rst = '1' then
            estado <= atraer;
        elsif rising_edge(clk) then
            estado <= sig_estado;
        end if;
    end process;
    
    process (estado, init, fin, eq, tiempo) 
    begin
        case estado is
        when atraer =>
            if init = '1' then
                sig_estado <= iniciar;
            else
                sig_estado <= atraer;
            end if;
        when iniciar =>
            if fin = '1' then
                sig_estado <= acabar;
            else
                sig_estado <= iniciar;
            end if;
        when acabar =>
            if eq = '1' then
                sig_estado <= ganar;
            else
                sig_estado <= perder;
            end if;
        when ganar =>
            if tiempo = '1' then
                sig_estado <= atraer;
            else
                sig_estado <= ganar;
            end if;
        when perder =>
            if tiempo = '1' then
                sig_estado <= atraer;
            else
                sig_estado <= perder;
            end if;
        end case;
    end process;
    
    process (estado) 
    begin
        case estado is
        when atraer =>
            control <= ini;
            control_led <= atrae;
        when iniciar =>
            control <= reset_sec or cont_en;
            control_led <= apaga;
        when acabar =>
            control <= (others => '0');
            control_led <= apaga;
        when ganar =>
            control <= tiempo_en;
            control_led <= gana;
        when perder =>
            control <= tiempo_en;
            control_led <= pierde;
        end case;
    end process;

end cu;