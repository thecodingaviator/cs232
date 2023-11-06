library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lightrom is
    Port ( addr : in  STD_LOGIC_VECTOR(3 downto 0);
           data : out STD_LOGIC_VECTOR(2 downto 0)
			  );
end lightrom;

architecture a0 of lightrom is
begin
    data <= 
      "000" when addr = "0000" else 
      "101" when addr = "0001" else 
      "101" when addr = "0010" else 
      "101" when addr = "0011" else 
      "001" when addr = "0100" else 
      "001" when addr = "0101" else 
      "111" when addr = "0110" else 
      "111" when addr = "0111" else 
      "111" when addr = "1000" else 
      "111" when addr = "1001" else 
      "010" when addr = "1010" else 
      "010" when addr = "1011" else 
      "011" when addr = "1100" else 
      "100" when addr = "1101" else 
      "101" when addr = "1110" else 
      "011"; 


---- Program 1: Chasing Light
--data <= 
--  "000" when addr = "0000" else  -- Initialize LR to 0:  00000000
--  "011" when addr = "0001" else  -- add 1 to LR:        00000001
--  "010" when addr = "0010" else  -- shift LR left:      00000010
--  "010" when addr = "0011" else  -- shift LR left:      00000100
--  "010" when addr = "0100" else  -- shift LR left:      00001000
--  "010" when addr = "0101" else  -- shift LR left:      00010000
--  "010" when addr = "0110" else  -- shift LR left:      00100000
--  "010" when addr = "0111" else  -- shift LR left:      01000000
--  "010" when addr = "1000" else  -- shift LR left:      10000000
--  "001" when addr = "1001" else  -- shift LR right:     01000000
--  "001" when addr = "1010" else  -- shift LR right:     00100000
--  "001" when addr = "1011" else  -- shift LR right:     00010000
--  "001" when addr = "1100" else  -- shift LR right:     00001000
--  "001" when addr = "1101" else  -- shift LR right:     00000100
--  "001" when addr = "1110" else  -- shift LR right:     00000010
--  "001";                        -- shift LR right:     00000001

---- Program 2: Closing Curtains Effect
--data <= 
--  "101" when addr = "0000" else  -- invert all bits:    11111111
--  "100" when addr = "0001" else  -- subtract 1:         11111110
--  "001" when addr = "0010" else  -- shift LR right:     01111111
--  "100" when addr = "0011" else  -- subtract 1:         01111110
--  "001" when addr = "0100" else  -- shift LR right:     00111111
--  "100" when addr = "0101" else  -- subtract 1:         00111110
--  "001" when addr = "0110" else  -- shift LR right:     00011111
--  "100" when addr = "0111" else  -- subtract 1:         00011110
--  "001" when addr = "1000" else  -- shift LR right:     00001111
--  "100" when addr = "1001" else  -- subtract 1:         00001110
--  "001" when addr = "1010" else  -- shift LR right:     00000111
--  "100" when addr = "1011" else  -- subtract 1:         00000110
--  "001" when addr = "1100" else  -- shift LR right:     00000011
--  "100" when addr = "1101" else  -- subtract 1:         00000010
--  "001" when addr = "1110" else  -- shift LR right:     00000001
--  "100";                        -- subtract 1:         00000000
  
---- Extension: Program 3: Meteor Shower Effect
--data <= 
--  "000" when addr = "0000" else  -- Initialize LR to 0:  00000000
--  "011" when addr = "0001" else  -- add 1 to LR:        00000001
--  "010" when addr = "0010" else  -- shift LR left:      00000010
--  "010" when addr = "0011" else  -- shift LR left:      00000100
--  "010" when addr = "0100" else  -- shift LR left:      00001000
--  "010" when addr = "0101" else  -- shift LR left:      00010000
--  "010" when addr = "0110" else  -- shift LR left:      00100000
--  "010" when addr = "0111" else  -- shift LR left:      01000000
--  "101" when addr = "1000" else  -- invert all bits:    10111111
--  "101" when addr = "1001" else  -- invert all bits:    01000000
--  "001" when addr = "1010" else  -- shift LR right:     10000000
--  "001" when addr = "1011" else  -- shift LR right:     11000000
--  "001" when addr = "1100" else  -- shift LR right:     11100000
--  "001" when addr = "1101" else  -- shift LR right:     11110000
--  "101" when addr = "1110" else  -- invert all bits:    00001111
--  "101" when addr = "1111" else  -- invert all bits:    11110000
--  "001" when addr = "10000" else -- shift LR right:     11100001
--  "001" when addr = "10001" else -- shift LR right:     11000010
--  "101" when addr = "10010" else -- invert all bits:    00111101
--  "101" when addr = "10011" else -- invert all bits:    11000010
--  "010" when addr = "10100" else -- shift LR left:      01100001
--  "010" when addr = "10101" else -- shift LR left:      00110000
--  "010" when addr = "10110" else -- shift LR left:      00011000
--  "010" when addr = "10111" else -- shift LR left:      00001100
--  "101" when addr = "11000" else -- invert all bits:    11110011
--  "101" when addr = "11001" else -- invert all bits:    00001100
--  "101" when addr = "11010" else -- invert all bits:    11110011
--  "101" when addr = "11011" else -- invert all bits:    00001100
--  "000";                        -- Return to initial:  00000000

end a0;
