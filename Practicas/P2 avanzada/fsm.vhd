library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is 
    generic (k : integer := 4;            -- Module value
             n : integer := 2);
    port (  clk, rst, boton: in std_logic;
            eq: in std_logic;
            load: out std_logic;
            bloqueado: out std_logic;
            display: out std_logic_vector(3 downto 0)
          );
end fsm;

architecture fsmArch of fsm is

type estados is (ini, intento, precesar, bloqueo);

component cntr is
-- k < 2**n
  port (rst  : in  std_logic;           -- Asynch reset
        clk  : in  std_logic;           -- Input clock
        cntr : out std_logic_vector(n-1 downto 0));
end component;

signal estado, sig_estado: estados;
signal cntr_i: unsigned(n-1 downto 0);
signal cntr_l: std_logic_vector(n-1 downto 0);

attribute fsm_encoding : string;
   attribute fsm_encoding of estado : signal is "sequential";
   attribute fsm_encoding of sig_estado : signal is "sequential";
   
begin

cmp_cntr: cntr port map(
    rst => rst,
    clk => clk,
    cntr => cntr_l
);
    
    cntr_l <= std_logic_vector(cntr_i);
    
    process (clk, rst) 
    begin
        if rst = '0' then
            estado <= ini;
        elsif rising_edge(clk) then
            estado <= sig_estado;
        end if;
    end process;
    
    process (estado, boton, eq, cntr_i)
    begin 
        case estado is
            when ini =>
                if boton = '1' then
                    sig_estado <= intento;
                else 
                    sig_estado <= ini;
                end if;
            when intento =>
                if boton = '1' then
                    load <= '0'; 
                    if eq = '1' then
                        sig_estado <= ini;
                    else 
                        if cntr_i < k - 1 then
                            cntr_i <= cntr_i + 1;
                        else
                            sig_estado <= bloqueo;
                        end if;
                    end if;
                 else 
                    sig_estado <= intento;
                 end if;
            when bloqueo =>
                if boton = '1' then
                    sig_estado <= bloqueo;
                else 
                    sig_estado <= bloqueo;
                end if;
        end case;
    end process;    

    process (estado)
    begin
        case estado is
            when ini =>
                load <= '1'; 
                bloqueado <= '0'; 
            when intento =>
                load <= '0';
                bloqueado <= '1';
            when bloqueo =>
                bloqueado <= '1';    
        end case;
    end process;
    
    --NOTAS GENERALES: faltan muchas cosas, display en el process de salida,
    --                 poner el cntr_i en todos para la casuistica y ya. 
    
end fsmArch; 