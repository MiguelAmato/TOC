library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ASM is
    port(
        clk, rst: in std_logic;
        init: in std_logic;
        a_in, b_in: in signed(4 downto 0);
        display : out  STD_LOGIC_VECTOR (6 downto 0);
        done: out std_logic_vector(15 downto 0);
        display_enable : out  STD_LOGIC_VECTOR (3 downto 0)
    );
end ASM;

architecture asm of ASM is

    component DataPath is
    port (
        clk, rst: in std_logic;
        a_in, b_in: in std_logic_vector(7 downto 0); 
        signo_a, signo_b: in std_logic;
        control: in std_logic_vector(5 downto 0);
        status: out std_logic_vector(4 downto 0);
        acc: out std_logic_vector(7 downto 0);
        signo: out std_logic
        ); 
    end component DataPath;
    
    component ControlUnit is 
    port (
        clk, rst: in std_logic;
        init: in std_logic;
        done: out std_logic;
        status: in std_logic_vector(4 downto 0);
        control: out std_logic_vector(5 downto 0)
    );
    end component ControlUnit;
    
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
    
    component displays is
    port ( 
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
    
    signal boton_out: std_logic;
    signal done_aux: std_logic;
    signal control_i: std_logic_vector(5 downto 0);
    signal status_i: std_logic_vector(4 downto 0);
    signal acc_aux: std_logic_vector(7 downto 0);
    signal a_aux, b_aux: std_logic_vector(7 downto 0);
    signal boton_aux1, boton_aux2: std_logic;
    signal signo_a, signo_b: std_logic;
    signal signo: std_logic_vector(3 downto 0);
    signal signo_lsb: std_logic;
    
begin
    
    signo_a <= a_in(4);
    signo_b <= b_in(4);
    a_aux <= std_logic_vector("0000" & std_logic_vector(abs(a_in(3 downto 0))));
    b_aux <= std_logic_vector("0000" & std_logic_vector(abs(b_in(3 downto 0))));

    i_dp: DataPath port map (
        clk => clk,
        rst => rst,
        a_in => a_aux,
        b_in => b_aux,
        signo_a => signo_a,
        signo_b => signo_b,
        control => control_i,
        status => status_i,
        acc => acc_aux,
        signo => signo_lsb
    );
    
    signo <= ("000" & signo_lsb);
    
    i_cu: ControlUnit port map (
        rst => rst,
        clk => clk,
        init => boton_out,
        done => done_aux,
        status => status_i,
        control => control_i
    );
    
    i_deb: debouncer port map (
        rst => rst,
        clk => clk,
        x => init,
        xDeb => boton_aux1,
        xDebFallingEdge => boton_aux2,
        xDebRisingEdge => boton_out 
    );
    
    i_disp: displays port map (
        rst => rst,
        clk => clk,
        digito_0 => acc_aux(3 downto 0),
        digito_1 => acc_aux(7 downto 4),
        digito_2 => signo, -- Aqui va el signo 
        digito_3 => "0000",
        display => display,
        display_enable => display_enable
    );

   done <= (others => done_aux);
   
end asm;