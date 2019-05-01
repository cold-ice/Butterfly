library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LATE_STATUS_PLA is
  port(CC         : in  std_logic;
       LSB_IN     : in  std_logic;
       STATUS     : in  std_logic;
       JUMP_VALID : out std_logic;
       LSB_OUT    : out std_logic := '0'
       );
end entity;

architecture behavioural of LATE_STATUS_PLA is

  signal CC1, LSB_OUT_BUFFER : std_logic := '0';

begin

-- Componente descritto in stile comportamentale per semplificarne la lettura.

  process(STATUS, CC, LSB_IN)
  begin
    if(CC = '1' and STATUS = '1') then
      LSB_OUT_BUFFER <= not LSB_IN;
      JUMP_VALID     <= '1';
    else
      LSB_OUT_BUFFER <= LSB_IN;
      JUMP_VALID     <= '0';
    end if;
  end process;

  LSB_OUT <= LSB_OUT_BUFFER;

end behavioural;
