LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY alutestbench IS
END alutestbench;

ARCHITECTURE test OF alutestbench IS
  CONSTANT num_cycles : INTEGER := 20;
  SIGNAL state : unsigned(3 DOWNTO 0);
  SIGNAL srcA : unsigned(15 DOWNTO 0);
  SIGNAL srcB : unsigned(15 DOWNTO 0);
  SIGNAL dest : unsigned(15 DOWNTO 0) := "0000000000000000";
  SIGNAL opcode : STD_LOGIC_VECTOR(2 DOWNTO 0);

  SIGNAL output : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
  SIGNAL CR : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  SIGNAL clk : STD_LOGIC := '1';
  SIGNAL reset : STD_LOGIC;

  -- component statement for the ALU
  COMPONENT alu
    PORT (
      srcA : IN unsigned(15 DOWNTO 0); -- input A
      srcB : IN unsigned(15 DOWNTO 0); -- input B
      op : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- operation
      cr : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- condition outputs
      dest : OUT unsigned(15 DOWNTO 0)); -- output value
  END COMPONENT;

BEGIN

  -- start off with a short reset
  reset <= '0', '1' AFTER 1 ns;

  -- create a clock
  PROCESS
  BEGIN
    FOR i IN 1 TO num_cycles LOOP
      clk <= NOT clk;
      WAIT FOR 1 ns;
      clk <= NOT clk;
      WAIT FOR 1 ns;
    END LOOP;
    WAIT;
  END PROCESS;
  aluinstance : alu
  PORT MAP(srcA => srcA, srcB => srcB, dest => dest, op => opcode, cr => CR);

  output <= STD_LOGIC_VECTOR(dest); -- connect dest and the output

  PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      srcA <= "0000000000000000";
      srcB <= "0000000000000000";
      state <= "0000";
    ELSIF rising_edge(clk) THEN
      CASE state IS
        WHEN "0000" =>
          srcA <= x"7FFF";
          srcB <= x"0002";
          opcode <= "000"; -- addition, answer should be x8001, flags "0110"
          state <= state + 1;
        WHEN "0001" =>
          srcA <= x"FF10";
          srcB <= x"FFFF";
          opcode <= "000"; -- addition, answer should be xFF0F, flags "1100"
          state <= state + 1;
        WHEN "0010" =>
          srcA <= x"0014";
          srcB <= x"0012";
          opcode <= "001"; -- subtraction, answer should be x0002, flags "0000"
          state <= state + 1;
        WHEN "0011" =>
          srcA <= x"FFFE";
          srcB <= x"FFFF";
          opcode <= "001"; -- subtraction, answer should be xFFFF, flags "1100"
          state <= state + 1;
        WHEN "0100" =>
          srcA <= x"FFFF";
          srcB <= x"AAAA";
          opcode <= "010"; -- and, answer should be xAAAA, flags "0100"
          state <= state + 1;
        WHEN "0101" =>
          srcA <= x"00FF";
          srcB <= x"AAAA"; -- and, answer should be x00AA, flags "0000"
          opcode <= "010";
          state <= state + 1;
        WHEN "0110" =>
          srcA <= x"FFFF";
          srcB <= x"AAAA";
          opcode <= "011"; -- or, answer should be xFFFF, flags "0100"
          state <= state + 1;
        WHEN "0111" =>
          srcA <= x"FF00";
          srcB <= x"AAAA"; -- or, answer should be xFFAA, flags "0100"
          opcode <= "011";
          state <= state + 1;
        WHEN "1000" =>
          srcA <= x"FFFF";
          srcB <= x"AAAA";
          opcode <= "100"; -- xor, answer should be x5555, flags "0000"
          state <= state + 1;
        WHEN "1001" =>
          srcA <= x"FF00";
          srcB <= x"AAAA";
          opcode <= "100"; -- xor, answer should be x55AA, flags "0000"
          state <= state + 1;
        WHEN "1010" =>
          srcA <= x"AAAA";
          srcB <= x"0000";
          opcode <= "101"; -- shift, left by 1, answer should be x5554, flags "1000"
          state <= state + 1;
        WHEN "1011" =>
          srcA <= x"AAAA";
          srcB <= x"0001";
          opcode <= "101"; -- shift, right by 1, answer should be xD555, flags "0100"
          state <= state + 1;
        WHEN "1100" =>
          srcA <= x"AAAA";
          srcB <= x"0000";
          opcode <= "110"; -- rotate, left by 1, answer should be x5555, flags "1000"
          state <= state + 1;
        WHEN "1101" =>
          srcA <= x"AAAA";
          srcB <= x"0001";
          opcode <= "110"; -- rotate, right by 1, answer should be x5555, flags "0000"
          state <= state + 1;
        WHEN "1110" =>
          srcA <= x"0000";
          srcB <= x"0234";
          opcode <= "111"; -- pass through, answer should be x0000, flags "0001"
          state <= state + 1;
        WHEN OTHERS =>
          srcA <= x"F012";
          srcB <= x"0000";
          opcode <= "111"; -- pass through, answer should be xF012, flags "0100"
          state <= state + 1;
      END CASE;
    END IF;
  END PROCESS;

END test;