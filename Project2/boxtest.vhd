library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity boxtest is
end entity;

architecture test of boxtest is
    signal A: UNSIGNED(3 downto 0);
    signal segments: UNSIGNED(6 downto 0);

    component hexdisplay
        port(
            a        : in UNSIGNED(3 downto 0);
            segments : out UNSIGNED(6 downto 0)
        );
    end component;
    
begin

    A <= "0000", "0001" after 200 ns, "0010" after 400 ns, "0011" after 600 ns, "0100" after 800 ns, "0101" after 1000 ns, "0110" after 1200 ns, "0111" after 1400 ns, "1000" after 1600 ns, "1001" after 1800 ns, "1010" after 2000 ns, "1011" after 2200 ns, "1100" after 2400 ns, "1101" after 2600 ns, "1110" after 2800 ns, "1111" after 3000 ns;

    C0: hexdisplay port map( A => a, segments => segments );
	 
end test;
