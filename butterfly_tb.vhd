LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Butterfly_tb IS

--PORT();

END Butterfly_tb;


ARCHITECTURE behavioural OF Butterfly_tb IS

COMPONENT BUTTERFLY_TOP
PORT(		CLOCK		: IN STD_LOGIC;
		RESET		: IN STD_LOGIC;
		START 		: IN STD_LOGIC;
		DATA_IN0 	: IN SIGNED(15 downto 0);
		DATA_IN1 	: IN SIGNED(15 downto 0);
		DONE 		: OUT STD_LOGIC;
		DATA_OUT0 	: OUT SIGNED(15 downto 0);
		DATA_OUT1 	: OUT SIGNED(15 downto 0)			
);
END COMPONENT;

SIGNAL CLOCK, RESET, START	: STD_LOGIC;
SIGNAL DATA_IN0, DATA_IN1	: SIGNED(15 downto 0);

BEGIN

Butterfly: BUTTERFLY_TOP	PORT MAP(CLOCK, RESET, START, DATA_IN0, DATA_IN1);

CLK_50MHz: PROCESS
BEGIN
CLOCK<='0';
wait for 10 ns;
CLOCK<='1';
wait for 10 ns;
END PROCESS;

-- Test modalita' singola
--signals: PROCESS
--BEGIN
--DATA_IN0<=(others=>'0');
--DATA_IN1<=(others=>'0');
--START<='0';
--RESET<='1';
--wait for 20 ns;
--RESET<='0';
--wait for 40 ns;
--START<='1';
--wait for 20 ns;
--DATA_IN0<="1111111111110000"; --Br, -1/2048
--DATA_IN1<="0000100000001011"; --Wr, 2059/32768
--START<='0';
--wait for 20 ns;
--DATA_IN0<="0001000000000111"; --Bi, 4103/32768
--DATA_IN1<="1111111100000000"; --Wi, -1/128 
--START<='0';
--wait for 20 ns;
--DATA_IN0<="1110110000010000"; --Ai, -0.155762
--DATA_IN1<="1111000111111111"; --Ar, -3585/32768
--wait;
--END PROCESS;

-- Test modalita' continua
signals: PROCESS
BEGIN
DATA_IN0<=(others=>'0');
DATA_IN1<=(others=>'0');
START<='0';
RESET<='1';
wait for 20 ns;
RESET<='0';
wait for 40 ns;
--1
START<='1';
wait for 20 ns;
DATA_IN0<="0001010011111001"; --Br,
DATA_IN1<="1001101100110111"; --Wr,
START<='0';
wait for 20 ns;
DATA_IN0<="1110010001010111"; --Bi, 
DATA_IN1<="0110110101001010"; --Wi,
START<='0';
wait for 20 ns;
DATA_IN0<="1110110100000010"; --Ai, 
DATA_IN1<="0001111010011011"; --Ar, 
wait for 50 ns;
--2
START<='1';
wait for 20 ns;
START<='0';
wait for 5 ns;
DATA_IN0<="0001111111111111"; --Br, 
DATA_IN1<="0111111111111111"; --Wr, 
START<='0';
wait for 20 ns;
DATA_IN0<="0001111111111111"; --Bi, 
DATA_IN1<="0111111111111111"; --Wi,  
START<='0';
wait for 20 ns;
DATA_IN0<="0001111111111111"; --Ai, 
DATA_IN1<="0001111111111111"; --Ar,
wait for 55 ns;
--3
START<='1';
wait for 20 ns;
START<='0';
wait for 5 ns;
START<='0';
DATA_IN0<="1110000000000001"; --Br, 
DATA_IN1<="1000000000000000"; --Wr, 
wait for 20 ns;
DATA_IN0<="1110000000000001"; --Bi, 
DATA_IN1<="1000000000000000"; --Wi,  
START<='0';
wait for 20 ns;
DATA_IN0<="1110000000000001"; --Ai, 
DATA_IN1<="1110000000000001"; --Ar, 
wait;
END PROCESS;

END behavioural;
