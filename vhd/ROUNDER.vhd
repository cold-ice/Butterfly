library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROUNDER is
  port(DATA_IN  : in  signed(30 downto 0) := (others => '0');
       DATA_OUT : out signed(15 downto 0) := (others => '0')
       );
end entity;

architecture behavioural of ROUNDER is

  signal DATA_BUFFER : signed(15 downto 0);
  signal ROUND_CHECK : std_logic;

begin

-- Questo processo, sfruttato solo qualora il 15esimo bit sia pari ad uno,
-- controlla se abbiamo superato la meta' del massimo rappresentabile con i 15 bit da troncare.
-- In parole povere, basta che venga trovato un '1' nei 14 bit rimanenti per asserire questa condizione.
  is_more_than_half : process (DATA_IN(13 downto 0))
  begin
    ROUND_CHECK <= '0';
    for i in 0 to 13 loop
      if (DATA_IN(i) = '1') then
        ROUND_CHECK <= '1';
      end if;
    end loop;
  end process;

  round2nearesteven : process(DATA_IN, ROUND_CHECK)
  begin
    if(DATA_IN(30 downto 15) /= "0111111111111111") then
      if((DATA_IN(15) = '0' and DATA_IN(14) = '1' and ROUND_CHECK = '1') or (DATA_IN(15) = '1' and DATA_IN(14) = '1')) then
        DATA_BUFFER <= DATA_IN(30 downto 15) + 1;
      else
        DATA_BUFFER <= DATA_IN(30 downto 15);
      end if;
    end if;
  end process;

  DATA_OUT <= DATA_BUFFER;

end behavioural;
