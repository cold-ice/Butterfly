library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CU_tb is

--PORT();

end CU_tb;


architecture behavioural of CU_tb is

  component LATE_STATUS_CU
    port(CLOCK       : in  std_logic;
         RESET       : in  std_logic;
         START       : in  std_logic;
         INSTRUCTION : out std_logic_vector(22 downto 0)
         );
  end component;

  signal CLOCK, RESET, START : std_logic;

begin

  CU : LATE_STATUS_CU port map(CLOCK, RESET, START);

  CLK_50MHz : process
  begin
    CLOCK <= '0';
    wait for 10 ns;
    CLOCK <= '1';
    wait for 10 ns;
  end process;

  signals : process
  begin
    START <= '0';
    RESET <= '1';
    wait for 40 ns;
    RESET <= '0';
    wait for 20 ns;
    START <= '1';
    wait for 20 ns;
    START <= '0';
    wait;
  end process;

end behavioural;
