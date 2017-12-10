library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY DATAPATH IS
PORT(		CLOCK		 	: IN STD_LOGIC;
			DATA_IN0		: IN SIGNED(15 downto 0);
			DATA_IN1		: IN SIGNED(15 downto 0);
			RESET			: IN STD_LOGIC;
			CHIP_SELECT	: IN STD_LOGIC;
			WR2			: IN STD_LOGIC;
			WR1			: IN STD_LOGIC;
			WR0			: IN STD_LOGIC;
			BUS0_SEL		: IN STD_LOGIC;
			BUS1_SEL		: IN STD_LOGIC_VECTOR(1 downto 0);
			LD1			: IN STD_LOGIC;
			LD2			: IN STD_LOGIC;
			LD3			: IN STD_LOGIC;
			LD4			: IN STD_LOGIC;
			MUX1_SEL		: IN STD_LOGIC_VECTOR(1 downto 0);
			MUX2_SEL		: IN STD_LOGIC;
			MUX3_SEL		: IN STD_LOGIC;
			MUX4_SEL		: IN STD_LOGIC;
			MUX5_SEL		: IN STD_LOGIC;
			MUX6_SEL		: IN STD_LOGIC;
			C0_0			: IN STD_LOGIC;
			C0_1			: IN STD_LOGIC;
			DATA_OUT0 	: OUT SIGNED(15 downto 0);
			DATA_OUT1 	: OUT SIGNED(15 downto 0)
);
END ENTITY;

ARCHITECTURE behavioural OF DATAPATH IS

COMPONENT REG IS
GENERIC (SIZE			: INTEGER);
PORT(		CLOCK		 	: IN STD_LOGIC;
			ENABLE		: IN STD_LOGIC;
			CLEAR			: IN STD_LOGIC;
			INPUT			: IN SIGNED(SIZE downto 0);
			OUTPUT		: OUT SIGNED(SIZE downto 0)
);
END COMPONENT;

COMPONENT REGISTER_FILE IS
PORT(	CLOCK			: IN STD_LOGIC;
		DATA_IN0		: IN SIGNED(15 downto 0);
		DATA_IN1		: IN SIGNED(15 downto 0);
		CS				: IN STD_LOGIC;
		WR2			: IN STD_LOGIC;
		WR1			: IN STD_LOGIC;
		WR0			: IN STD_LOGIC;
		RESET			: IN STD_LOGIC;
		SEL_BUS0		: IN STD_LOGIC;
		SEL_BUS1		: IN STD_LOGIC_VECTOR(1 downto 0);
		DATA_OUT0	: OUT SIGNED(15 downto 0);
		DATA_OUT1	: OUT SIGNED(15 downto 0);
		DATA_OUT2	: OUT SIGNED(15 downto 0)
);
END COMPONENT;

COMPONENT MULTIPLIER IS
PORT(	DATA_IN0	: IN SIGNED(15 downto 0);
		DATA_IN1	: IN SIGNED(15 downto 0);
		DATA_OUT	: OUT SIGNED(31 downto 0)
);
END COMPONENT;

COMPONENT ADDER IS
PORT(	DATA_IN0	: IN SIGNED(30 downto 0);
		DATA_IN1	: IN SIGNED(30 downto 0);
		C0			: IN STD_LOGIC;
		DATA_OUT	: OUT SIGNED(30 downto 0)
);
END COMPONENT;

COMPONENT ROUNDER IS
PORT(	DATA_IN	: IN SIGNED(30 downto 0);
		DATA_OUT	: OUT SIGNED(15 downto 0)
);
END COMPONENT;

COMPONENT SHIFTER_X2 IS
PORT(	DATA_IN	: IN SIGNED(15 downto 0);
		DATA_OUT	: OUT SIGNED(15 downto 0)
);
END COMPONENT;

SIGNAL BUS0, BUS1, BUS2, DATA_OUT1_BUFFER 					: SIGNED(15 downto 0):=(others=>'0');
SIGNAL MULT_IN0, MULT_IN1, SHF_IN, SHF_OUT, ROUNDER_OUT 	: SIGNED (15 downto 0):=(others=>'0');
SIGNAL SUM0_IN0, SUM0_IN1, SUM0_OUT, SUM1_IN0, SUM1_IN1, SUM1_OUT, R3_IN, R3_OUT : SIGNED (30 downto 0):=(others=>'0');--
SIGNAL MULT_OUT 				: SIGNED (31 downto 0):=(others=>'0');
SIGNAL R2_OUT, ROUNDER_IN 	: SIGNED (30 downto 0):=(others=>'0');--

