library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY SHIFTER_X2 IS
PORT(	DATA_IN		: IN SIGNED(15 downto 0):=(others=>'0');
	DATA_OUT	: OUT SIGNED(15 downto 0):=(others=>'0')
);
END ENTITY;

ARCHITECTURE behavioural OF SHIFTER_X2 IS

BEGIN

DATA_OUT <= DATA_IN(15) & DATA_IN(13 downto 0) & '0';

END behavioural;