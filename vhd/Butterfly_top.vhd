library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BUTTERFLY_TOP is
  port(CLOCK     : in  std_logic;
       RESET     : in  std_logic;
       START     : in  std_logic;
       DATA_IN0  : in  signed(15 downto 0);
       DATA_IN1  : in  signed(15 downto 0);
       DONE      : out std_logic;
       DATA_OUT0 : out signed(15 downto 0);
       DATA_OUT1 : out signed(15 downto 0)
       );
end entity;

architecture behavioural of BUTTERFLY_TOP is

  component LATE_STATUS_CU
    port(CLOCK       : in  std_logic;
         RESET       : in  std_logic;
         START       : in  std_logic;
         INSTRUCTION : out std_logic_vector(21 downto 0)
         );
  end component;

  component DATAPATH
    port(CLOCK       : in  std_logic;
         DATA_IN0    : in  signed(15 downto 0);
         DATA_IN1    : in  signed(15 downto 0);
         RESET       : in  std_logic;
         CHIP_SELECT : in  std_logic;
         WR2         : in  std_logic;
         WR1         : in  std_logic;
         WR0         : in  std_logic;
         BUS0_SEL    : in  std_logic;
         BUS1_SEL    : in  std_logic_vector(1 downto 0);
         LD1         : in  std_logic;
         LD2         : in  std_logic;
         LD3         : in  std_logic;
         LD4         : in  std_logic;
         MUX1_SEL    : in  std_logic_vector(1 downto 0);
         MUX2_SEL    : in  std_logic;
         MUX3_SEL    : in  std_logic;
         MUX4_SEL    : in  std_logic;
         MUX5_SEL    : in  std_logic;
         MUX6_SEL    : in  std_logic;
         C0_0        : in  std_logic;
         C0_1        : in  std_logic;
         DATA_OUT0   : out signed(15 downto 0);
         DATA_OUT1   : out signed(15 downto 0)
         );
  end component;

  signal INSTRUCTION                      : std_logic_vector(21 downto 0);
  signal BUS1_SEL_BUFFER, MUX1_SEL_BUFFER : std_logic_vector(1 downto 0);

begin

  LS_CU : LATE_STATUS_CU port map(CLOCK, RESET, START, INSTRUCTION);

-- Concatenazioni fatte su buffer anziche' in fase di port map per non avere problemi con il compilatore di Modelsim
  BUS1_SEL_BUFFER <= INSTRUCTION(15)&INSTRUCTION(14);
  MUX1_SEL_BUFFER <= INSTRUCTION(9)&INSTRUCTION(8);

  DP : DATAPATH port map(CLOCK, DATA_IN0, DATA_IN1, INSTRUCTION(21), INSTRUCTION(20), INSTRUCTION(19), INSTRUCTION(18), INSTRUCTION(17), INSTRUCTION(16), BUS1_SEL_BUFFER, INSTRUCTION(13), INSTRUCTION(12), INSTRUCTION(11), INSTRUCTION(10), MUX1_SEL_BUFFER, INSTRUCTION(7), INSTRUCTION(6), INSTRUCTION(5), INSTRUCTION(4), INSTRUCTION(3), INSTRUCTION(2), INSTRUCTION(1), DATA_OUT0, DATA_OUT1);

  DONE <= INSTRUCTION(0);

end behavioural;
