library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY MULTIPLIER IS
PORT(	DATA_IN0	: IN SIGNED(15 downto 0):=(others=>'0');
		DATA_IN1	: IN SIGNED(15 downto 0):=(others=>'0');
		DATA_OUT	: OUT SIGNED(31 downto 0):=(others=>'0')
);
END ENTITY;

ARCHITECTURE behavioural OF MULTIPLIER IS

SIGNAL MULT : SIGNED(31 downto 0):=(others=>'0');

BEGIN

MULT <= TO_SIGNED(to_integer(DATA_IN0)*to_integer(DATA_IN1),32);

DATA_OUT <= MULT;

END behavioural;