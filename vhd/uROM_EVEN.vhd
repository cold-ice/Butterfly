library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uROM_EVEN is
  port(INPUT  : in  std_logic_vector(2 downto 0);
       OUTPUT : out std_logic_vector(26 downto 0)
       );
end entity;

architecture behavioural of uROM_EVEN is

begin

-- Tutte le istruzioni non assegnate non eseguono comandi e puntano direttamente allo stato di IDLE, per limitare
-- i danni dati dalla selezione di un'istruzione non valida e per evitare che l'algoritmo rimanga bloccato.

                                                                               --RST CS WR2 WR1 WR0 SB0 SB11 SB10 LD1 LD2 LD3 LD4 M11 M10 M2 M3 M4 M5 M6 C01 C02 DONE
  with INPUT select OUTPUT <= '1'&"0000"&"1000000000000000000000" when "000",  -- stato 1 (IDLE), va a stato 1 (IDLE) O 2
                              '0'&"0011"&"0101000010000000000000" when "001",  -- stato 3, va a stato 4
                              '0'&"0101"&"0100001001100000101000" when "010",  -- stato 5, va a stato 6
                              '1'&"1000"&"0100011001110111011101" when "011",  -- stato 7, va a stato 8 O 8C
                              '0'&"1010"&"0100000001001110000100" when "100",  -- stato 8, va a stato 9
                              '0'&"1100"&"0000000000000000000000" when "101",  -- stato 9, va a stato 10
                              '0'&"0000"&"0000000000000000010000" when "110",  -- stato 10, va a stato 1 (IDLE)
                              '0'&"0000"&"0000000000000000000000" when "111",  -- stato NA, va a stato 1 (IDLE)
                              '0'&"0000"&"0000000000000000000000" when others;
                                        --CC & NEXT & ISTRUZIONE

end behavioural;
