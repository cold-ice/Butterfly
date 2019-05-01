library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REG2 is
  generic (SIZE : integer);
  port(CLOCK  : in  std_logic;
       ENABLE : in  std_logic;
       CLEAR  : in  std_logic;
       INPUT  : in  std_logic_vector(SIZE downto 0);
       OUTPUT : out std_logic_vector(SIZE downto 0)
       );
end entity;

architecture behavioural of REG2 is

begin

  FF : process(CLOCK, CLEAR)
  begin
    if(CLEAR = '1') then
      OUTPUT <= (others => '0');
    elsif(RISING_EDGE(CLOCK)) then
      if(ENABLE = '1') then
        OUTPUT <= INPUT;
      end if;
    end if;
  end process;

end behavioural;
