library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult_add_tb is

--PORT();

end mult_add_tb;


architecture behavioural of mult_add_tb is

  component ADDER
    port(DATA_IN0 : in  signed(30 downto 0) := (others => '0');
         DATA_IN1 : in  signed(30 downto 0) := (others => '0');
         C0       : in  std_logic           := '0';
         DATA_OUT : out signed(30 downto 0) := (others => '0')
         );
  end component;

  component MULTIPLIER
    port(DATA_IN0 : in  signed(15 downto 0) := (others => '0');
         DATA_IN1 : in  signed(15 downto 0) := (others => '0');
         DATA_OUT : out signed(31 downto 0) := (others => '0')
         );
  end component;

  component SHIFTER_X2
    port(DATA_IN  : in  signed(15 downto 0) := (others => '0');
         DATA_OUT : out signed(15 downto 0) := (others => '0')
         );
  end component;

  signal DATA_IN0, DATA_IN1 : signed(30 downto 0);
  signal C0                 : std_logic;

begin

  add  : ADDER port map(DATA_IN0, DATA_IN1, C0);
  mult : MULTIPLIER port map(DATA_IN0(30 downto 15), DATA_IN1(30 downto 15));
  shf  : SHIFTER_X2 port map(DATA_IN0(30 downto 15));

  signals : process
  begin
    DATA_IN0 <= "0000000000000001000000000000000";
    DATA_IN1 <= "0000000000000001100000000000000";
    C0       <= '0';
    wait for 40 ns;
    DATA_IN0 <= "1111111111111110111111111111111";  -- -32769
    DATA_IN1 <= "1111111111111110000000000000000";  -- -65536
    C0       <= '0';
    wait for 40 ns;
    DATA_IN0 <= "0000000000000001000000000000000";
    DATA_IN1 <= "1111111111111111000000000000000";
    C0       <= '0';
    wait for 40 ns;
    DATA_IN0 <= "0000000000000001000000000000000";
    DATA_IN1 <= "0000000000000001100000000000000";
    C0       <= '1';
    wait for 40 ns;
    DATA_IN0 <= "1111111111111110111111111111111";
    DATA_IN1 <= "1111111111111110000000000000000";
    C0       <= '1';
    wait for 40 ns;
    DATA_IN0 <= "0000000000000001000000000000000";
    DATA_IN1 <= "1111111111111111000000000000000";
    C0       <= '1';
    wait for 40 ns;
  end process;

end behavioural;
