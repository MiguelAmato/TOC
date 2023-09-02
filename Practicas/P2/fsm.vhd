library IEEE;
use IEEE.std_logic_1164.all;

entity fsm is 
    port (  clk, rst, boton: in std_logic;
            eq: in std_logic;
            load: out std_logic;
            bloqueado: out std_logic;
            display: out std_logic_vector(3 downto 0)
          );
end fsm;

architecture fsmArch of fsm is

type estados is (ini, tres, dos, uno, fin);

signal estado, sig_estado: estados;

attribute fsm_encoding : string;
   attribute fsm_encoding of estado : signal is "sequential";
   attribute fsm_encoding of sig_estado : signal is "sequential";
   
begin
    
    process (clk, rst) 
    begin
        if rst = '0' then
            estado <= ini;
        elsif rising_edge(clk) then
            estado <= sig_estado;
        end if;
    end process;
    
    process (estado, eq, boton)
    begin
        case estado is
        when ini =>
            if boton = '1' then
                sig_estado <= tres;
            else
                sig_estado <= ini;
            end if;
        when tres =>
            if boton = '1' then
                if eq = '1' then
                    sig_estado <= ini;
                else 
                    sig_estado <= dos;
                end if;
            else
                sig_estado <= tres;
            end if;
        when dos =>
            if boton = '1' then
                if eq = '1' then
                    sig_estado <= ini;
                else 
                    sig_estado <= uno;
                end if;
            else
                sig_estado <= dos;
            end if;
        when uno =>
            if boton = '1' then
                if eq = '1' then
                    sig_estado <= ini;
                else 
                    sig_estado <= fin;
                end if;
            else
                sig_estado <= uno;
            end if;
        when fin =>
            if boton = '1' then
                sig_estado <= fin;
            else
                sig_estado <= fin;
            end if;
        end case;
    end process;
    
    process (estado)
    begin
        case estado is
        when ini =>
            load <= '1';
            bloqueado <= '0';
            display <= "0000";
        when tres =>
            load <= '0';
            bloqueado <= '1';
            display <= "0011";
        when dos =>
            load <= '0';
            bloqueado <= '1';
            display <= "0010";
        when uno =>
            load <= '0';
            bloqueado <= '1';
            display <= "0001";
        when fin =>
            load <= '0';
            bloqueado <= '1';
            display <= "0000";
        end case;
    end process; 
    
end fsmArch; 