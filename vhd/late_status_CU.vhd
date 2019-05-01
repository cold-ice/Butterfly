library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LATE_STATUS_CU is
  port(CLOCK       : in  std_logic;
       RESET       : in  std_logic;
       START       : in  std_logic;
       INSTRUCTION : out std_logic_vector(21 downto 0)
       );
end entity;

architecture behavioural of LATE_STATUS_CU is

  component REG2
    generic (SIZE : integer);
    port(CLOCK  : in  std_logic;
         ENABLE : in  std_logic;
         CLEAR  : in  std_logic;
         INPUT  : in  std_logic_vector(SIZE downto 0);
         OUTPUT : out std_logic_vector(SIZE downto 0)
         );
  end component;

  component REG2_INV
    generic (SIZE : integer);
    port(CLOCK  : in  std_logic;
         ENABLE : in  std_logic;
         CLEAR  : in  std_logic;
         INPUT  : in  std_logic_vector(SIZE downto 0);
         OUTPUT : out std_logic_vector(SIZE downto 0)
         );
  end component;

  component uROM_EVEN
    port(INPUT  : in  std_logic_vector(2 downto 0);
         OUTPUT : out std_logic_vector(26 downto 0)
         );
  end component;

  component uROM_ODD
    port(INPUT  : in  std_logic_vector(2 downto 0);
         OUTPUT : out std_logic_vector(26 downto 0)
         );
  end component;

  component late_status_PLA
    port(CC         : in  std_logic;
         LSB_IN     : in  std_logic;
         STATUS     : in  std_logic;
         JUMP_VALID : out std_logic;
         LSB_OUT    : out std_logic
         );
  end component;

  signal INSTRUCTION_EVEN                               : std_logic_vector(26 downto 0) := "100000000000000000000000000";
  signal INSTRUCTION_ODD                                : std_logic_vector(26 downto 0) := "000100100100000000000000000";
  signal NEW_INSTRUCTION, INSTRUCTION_BUFFER            : std_logic_vector(26 downto 0) := (others => '0');
  signal INSTRUCTION_ADDRESS                            : std_logic_vector(3 downto 0)  := (others => '0');
  signal LSB_uADDRESS, JUMP_VALIDATION, INSTRUCTION_SEL : std_logic                     := '0';
  signal INSTRUCTION_ADDRESS_BUFFER                     : std_logic_vector(3 downto 0)  := (others => '0');

begin

  INSTRUCTION_ADDRESS_BUFFER <= NEW_INSTRUCTION(25 downto 23) & LSB_uADDRESS;

  INSTRUCTION <= NEW_INSTRUCTION(21 downto 0);

--Bypass MUX
  with JUMP_VALIDATION select INSTRUCTION_SEL <= INSTRUCTION_ADDRESS(0) when '0',
                                                 LSB_uADDRESS           when '1',
                                                 INSTRUCTION_ADDRESS(0) when others;

-- Jump MUX
  with INSTRUCTION_SEL select INSTRUCTION_BUFFER <= INSTRUCTION_EVEN when '0',
                                                    INSTRUCTION_ODD  when '1',
                                                    INSTRUCTION_EVEN when others;

  uROMeven : uROM_even port map(INSTRUCTION_ADDRESS(3 downto 1), INSTRUCTION_EVEN);

  uROModd : uROM_odd port map(INSTRUCTION_ADDRESS(3 downto 1), INSTRUCTION_ODD);

  uInstReg : REG2 generic map(SIZE => 26)
    port map(CLOCK, '1', RESET, INSTRUCTION_BUFFER, NEW_INSTRUCTION);

  uAddReg : REG2_INV generic map(SIZE => 3)
    port map(CLOCK, '1', RESET, INSTRUCTION_ADDRESS_BUFFER, INSTRUCTION_ADDRESS);

  ls_PLA : late_status_PLA port map(NEW_INSTRUCTION(26), NEW_INSTRUCTION(22), START, JUMP_VALIDATION, LSB_uADDRESS);

end behavioural;
