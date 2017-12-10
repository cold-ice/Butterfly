library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY LATE_STATUS_CU IS
PORT(		CLOCK		 	: IN STD_LOGIC;
			RESET			: IN STD_LOGIC;
			START			: IN STD_LOGIC;
			INSTRUCTION	: OUT STD_LOGIC_VECTOR(21 downto 0)
);
END ENTITY;

ARCHITECTURE behavioural OF LATE_STATUS_CU IS

COMPONENT REG2
GENERIC	(SIZE			: INTEGER);
PORT(		CLOCK 		: IN STD_LOGIC;
			ENABLE		: IN STD_LOGIC;
			CLEAR			: IN STD_LOGIC;
			INPUT			: IN STD_LOGIC_VECTOR(SIZE downto 0);
			OUTPUT		: OUT STD_LOGIC_VECTOR(SIZE downto 0)
);
END COMPONENT;

COMPONENT REG2_INV
GENERIC	(SIZE			: INTEGER);
PORT(		CLOCK 		: IN STD_LOGIC;
			ENABLE		: IN STD_LOGIC;
			CLEAR			: IN STD_LOGIC;
			INPUT			: IN STD_LOGIC_VECTOR(SIZE downto 0);
			OUTPUT		: OUT STD_LOGIC_VECTOR(SIZE downto 0)
);
END COMPONENT;

COMPONENT uROM_EVEN
PORT(		INPUT			: IN STD_LOGIC_VECTOR(2 downto 0);
			OUTPUT		: OUT STD_LOGIC_VECTOR(26 downto 0)
);
END COMPONENT;

COMPONENT uROM_ODD
PORT(		INPUT			: IN STD_LOGIC_VECTOR(2 downto 0);
			OUTPUT		: OUT STD_LOGIC_VECTOR(26 downto 0)
);
END COMPONENT;

COMPONENT late_status_PLA
PORT(		CC				: IN STD_LOGIC;
			LSB_IN		: IN STD_LOGIC;
			STATUS		: IN STD_LOGIC;
			JUMP_VALID	: OUT STD_LOGIC;
			LSB_OUT		: OUT STD_LOGIC
);
END COMPONENT;

SIGNAL INSTRUCTION_EVEN 										: STD_LOGIC_VECTOR(26 downto 0):="100000000000000000000000000";
SIGNAL INSTRUCTION_ODD 											: STD_LOGIC_VECTOR(26 downto 0):="000100100100000000000000000";
SIGNAL NEW_INSTRUCTION, INSTRUCTION_BUFFER 				: STD_LOGIC_VECTOR(26 downto 0):=(others=>'0');
SIGNAL INSTRUCTION_ADDRESS 									: STD_LOGIC_VECTOR(3 downto 0):=(others=>'0');
SIGNAL LSB_uADDRESS, JUMP_VALIDATION, INSTRUCTION_SEL : STD_LOGIC:='0';
SIGNAL INSTRUCTION_ADDRESS_BUFFER 							: STD_LOGIC_VECTOR(3 downto 0):=(others=>'0');

BEGIN

INSTRUCTION_ADDRESS_BUFFER <= NEW_INSTRUCTION(25 downto 23) & LSB_uADDRESS;

INSTRUCTION <= NEW_INSTRUCTION(21 downto 0);

--Bypass MUX
WITH JUMP_VALIDATION SELECT INSTRUCTION_SEL <=		INSTRUCTION_ADDRESS(0) 	WHEN '0',
																	LSB_uADDRESS				WHEN '1',
																	INSTRUCTION_ADDRESS(0) 	WHEN others;

-- Jump MUX
WITH INSTRUCTION_SEL SELECT INSTRUCTION_BUFFER <=	INSTRUCTION_EVEN when '0',
																	INSTRUCTION_ODD when '1',
																	INSTRUCTION_EVEN when others;

uROMeven: uROM_even 		PORT MAP(INSTRUCTION_ADDRESS(3 downto 1), INSTRUCTION_EVEN);

uROModd: uROM_odd 		PORT MAP(INSTRUCTION_ADDRESS(3 downto 1), INSTRUCTION_ODD);
							
uInstReg: REG2 			GENERIC MAP(SIZE => 26)
								PORT MAP(CLOCK, '1', RESET, INSTRUCTION_BUFFER, NEW_INSTRUCTION);

uAddReg: REG2_INV 		GENERIC MAP(SIZE => 3)
								PORT MAP(CLOCK, '1', RESET, INSTRUCTION_ADDRESS_BUFFER, INSTRUCTION_ADDRESS);

ls_PLA: late_status_PLA PORT MAP(NEW_INSTRUCTION(26), NEW_INSTRUCTION(22), START, JUMP_VALIDATION, LSB_uADDRESS);

END behavioural;