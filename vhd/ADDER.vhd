library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ADDER IS
PORT(	DATA_IN0	: IN SIGNED(30 downto 0):=(others=>'0');
		DATA_IN1	: IN SIGNED(30 downto 0):=(others=>'0');
		C0			: IN STD_LOGIC:='0';
		DATA_OUT	: OUT SIGNED(30 downto 0):=(others=>'0')
);
END ENTITY;

ARCHITECTURE behavioural OF ADDER IS

BEGIN

WITH C0 SELECT DATA_OUT <=	DATA_IN0 + DATA_IN1 when '0',
									DATA_IN0 - DATA_IN1 when '1',
									DATA_IN0 + DATA_IN1 when others;

END behavioural;