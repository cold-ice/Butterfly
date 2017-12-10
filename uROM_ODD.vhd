library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY uROM_ODD IS
PORT(		INPUT			: IN STD_LOGIC_VECTOR(2 downto 0);
			OUTPUT		: OUT STD_LOGIC_VECTOR(26 downto 0)
);
END ENTITY;

ARCHITECTURE behavioural OF uROM_ODD IS

BEGIN

-- Tutte le istruzioni non assegnate non eseguono comandi e puntano direttamente allo stato di IDLE, per limitare
-- i danni dati dalla selezione di un'istruzione non valida e per evitare che l'algoritmo rimanga bloccato.

										--RST CS WR2 WR1 WR0 SB0 SB11 SB10 LD1 LD2 LD3 LD4 M11 M10 M2 M3 M4 M5 M6 C01 C02 DONE
WITH INPUT SELECT OUTPUT <=	'0'&"0010"&"0100100000000000000000" when "000", -- stato 2, va a stato 3
										'0'&"0100"&"0110000110100000000000" when "001", -- stato 4, va a stato 5
										'0'&"0110"&"0100010010100000001010" when "010", -- stato 6, va a stato 7
										'0'&"0000"&"0000000000000000000000" when "011", -- NA, va a stato 1, NON USATO
										'0'&"1011"&"0100100001001110000100" when "100", -- stato 8C, va a stato 9C
										'0'&"1101"&"0101000010000000000000" when "101", -- stato 9C, va a stato 10C
										'0'&"0100"&"0110000110100000010000" when "110", -- stato 10C, va a stato 5
										'0'&"0000"&"0000000000000000000000" when "111", -- stato NA, va a stato 1 (IDLE)
										'0'&"0000"&"0000000000000000000000" when others;
									 --CC & NEXT & ISTRUZIONE

END behavioural;