library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
	port
	(
		a: in UNSIGNED (3 downto 0);
		b: in UNSIGNED (3 downto 0);
		c: out UNSIGNED (4 downto 0)
	);
end entity;

architecture rtl of adder is
begin

	c <= ('0' & a) + ('0' & b);
	
end rtl;
	