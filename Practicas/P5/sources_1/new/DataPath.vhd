library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DataPath is
    port (
        clk, rst: in std_logic;
        control: in std_logic_vector(3 downto 0);
        control_led: in std_logic_vector(1 downto 0);
        status: out std_logic_vector(1 downto 0); -- Aqui habra que añadir el write_enable en la avanzada
        o1, o2: out std_logic_vector(3 downto 0);
        leds: out std_logic_vector(9 downto 0)
    );
end DataPath;

architecture dp of DataPath is

-- Capacitador de frecuencia
    component cap is
      port (
            rst, clk: in std_logic;
            cap1, cap2: out std_logic
            );
    end component cap;

-- Componente contador modulo 10   
    component cntr_mod10 is
        generic (k : integer := 10;            
                 n : integer := 4);           
        port (rst  : in  std_logic;           
              clk  : in  std_logic;  
              ld   : in  std_logic;         
              cntr : out std_logic_vector(n-1 downto 0));
    end component cntr_mod10;
    
-- Registros que guardan el resultado
    component registro is 
        port (  clk, rst, load, ini: in std_logic;
                I: in std_logic_vector(3 downto 0);
                O: out std_logic_vector(3 downto 0) );
    end component registro;
    
-- Memoria contador 1
    COMPONENT bram_cont1
        PORT (
            clka : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

-- Memoria contador 2
    COMPONENT bram_cont2
        PORT (
            clka : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;
    
-- Generador de secuencias
    component Secuencias is
        port (
            clk, rst, ini: in std_logic; 
            control_led: in std_logic_vector(1 downto 0);
            leds: out std_logic_vector(9 downto 0)
        );
    end component Secuencias;   

-- Senales de control
    -- Control
    signal reset_sec, ini, cont_en, tiempo_en: std_logic;
    -- Control leds
    signal c_led: std_logic_vector(1 downto 0);

-- Senales de status
    signal eq, tiempo: std_logic;

-- Senales internas
    -- Capacitador de frecuencia
    signal cap_out1, cap_out2: std_logic;
    -- Contadores modulo 10 
    signal cont_out1, cont_out2: std_logic_vector(3 downto 0); 
    -- Memorias BRAM
    signal wea1: std_logic_vector(0 downto 0);
    signal wea2: std_logic_vector(0 downto 0);
    signal dina1: std_logic_vector(3 downto 0); -- ????????????????????????????????????????????????????????????????????????????????????????????
    signal dina2: std_logic_vector(3 downto 0); -- ????????????????????????????????????????????????????????????????????????????????????????????
    signal mem_out1, mem_out2: std_logic_vector(3 downto 0);
    -- Registros resultado
    signal reg_result_out1, reg_result_out2: std_logic_vector(3 downto 0);
    -- Contador 10 seg
    constant segs : unsigned(31 downto 0) := "00111011100110101100101000000000";
    signal cntr_seg: unsigned(31 downto 0);
    -- Generador de secuencias
    signal leds_aux: std_logic_vector(9 downto 0);
    
    constant w1 : std_logic_vector(0 downto 0) := "0";
    constant w2 : std_logic_vector(0 downto 0) := "0";
    
begin

-- Desde el vector de control asignamos los valores a las senales de control
    (reset_sec, ini, cont_en, tiempo_en) <= control;
    
-- Capacitador de frecuencia
    cap_p: cap
        port map (
            rst => rst,
            clk => clk,
            cap1 => cap_out1,
            cap2 => cap_out2
        );    

-- Contador modulo 10 (1)
    cntr1: cntr_mod10
        port map (
            clk => clk,
            rst => rst,
            ld => cap_out1,
            cntr => cont_out1
        );
    
-- Contador modulo 10 (2)    
    cntr2: cntr_mod10
        port map (
            clk => clk,
            rst => rst,
            ld => cap_out2,
            cntr => cont_out2
        );
        
-- Memoria 1
    bram1 : bram_cont1
        PORT MAP (
            clka => clk,
            wea => w1,
            addra => cont_out1, -- Tengo entendido que esto es lo que saco del contador
            dina => dina1,
            douta => mem_out1
        );

-- Memoria 2
    bram2 : bram_cont2
        PORT MAP (
            clka => clk,
            wea => w2,
            addra => cont_out2, -- Tengo entendido que esto es lo que saco del contador
            dina => dina2,
            douta => mem_out2
        );
      
-- Registro resultado 1
    reg1: registro
        port map (
            clk => clk,
            rst => rst,
            load => cont_en,
            ini => ini,
            I => mem_out1, -- mem_out1
            O => reg_result_out1
        );
        
-- Registro resultado 2
    reg2: registro
        port map (
            clk => clk,
            rst => rst,
            load => cont_en,
            ini => ini,
            I => mem_out2, -- mem_out2
            O => reg_result_out2
        );
        
-- Comparador resultado
    eq <= '1' when reg_result_out1 = reg_result_out2 else '0';

-- Contador senal tiempo
    
    p_10seg: process (clk, rst)
    begin
        if rst = '1' then
           cntr_seg <= (others => '0'); 
           tiempo <= '0';
        elsif rising_edge(clk) then
            if ini = '1' then
                cntr_seg <= (others => '0'); 
                tiempo <= '0';
            elsif reset_sec = '1' then
                cntr_seg <= (others => '0'); 
                tiempo <= '0';
            else
                if tiempo_en = '1' then
                    if cntr_seg = segs then
                        tiempo <= '1'; 
                    else 
                        cntr_seg <= cntr_seg + 1;
                        tiempo <= '0'; 
                    end if;
                end if;
            end if;   
        end if;
    end process; 
    
-- Generador de secuencias
    gs: Secuencias
        port map (
            clk => clk,
            rst => rst,
            ini => reset_sec,
            control_led => control_led,
            leds => leds_aux
        );

-- Le damos valor a las senales de status y leds
    status <= (eq, tiempo);
    leds <= leds_aux;
    o1 <= reg_result_out1;
    o2 <= reg_result_out2;
    
end dp;
        