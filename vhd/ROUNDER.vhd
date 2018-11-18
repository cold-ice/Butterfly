library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ROUNDER IS
PORT(	DATA_IN	: IN SIGNED(30 downto 0):=(others=>'0');
	DATA_OUT	: OUT SIGNED(15 downto 0):=(others=>'0')
);
END ENTITY;

ARCHITECTURE behavioural OF ROUNDER IS

SIGNAL DATA_BUFFER : SIGNED(15 downto 0);
SIGNAL ROUND_CHECK : STD_LOGIC;

BEGIN

-- Questo processo, sfruttato solo qualora il 15esimo bit sia pari ad uno, 
-- controlla se abbiamo superato la meta' del massimo rappresentabile con i 15 bit da troncare.
-- In parole povere, basta che venga trovato un '1' nei 14 bit rimanenti per asserire questa condizione.
is_more_than_half: PROCESS (DATA_IN(13 downto 0))
BEGIN
ROUND_CHECK<='0';
FOR i IN 0 to 13 LOOP
	IF (DATA_IN(i) = '1') THEN
        ROUND_CHECK<='1';
    END IF;
END LOOP;
END PROCESS;

round2nearesteven: PROCESS(DATA_IN, ROUND_CHECK)
BEGIN
IF(DATA_IN(30 downto 15)/="0111111111111111") THEN
	IF((DATA_IN(15)='0' AND DATA_IN(14)='1' AND ROUND_CHECK='1') OR (DATA_IN(15)='1' AND DATA_IN(14)='1')) THEN
		DATA_BUFFER <= DATA_IN(30 downto 15) + 1;
	ELSE
		DATA_BUFFER <= DATA_IN(30 downto 15);
	END IF;
END IF;
END PROCESS;

DATA_OUT <= DATA_BUFFER;

END behavioural;
