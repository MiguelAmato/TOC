library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ASM is
    port(
        clk, rst: in std_logic;
        init, fin: in std_logic;
        display : out  STD_LOGIC_VECTOR (6 downto 0);
        display_enable : out  STD_LOGIC_VECTOR (3 downto 0);
        leds: out std_logic_vector(9 downto 0)
    );
end ASM;

architecture asm of ASM is

    -- Camino de Datos
    component DataPath is
        port (
            clk, rst: in std_logic;
            control: in std_logic_vector(3 downto 0);
            control_led: in std_logic_vector(1 downto 0);
            status: out std_logic_vector(1 downto 0); 
            o1, o2: out std_logic_vector(3 downto 0);
            leds: out std_logic_vector(9 downto 0)
        );
    end component DataPath;
    
    -- Unidad de Control
    component ControlUnit is 
        port (
            clk, rst: in std_logic;
            init: in std_logic;
            fin: in std_logic;
            status: in std_logic_vector(1 downto 0);
            control: out std_logic_vector(3 downto 0);
            control_led: out std_logic_vector(1 downto 0)
        );
    end component ControlUnit;
    
    -- Debouncer botones
    component debouncer is
      port (
        rst             : in  std_logic;
        clk             : in  std_logic;
        x               : in  std_logic;
        xDeb            : out std_logic;
        xDebFallingEdge : out std_logic;
        xDebRisingEdge  : out std_logic
        );
    end component debouncer;
    
    -- Displays
    component displays is
        Port ( 
            rst : in STD_LOGIC;
            clk : in STD_LOGIC;       
            digito_0 : in  STD_LOGIC_VECTOR (3 downto 0);
            digito_1 : in  STD_LOGIC_VECTOR (3 downto 0);
            digito_2 : in  STD_LOGIC_VECTOR (3 downto 0);
            digito_3 : in  STD_LOGIC_VECTOR (3 downto 0);
            display : out  STD_LOGIC_VECTOR (6 downto 0);
            display_enable : out  STD_LOGIC_VECTOR (3 downto 0)
         );
    end component displays;
    
    -- Senales auxiliares internas
    signal control: std_logic_vector(3 downto 0);
    signal control_led: std_logic_vector(1 downto 0);
    signal status: std_logic_vector(1 downto 0); 
    signal o1, o2: std_logic_vector(3 downto 0);
    signal boton_init, boton_fin: std_logic;
    signal boton_aux1, boton_aux2, boton_aux3, boton_aux4: std_logic;
    
begin

    i_dp: DataPath
        port map (
            clk => clk,
            rst => rst,
            control => control,
            control_led => control_led,
            status => status,
            o1 => o1,
            o2 => o2,
            leds => leds 
        );
        
    i_deb_init: debouncer
        port map (
            rst => rst,
            clk => clk,
            x => init,
            xDeb => boton_aux1,
            xDebFallingEdge => boton_aux2, -- Cambiar boton_init
            xDebRisingEdge => boton_init
        );
        
    i_deb_fin: debouncer
    port map (
        rst => rst,
        clk => clk,
        x => fin,
        xDeb => boton_aux3,
        xDebFallingEdge => boton_aux4, -- Cambiar boton_fin
        xDebRisingEdge => boton_fin
    );
        
    i_cu: ControlUnit
        port map (
            clk => clk,
            rst => rst,
            init => boton_init, -- Cambiar a boton_init
            fin => boton_fin, -- Cambiar a boton_fin
            status => status,
            control => control,
            control_led => control_led
        );
     
    i_disp: displays
        port map (
            rst => rst,
            clk => clk,
            digito_0 => o1,
            digito_1 => o2,
            digito_2 => "0000",
            digito_3 => "0000",
            display => display,
            display_enable => display_enable
        );
   
end asm;