-- timingtest.vhd
-- Testbench for timer state machine

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timingtest is
end timingtest;

architecture test of timingtest is

  -- internal signals
  signal reset, start, react : std_logic;
  signal leds : std_logic_vector(2 downto 0);
  signal cycles : std_logic_vector(7 downto 0);
  signal state_display : std_logic_vector(1 downto 0);

  -- Signals for hex display segments
	signal hex0_segments : UNSIGNED(6 downto 0);  
	signal hex1_segments : UNSIGNED(6 downto 0);

  -- Component declaration for timer
  component timer
    port (
      clk : in std_logic;
      reset : in std_logic;
      start : in std_logic;
      react : in std_logic;
      cycles : out std_logic_vector(7 downto 0);
      leds : out std_logic_vector(2 downto 0);
		curstate: out std_logic_vector(1 downto 0)
    );
  end component;

  component hexdisplay is
    port (
      a : in unsigned(3 downto 0);
      segments : out UNSIGNED(6 downto 0)
    );
	end component;

  -- signals for making the clock
  constant num_cycles : integer := 20;
  signal clk : std_logic := '1';
  
begin

  -- timed signals to create specific numbers
  reset <= '0', '1' after 7 ns;
  start <= '1', '0' after 10 ns, '1' after 20 ns, '0' after 75 ns, '1' after 85 ns;
  react <= '1', '0' after 25 ns, '1' after 35 ns, '0' after 170 ns, '1' after 180 ns;
  
  -- process and for-loop to generate a clock
  process begin
    for i in 1 to num_cycles loop
      clk <= not clk;
      wait for 5 ns;
      clk <= not clk;
      wait for 5 ns;
    end loop;
    wait;
  end process;

  -- Instantiate timer and hexdisplay components
  B0 : timer port map(clk, reset, start, react, cycles, leds, state_display);
  HEX0 : hexdisplay port map(a => unsigned(cycles(3 downto 0)), segments => hex0_segments);
  HEX1 : hexdisplay port map(a => unsigned(cycles(7 downto 4)), segments => hex1_segments);

end test;
