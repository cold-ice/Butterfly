LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY CU_tb IS

--PORT();

END CU_tb;


ARCHITECTURE behavioural OF CU_tb IS

COMPONENT LATE_STATUS_CU
PORT(		CLOCK		 	: IN STD_LOGIC;
		RESET			: IN STD_LOGIC;
		START			: IN STD_LOGIC;
		INSTRUCTION		: OUT STD_LOGIC_VECTOR(22 downto 0)
);END COMPONENT;

SIGNAL CLOCK, RESET, START	: STD_LOGIC;

BEGIN

CU: LATE_STATUS_CU	PORT MAP(CLOCK, RESET, START);

CLK_50MHz: PROCESS
BEGIN
CLOCK<='0';
wait for 10 ns;
CLOCK<='1';
wait for 10 ns;
END PROCESS;

signals: PROCESS
BEGIN
START<='0';
RESET<='1';
wait for 40 ns;
RESET<='0';
wait for 20 ns;
START<='1';
wait for 20 ns;
START<='0';
wait;
END PROCESS;

END behavioural;