-- Parth Parth
-- CS 232 Fall 2023

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY alu IS
  PORT (
    srcA : IN unsigned(15 DOWNTO 0); -- input A
    srcB : IN unsigned(15 DOWNTO 0); -- input B
    op : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- operation
    cr : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- condition outputs
    dest : OUT unsigned(15 DOWNTO 0) -- output value
  );
END alu;

ARCHITECTURE test OF alu IS
  -- The signal tdest is an intermediate signal to hold the result and
  -- catch the carry bit in location 16.
  SIGNAL tdest : unsigned(16 DOWNTO 0);

BEGIN -- test
  PROCESS (srcA, srcB, op)
  BEGIN -- process
    CASE op IS
      WHEN "000" => -- addition     tdest = srcA + srcB
        tdest <= ('0' & srcA) + srcB;
      WHEN "001" => -- subtraction  tdest = srcA - srcB
        tdest <= ('0' & srcA) - srcB;
      WHEN "010" => -- and          tdest = srcA and srcB
        tdest <= '0' & unsigned(STD_LOGIC_VECTOR(srcA) AND STD_LOGIC_VECTOR(srcB));
      WHEN "011" => -- or           tdest = srcA or srcB
        tdest <= '0' & unsigned(STD_LOGIC_VECTOR(srcA) OR STD_LOGIC_VECTOR(srcB));
      WHEN "100" => -- xor          tdest = srcA xor srcB
        tdest <= '0' & unsigned(STD_LOGIC_VECTOR(srcA) XOR STD_LOGIC_VECTOR(srcB));

      WHEN "101" => -- shift        tdest = srcA shifted left arithmetic by one if srcB(0) is 0, otherwise right
        -- shift and preserve sign  
        IF srcB(0) = '0' THEN
          tdest <= srcA(15 DOWNTO 0) & '0';
        ELSE
          tdest <= '0' & srcA(15) & srcA(15 DOWNTO 1);
        END IF;

      WHEN "110" => -- rotate       tdest = srcA rotated left by one if srcB(0) is 0, otherwise right
        IF srcB(0) = '0' THEN
          tdest <= srcA(15 DOWNTO 0) & srcA(15);
        ELSE
          tdest <= '0' & srcA(0) & srcA(15 DOWNTO 1);
        END IF;

      WHEN "111" => -- pass         tdest = srcA
        tdest <= '0' & srcA;
      WHEN OTHERS =>
        NULL;
    END CASE;
  END PROCESS;

  -- connect the low 16 bits of tdest to dest here
  dest <= tdest(15 DOWNTO 0);

  -- set the four CR output bits here
  -- cr(0) <= '1' if the result of the operation is 0
  cr(0) <= '1' WHEN tdest(15 DOWNTO 0) = "0000000000000000" ELSE
  '0';
  -- cr(1) <= '1' if there is a 2's complement overflow
  cr(1) <= '1' WHEN srcA(15) = srcB(15) AND srcA(15) /= tdest(15) AND (op = "000" OR op = "001") ELSE
  '0';
  -- cr(2) <= '1' if the result of the operation is negative
  cr(2) <= '1' WHEN tdest(15) = '1' ELSE
  '0';
  -- cr(3) <= '1' if the operation generated a carry of '1'
  cr(3) <= '1' WHEN tdest(16) = '1' ELSE
  '0';

END test;