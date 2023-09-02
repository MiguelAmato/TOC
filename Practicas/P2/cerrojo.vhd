library IEEE;
use IEEE.std_logic_1164.all;

entity cerrojo is
  port ( clk, rst, boton: in std_logic;
         switches: in std_logic_vector(7 downto 0);
         leds: out std_logic_vector(15 downto 0);
         display: out std_logic_vector(6 downto 0);
         an: out std_logic_vector(3 downto 0) 
        );
end cerrojo;

architecture circuito of cerrojo is

component registro is 
    port (  clk, rst, load: in std_logic;
            I: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0) );
end component;

component debouncer is
  port (
    rst             : in  std_logic;
    clk             : in  std_logic;
    x               : in  std_logic;
    xDeb            : out std_logic;
    xDebFallingEdge : out std_logic;
    xDebRisingEdge  : out std_logic
    );
end component;

component fsm is 
    port (  clk, rst, boton: in std_logic;
            eq: in std_logic;
            load: out std_logic;
            bloqueado: out std_logic;
            display: out std_logic_vector(3 downto 0)
          );
end component;

component conv_7seg is
  port (x       : in  std_logic_vector (3 downto 0);
        display : out std_logic_vector (6 downto 0));
end component;

signal load_i, es_igual, bloqueado, salida_debouncer, salida_debouncer_falling, salida_debouncer_rising, rst_negado: std_logic;
signal salida_registro: std_logic_vector(7 downto 0);
signal salida_display: std_logic_vector(3 downto 0);

begin

cmp_registro: registro port map (
    clk => clk,
    rst => rst,
    load => load_i,
    I => switches,
    O => salida_registro
);

rst_negado <= not(rst);

cmp_debouncer: debouncer port map (
    rst => rst_negado,
    clk => clk,
    x => boton,
    xDeb => salida_debouncer,            
    xDebFallingEdge => salida_debouncer_falling, 
    xDebRisingEdge => salida_debouncer_rising
);

process (salida_registro, switches)
begin
    if salida_registro = switches then
        es_igual <= '1';
    else 
        es_igual <= '0';
    end if;
end process;

cmp_fms: fsm port map (
    clk => clk,
    rst => rst,
    boton => salida_debouncer_falling,
    eq => es_igual,
    load => load_i,
    bloqueado => bloqueado,
    display => salida_display
);

cmp_conv: conv_7seg port map (
    x => salida_display,
    display => display
);

process (bloqueado)
begin 
    if bloqueado = '1' then
        leds <= (others => '0');
    elsif bloqueado = '0' then
        leds <= (others => '1');
    end if;
end process;

an <= "1110";

end circuito;