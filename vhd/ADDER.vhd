library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADDER is
  port(DATA_IN0 : in  signed(30 downto 0) := (others => '0');
       DATA_IN1 : in  signed(30 downto 0) := (others => '0');
       C0       : in  std_logic           := '0';
       DATA_OUT : out signed(30 downto 0) := (others => '0')
       );
end entity;

architecture behavioural of ADDER is

begin

  with C0 select DATA_OUT <= DATA_IN0 + DATA_IN1 when '0',
                             DATA_IN0 - DATA_IN1 when '1',
                             DATA_IN0 + DATA_IN1 when others;

end behavioural;
