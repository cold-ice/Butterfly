library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROUNDER_tb is

--PORT();

end ROUNDER_tb;


architecture behavioural of ROUNDER_tb is

  component ROUNDER
    port(DATA_IN  : in  signed(30 downto 0) := (others => '0');
         DATA_OUT : out signed(15 downto 0) := (others => '0')
         );
  end component;

  signal DATA_IN : signed(30 downto 0);

begin

  ROUND : ROUNDER port map(DATA_IN);

  signals : process
  begin
    DATA_IN <= "0000000000000000"&"100000000000000";  --NO
    wait for 40 ns;
    DATA_IN <= "0000000000000000"&"100000000000001";  --YES
    wait for 40 ns;
    DATA_IN <= "0000000000000001"&"100000000000000";  --YES
    wait for 40 ns;
    DATA_IN <= "1000000000000010"&"100000000000000";  --NO
    wait for 40 ns;
    DATA_IN <= "1000000000000010"&"100000000000001";  --YES
    wait for 40 ns;
    DATA_IN <= "1000000000000011"&"100000000000000";  --YES
    wait for 40 ns;
    wait;
  end process;

end behavioural;
