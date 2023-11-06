library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hexdisplay is
    port 
    (
        a	    : in UNSIGNED (3 downto 0);
        segments : out UNSIGNED (6 downto 0)
    );
end entity;

architecture rtl of hexdisplay is
begin
    segments(0) <= '1' when a = "0001" or a = "0100" or a = "1011" or a = "1101" else '0';

	segments(1) <= '1' when a = "0101" or a = "0110" or a = "1011" or a = "1100" 
	or a = "1110" or a = "1111" 
	else '0';

	segments(2) <= '1' when a = "0010" or a = "1100" or a = "1110" or a = "1111" 
	else '0';

	segments(3) <= '1' when a = "0001" or a = "0100" or a = "0111" or a = "1001" 
	or a = "1010" or a = "1111" 
	else '0';

	segments(4) <= '1' when a = "0001" or a = "0011" or a = "0100" or a = "0101" 
	or a = "0111" or a = "1001"
	else '0'; 

	segments(5) <= '1' when a = "0001" or a = "0010" or a = "0011" or a = "0111" 
	or a = "1101" 
	else '0';

	segments(6) <= '1' when a = "0000" or a = "0001" or a = "0111" or a = "1100" 
	else '0';
	
end rtl;
