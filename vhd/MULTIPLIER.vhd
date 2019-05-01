library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MULTIPLIER is
  port(DATA_IN0 : in  signed(15 downto 0) := (others => '0');
       DATA_IN1 : in  signed(15 downto 0) := (others => '0');
       DATA_OUT : out signed(31 downto 0) := (others => '0')
       );
end entity;

architecture behavioural of MULTIPLIER is

  signal MULT : signed(31 downto 0) := (others => '0');

begin

  MULT <= TO_SIGNED(to_integer(DATA_IN0)*to_integer(DATA_IN1), 32);

  DATA_OUT <= MULT;

end behavioural;