BEGIN

DATA_OUT0 <= ROUNDER_OUT;
DATA_OUT1 <= DATA_OUT1_BUFFER;

-- NOTA IMPORTANTE:
-- I componenti MUX sono stati realizzati NON utilizzando dei component ma dei WITH SELECT statement per tre ragioni:
-- 1) Semplicita' intrinseca del realizzare il componente in questo modo, nonche' leggerissimo appesantimento
-- del codice dal punto di vista visivo;
-- 2) Immediatezza nell'interpreatare le righe di codice relative; 
-- 3) Evitare di realizzare segnali di buffer aggiuntivi per collegare componenti a segnali concatenati (difatti,
-- la nostra versione di ModelSim NON accetta segnali concatenati come input o come output);

-- SHF_MUX
-- Componente utilizzato per scegliere l'ingresso dello shifter. Notare che il comando di selezione e'
-- il bit piu' significativo del comando di selezione del MUX1. In questo modo abbiamo evitato di aggiungere
-- un'altra istruzione per gestire questo MUX.
WITH MUX1_SEL(1) SELECT SHF_IN <=	BUS1 when '0',
												BUS2 when '1',
												BUS1 when others;

--MUX1
WITH MUX1_SEL SELECT SUM0_IN0	 <=	BUS2&"000000000000000" 		when "00",
												SHF_OUT&"000000000000000" 	when "01",
												BUS1&"000000000000000" 		when "10",
												SHF_OUT&"000000000000000"	when "11",
												BUS2&"000000000000000" 		when others;
												
--MUX2
WITH MUX2_SEL SELECT SUM0_IN1	 <=	MULT_OUT(30 downto 0) 	when '0',--
												R3_OUT 						when '1',
												MULT_OUT(30 downto 0) 	when others;
												
--MUX3
WITH MUX3_SEL SELECT SUM1_IN0	 <=	R3_OUT when '0',--
												R2_OUT when '1',
												R3_OUT when others;
												
--MUX 4
WITH MUX4_SEL SELECT SUM1_IN1 <= 	MULT_OUT(30 downto 0) 	when '0',
												BUS1&"000000000000000" 	when '1',
												MULT_OUT(30 downto 0) 	when others;
--MUX 5
WITH MUX5_SEL SELECT ROUNDER_IN <=	R2_OUT when '0',
												R3_OUT when '1',
												R2_OUT when others;												
												
--MUX 6
WITH MUX6_SEL SELECT R3_IN <= 		MULT_OUT(30 downto 0) 	when '0',
												SUM1_OUT 					when '1',
												MULT_OUT(30 downto 0) 	when others;

RF: REGISTER_FILE PORT MAP (CLOCK, DATA_IN0, DATA_IN1, CHIP_SELECT, WR2, WR1, WR0, RESET, BUS0_SEL, BUS1_SEL, BUS0, BUS1, BUS2);

R1: REG 	GENERIC MAP(SIZE=>15)--
			PORT MAP (CLOCK, LD1, RESET, BUS1, MULT_IN1);
			
R2: REG	GENERIC MAP(SIZE=>30)--
			PORT MAP(CLOCK, LD2, RESET, SUM0_OUT, R2_OUT);
			
R3: REG	GENERIC MAP(SIZE=>30)--
			PORT MAP(CLOCK, LD3, RESET, R3_IN, R3_OUT);

R4: REG	GENERIC MAP(SIZE=>15)--
			PORT MAP(CLOCK, LD4, RESET, ROUNDER_OUT, DATA_OUT1_BUFFER);
			
mult:	MULTIPLIER PORT MAP(BUS0, MULT_IN1, MULT_OUT);

mult_x2: SHIFTER_X2 PORT MAP (SHF_IN, SHF_OUT);

add0: ADDER PORT MAP(SUM0_IN0, SUM0_IN1, C0_0, SUM0_OUT);

add1: ADDER PORT MAP(SUM1_IN0, SUM1_IN1, C0_1, SUM1_OUT);

round: ROUNDER PORT MAP(ROUNDER_IN, ROUNDER_OUT);

END behavioural;