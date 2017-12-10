library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY LATE_STATUS_PLA IS
PORT(		CC				: IN STD_LOGIC;
			LSB_IN		: IN STD_LOGIC;
			STATUS		: IN STD_LOGIC;
			JUMP_VALID	: OUT STD_LOGIC;
			LSB_OUT		: OUT STD_LOGIC:='0'
);
END ENTITY;

ARCHITECTURE behavioural OF LATE_STATUS_PLA IS

SIGNAL CC1, LSB_OUT_BUFFER : STD_LOGIC:='0';

BEGIN

-- Componente descritto in stile comportamentale per semplificarne la lettura.

PROCESS(STATUS, CC, LSB_IN)
BEGIN
IF(CC='1' AND STATUS ='1') THEN
	LSB_OUT_BUFFER <= NOT LSB_IN;
	JUMP_VALID<='1';
ELSE
	LSB_OUT_BUFFER <= LSB_IN;
	JUMP_VALID<='0';
END IF;
END PROCESS;

LSB_OUT <= LSB_OUT_BUFFER;
									
END behavioural;