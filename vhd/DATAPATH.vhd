library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DATAPATH is
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
end entity;

architecture behavioural of DATAPATH is

  component REG is
    generic (SIZE : integer);
    port(CLOCK  : in  std_logic;
         ENABLE : in  std_logic;
         CLEAR  : in  std_logic;
         INPUT  : in  signed(SIZE downto 0);
         OUTPUT : out signed(SIZE downto 0)
         );
  end component;

  component REGISTER_FILE is
    port(CLOCK     : in  std_logic;
         DATA_IN0  : in  signed(15 downto 0);
         DATA_IN1  : in  signed(15 downto 0);
         CS        : in  std_logic;
         WR2       : in  std_logic;
         WR1       : in  std_logic;
         WR0       : in  std_logic;
         RESET     : in  std_logic;
         SEL_BUS0  : in  std_logic;
         SEL_BUS1  : in  std_logic_vector(1 downto 0);
         DATA_OUT0 : out signed(15 downto 0);
         DATA_OUT1 : out signed(15 downto 0);
         DATA_OUT2 : out signed(15 downto 0)
         );
  end component;

  component MULTIPLIER is
    port(DATA_IN0 : in  signed(15 downto 0);
         DATA_IN1 : in  signed(15 downto 0);
         DATA_OUT : out signed(31 downto 0)
         );
  end component;

  component ADDER is
    port(DATA_IN0 : in  signed(30 downto 0);
         DATA_IN1 : in  signed(30 downto 0);
         C0       : in  std_logic;
         DATA_OUT : out signed(30 downto 0)
         );
  end component;

  component ROUNDER is
    port(DATA_IN  : in  signed(30 downto 0);
         DATA_OUT : out signed(15 downto 0)
         );
  end component;

  component SHIFTER_X2 is
    port(DATA_IN  : in  signed(15 downto 0);
         DATA_OUT : out signed(15 downto 0)
         );
  end component;

  signal BUS0, BUS1, BUS2, DATA_OUT1_BUFFER                                        : signed(15 downto 0)  := (others => '0');
  signal MULT_IN0, MULT_IN1, SHF_IN, SHF_OUT, ROUNDER_OUT                          : signed (15 downto 0) := (others => '0');
  signal SUM0_IN0, SUM0_IN1, SUM0_OUT, SUM1_IN0, SUM1_IN1, SUM1_OUT, R3_IN, R3_OUT : signed (30 downto 0) := (others => '0');  --
  signal MULT_OUT                                                                  : signed (31 downto 0) := (others => '0');
  signal R2_OUT, ROUNDER_IN                                                        : signed (30 downto 0) := (others => '0');  --

begin

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
  with MUX1_SEL(1) select SHF_IN <= BUS1 when '0',
                                    BUS2 when '1',
                                    BUS1 when others;

--MUX1
  with MUX1_SEL select SUM0_IN0 <= BUS2&"000000000000000" when "00",
                                   SHF_OUT&"000000000000000" when "01",
                                   BUS1&"000000000000000"    when "10",
                                   SHF_OUT&"000000000000000" when "11",
                                   BUS2&"000000000000000"    when others;

--MUX2
  with MUX2_SEL select SUM0_IN1 <= MULT_OUT(30 downto 0) when '0',  --
                                   R3_OUT                when '1',
                                   MULT_OUT(30 downto 0) when others;

--MUX3
  with MUX3_SEL select SUM1_IN0 <= R3_OUT when '0',  --
                                   R2_OUT when '1',
                                   R3_OUT when others;

--MUX 4
  with MUX4_SEL select SUM1_IN1 <= MULT_OUT(30 downto 0) when '0',
                                   BUS1&"000000000000000" when '1',
                                   MULT_OUT(30 downto 0)  when others;
--MUX 5
  with MUX5_SEL select ROUNDER_IN <= R2_OUT when '0',
                                     R3_OUT when '1',
                                     R2_OUT when others;

--MUX 6
  with MUX6_SEL select R3_IN <= MULT_OUT(30 downto 0) when '0',
                                SUM1_OUT              when '1',
                                MULT_OUT(30 downto 0) when others;

  RF : REGISTER_FILE port map (CLOCK, DATA_IN0, DATA_IN1, CHIP_SELECT, WR2, WR1, WR0, RESET, BUS0_SEL, BUS1_SEL, BUS0, BUS1, BUS2);

  R1 : REG generic map(SIZE => 15)      --
    port map (CLOCK, LD1, RESET, BUS1, MULT_IN1);

  R2 : REG generic map(SIZE => 30)      --
    port map(CLOCK, LD2, RESET, SUM0_OUT, R2_OUT);

  R3 : REG generic map(SIZE => 30)      --
    port map(CLOCK, LD3, RESET, R3_IN, R3_OUT);

  R4 : REG generic map(SIZE => 15)      --
    port map(CLOCK, LD4, RESET, ROUNDER_OUT, DATA_OUT1_BUFFER);

  mult : MULTIPLIER port map(BUS0, MULT_IN1, MULT_OUT);

  mult_x2 : SHIFTER_X2 port map (SHF_IN, SHF_OUT);

  add0 : ADDER port map(SUM0_IN0, SUM0_IN1, C0_0, SUM0_OUT);

  add1 : ADDER port map(SUM1_IN0, SUM1_IN1, C0_1, SUM1_OUT);

  round : ROUNDER port map(ROUNDER_IN, ROUNDER_OUT);

end behavioural;
