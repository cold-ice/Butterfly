library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY REGISTER_FILE IS
PORT(	CLOCK			: IN STD_LOGIC;
		DATA_IN0		: IN SIGNED(15 downto 0):=(others=>'0');
		DATA_IN1		: IN SIGNED(15 downto 0):=(others=>'0');
		CS				: IN STD_LOGIC;
		WR2			: IN STD_LOGIC;
		WR1			: IN STD_LOGIC;
		WR0			: IN STD_LOGIC;
		RESET			: IN STD_LOGIC;
		SEL_BUS0		: IN STD_LOGIC;
		SEL_BUS1		: IN STD_LOGIC_VECTOR(1 downto 0);
		DATA_OUT0	: OUT SIGNED(15 downto 0):=(others=>'0');
		DATA_OUT1	: OUT SIGNED(15 downto 0):=(others=>'0');
		DATA_OUT2	: OUT SIGNED(15 downto 0):=(others=>'0')
);
END ENTITY;

ARCHITECTURE behavioural OF REGISTER_FILE IS

COMPONENT REG IS
GENERIC (SIZE			: INTEGER);
PORT(		CLOCK		 	: IN STD_LOGIC;
			ENABLE		: IN STD_LOGIC;
			CLEAR			: IN STD_LOGIC;
			INPUT			: IN SIGNED(SIZE downto 0);
			OUTPUT		: OUT SIGNED(SIZE downto 0)
);
END COMPONENT;

SIGNAL Ar_OUT, Ai_OUT, Br_OUT, Bi_OUT, Wr_OUT, Wi_OUT, DATA_OUT0_BUFFER, DATA_OUT1_BUFFER, DATA_OUT2_BUFFER : SIGNED(15 downto 0):=(others=>'0');

BEGIN

DATA_OUT2_BUFFER <= Ai_OUT;

--MUX_BUS0
WITH SEL_BUS0 SELECT DATA_OUT0_BUFFER <= 	Br_OUT when '0',
														Bi_OUT when '1',
														Br_OUT when others;

--MUX_BUS1
WITH SEL_BUS1 SELECT DATA_OUT1_BUFFER <=	Wr_OUT 				when "00",
														Wi_OUT 				when "01",
														Ar_OUT 				when "10",
													  (others=>'0')		when "11",
														Wr_OUT 				when others;

-- CS CHECK
WITH CS SELECT DATA_OUT0 <=	(others=>'0') 		when '0',
										DATA_OUT0_BUFFER 	when '1',
										(others=>'0') 		when others;

WITH CS SELECT DATA_OUT1 <=	(others=>'0') 		when '0',
										DATA_OUT1_BUFFER 	when '1',
										(others=>'0') 		when others;
									  
WITH CS SELECT DATA_OUT2 <= 	(others=>'0') 		when '0',
										DATA_OUT2_BUFFER 	when '1',
										(others=>'0') 		when others;

Ar: REG 	GENERIC MAP(SIZE=>15)
			PORT MAP (CLOCK, WR2, RESET, DATA_IN1, Ar_OUT);

Ai: REG 	GENERIC MAP(SIZE=>15)
			PORT MAP (CLOCK, WR2, RESET, DATA_IN0, Ai_OUT);

Br: REG 	GENERIC MAP(SIZE=>15)
			PORT MAP (CLOCK, WR0, RESET, DATA_IN0, Br_OUT);

Bi: REG 	GENERIC MAP(SIZE=>15)
			PORT MAP (CLOCK, WR1, RESET, DATA_IN0, Bi_OUT);

Wr: REG 	GENERIC MAP(SIZE=>15)
			PORT MAP (CLOCK, WR0, RESET, DATA_IN1, Wr_OUT);

Wi: REG 	GENERIC MAP(SIZE=>15)
			PORT MAP (CLOCK, WR1, RESET, DATA_IN1, Wi_OUT);
						
END behavioural;