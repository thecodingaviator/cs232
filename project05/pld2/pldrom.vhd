LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pldrom IS
  PORT (
    addr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    data : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE ROM_arch OF pldrom IS
BEGIN
  -- -- Program 1: Write a program that loads 16 into the light register and has it count down to 0. Then it should flash between all 1s and all 0s 8 times and repeat from the beginning.

  -- data <=
  --   "0010100000" WHEN addr = "0000" ELSE -- move 0000 to the low 4 bits of the ACC
  --   "0011100001" WHEN addr = "0001" ELSE -- move 0001 to the high 4 bits of the ACC
  --   "0001000000" WHEN addr = "0010" ELSE -- move the ACC to the LR
  --   "0100110101" WHEN addr = "0011" ELSE -- subtract 1 from the LR
  --   "1110000110" WHEN addr = "0100" ELSE -- branch to address 0110 if the LR is 0
  --   "1000000011" WHEN addr = "0101" ELSE -- branch to address 0011
  --   "0010101000" WHEN addr = "0110" ELSE -- move 1000 to the low 4 bits of the ACC
  --   "0011100000" WHEN addr = "0111" ELSE -- move 0000 to the high 4 bits of the ACC
  --   "0001110000" WHEN addr = "1000" ELSE -- move 11111111 to the LR
  --   "0001100000" WHEN addr = "1001" ELSE -- move 00000000 to the LR
  --   "0100110001" WHEN addr = "1010" ELSE -- subtract 1 from the ACC
  --   "1100000000" WHEN addr = "1011" ELSE -- branch to address 0000 if the ACC is 0
  --   "1000001000" WHEN addr = "1100" ELSE -- branch to address 1000
  --   "0000000000"; -- garbage for ELSE

  -- Program 2: Write a program that loads a power of 2 (32) into the light register and has it count down to 0 in steps of 0.5x. Then it should flash all 8 LEDs twice and repeat from the beginning. 

  data <=
    "0010100000" WHEN addr = "0000" ELSE -- move 0000 to the low 4 bits of the ACC
    "0011100001" WHEN addr = "0001" ELSE -- move 0010 to the high 4 bits of the ACC
    "0001000000" WHEN addr = "0010" ELSE -- move the ACC to the LR
    "0111101100" WHEN addr = "0011" ELSE -- shift right LR (halve its value)
    "0100110101" WHEN addr = "0100" ELSE -- subtract 1 from the LR
    "1110001000" WHEN addr = "0101" ELSE -- branch to address 1000 if the LR is 0 (which means original value was 1)
    "0100010101" WHEN addr = "0110" ELSE -- add 1 to the LR (to restore original value)
    "1000000011" WHEN addr = "0111" ELSE -- branch to address 0011
    "0010100010" WHEN addr = "1000" ELSE -- move 0010 to the low 4 bits of the ACC (for 8 flashes)
    "0011100000" WHEN addr = "1001" ELSE -- move 0000 to the high 4 bits of the ACC
    "0001110000" WHEN addr = "1010" ELSE -- move 11111111 to the LR
    "0001100000" WHEN addr = "1011" ELSE -- move 00000000 to the LR
    "0100110001" WHEN addr = "1100" ELSE -- subtract 1 from the ACC
    "1100000000" WHEN addr = "1101" ELSE -- branch to address 0000 if the ACC is 0
    "1000001010" WHEN addr = "1110" ELSE -- branch to address 1010
    "0000000000"; -- branch to address 1000

END ROM_arch;