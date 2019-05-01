library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SHIFTER_X2 is
  port(DATA_IN  : in  signed(15 downto 0) := (others => '0');
       DATA_OUT : out signed(15 downto 0) := (others => '0')
       );
end entity;

architecture behavioural of SHIFTER_X2 is

begin

  DATA_OUT <= DATA_IN(15) & DATA_IN(13 downto 0) & '0';

end behavioural;
