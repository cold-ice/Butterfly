library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REGISTER_FILE is
  port(CLOCK     : in  std_logic;
       DATA_IN0  : in  signed(15 downto 0) := (others => '0');
       DATA_IN1  : in  signed(15 downto 0) := (others => '0');
       CS        : in  std_logic;
       WR2       : in  std_logic;
       WR1       : in  std_logic;
       WR0       : in  std_logic;
       RESET     : in  std_logic;
       SEL_BUS0  : in  std_logic;
       SEL_BUS1  : in  std_logic_vector(1 downto 0);
       DATA_OUT0 : out signed(15 downto 0) := (others => '0');
       DATA_OUT1 : out signed(15 downto 0) := (others => '0');
       DATA_OUT2 : out signed(15 downto 0) := (others => '0')
       );
end entity;

architecture behavioural of REGISTER_FILE is

  component REG is
    generic (SIZE : integer);
    port(CLOCK  : in  std_logic;
         ENABLE : in  std_logic;
         CLEAR  : in  std_logic;
         INPUT  : in  signed(SIZE downto 0);
         OUTPUT : out signed(SIZE downto 0)
         );
  end component;

  signal Ar_OUT, Ai_OUT, Br_OUT, Bi_OUT, Wr_OUT, Wi_OUT, DATA_OUT0_BUFFER, DATA_OUT1_BUFFER, DATA_OUT2_BUFFER : signed(15 downto 0) := (others => '0');

begin

  DATA_OUT2_BUFFER <= Ai_OUT;

--MUX_BUS0
  with SEL_BUS0 select DATA_OUT0_BUFFER <= Br_OUT when '0',
                                           Bi_OUT when '1',
                                           Br_OUT when others;

--MUX_BUS1
  with SEL_BUS1 select DATA_OUT1_BUFFER <= Wr_OUT when "00",
                                           Wi_OUT          when "01",
                                           Ar_OUT          when "10",
                                           (others => '0') when "11",
                                           Wr_OUT          when others;

-- CS CHECK
  with CS select DATA_OUT0 <= (others => '0') when '0',
                              DATA_OUT0_BUFFER when '1',
                              (others => '0')  when others;

  with CS select DATA_OUT1 <= (others => '0') when '0',
                              DATA_OUT1_BUFFER when '1',
                              (others => '0')  when others;

  with CS select DATA_OUT2 <= (others => '0') when '0',
                              DATA_OUT2_BUFFER when '1',
                              (others => '0')  when others;

  Ar : REG generic map(SIZE => 15)
    port map (CLOCK, WR2, RESET, DATA_IN1, Ar_OUT);

  Ai : REG generic map(SIZE => 15)
    port map (CLOCK, WR2, RESET, DATA_IN0, Ai_OUT);

  Br : REG generic map(SIZE => 15)
    port map (CLOCK, WR0, RESET, DATA_IN0, Br_OUT);

  Bi : REG generic map(SIZE => 15)
    port map (CLOCK, WR1, RESET, DATA_IN0, Bi_OUT);

  Wr : REG generic map(SIZE => 15)
    port map (CLOCK, WR0, RESET, DATA_IN1, Wr_OUT);

  Wi : REG generic map(SIZE => 15)
    port map (CLOCK, WR1, RESET, DATA_IN1, Wi_OUT);

end behavioural;
