LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY calculator IS
  PORT (
    clock : IN STD_LOGIC;
    b0 : IN STD_LOGIC; -- capture input
    b1 : IN STD_LOGIC; -- enter
    b2 : IN STD_LOGIC; -- action
    op : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- operation switches
    data : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- input data switches
    digit0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- output for 7-segment display
    digit1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- output for 7-segment display
    stackview : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) -- output for stack debugging
  );
END calculator;

ARCHITECTURE rtl OF calculator IS
  COMPONENT memram IS
    PORT (
      address : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      clock : IN STD_LOGIC;
      data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      wren : IN STD_LOGIC;
      q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT hexdisplay IS
    PORT (
      a : IN unsigned(3 DOWNTO 0);
      segments : OUT unsigned(6 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL RAM_input : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL RAM_output : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL RAM_we : STD_LOGIC;
  SIGNAL stack_ptr : unsigned(3 DOWNTO 0);
  SIGNAL mbr : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL state : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL hex0 : unsigned(6 DOWNTO 0);
  SIGNAL hex1 : unsigned(6 DOWNTO 0);

BEGIN
  -- State machine logic
  PROCESS (clock)
  BEGIN
    IF b1 = '0' AND b2 = '0' THEN
      -- Reset logic
      stack_ptr <= (OTHERS => '0');
      mbr <= (OTHERS => '0');
      RAM_input <= (OTHERS => '0');
      RAM_we <= '0';
      state <= "000";

    ELSIF rising_edge(clock) THEN
      CASE state IS
        WHEN "000" =>
          -- Idle state logic
          IF b0 = '0' THEN
            -- Capture input data
            mbr <= data;
            state <= "111";
          ELSIF b1 = '0' THEN
            -- Enter data onto the stack
            RAM_input <= mbr;
            RAM_we <= '1';
            state <= "001";
          ELSIF b2 = '0' THEN
            -- Extension: only decrement if stack is not empty
            IF stack_ptr /= "0000" THEN
              -- Pop the stack
              stack_ptr <= stack_ptr - 1;
              state <= "100";
            END IF;
          END IF;

        WHEN "001" =>
          -- Data entered onto stack, increment stack pointer
          RAM_we <= '0';
          -- Extension: only increment if stack is not full
          IF stack_ptr /= "1111" THEN
            stack_ptr <= stack_ptr + 1;
          END IF;
          state <= "111";

        WHEN "100" =>
          state <= "101";

        WHEN "101" =>
          state <= "110";

        WHEN "110" =>
          -- Action state, perform the operation
          -- Assume RAM_output is valid and contains the previous stack value
          CASE op IS
            WHEN "00" =>
              -- ADD
              mbr <= STD_LOGIC_VECTOR(unsigned(RAM_output) + unsigned(mbr));
            WHEN "01" =>
              -- SUBTRACT
              mbr <= STD_LOGIC_VECTOR(unsigned(RAM_output) - unsigned(mbr));
            WHEN "10" =>
              -- MULTIPLY (only use lower 4 bits)
              mbr <= std_logic_vector(unsigned(RAM_output(3 downto 0)) * unsigned(mbr(3 downto 0)));-- Zero out the upper 4 bits
            WHEN "11" =>
              -- DIVIDE
              mbr <= STD_LOGIC_VECTOR(unsigned(RAM_output) / unsigned(mbr));
            WHEN OTHERS => NULL;
          END CASE;
          state <= "111";

        WHEN "111" =>
          IF b0 = '1' AND b1 = '1' AND b2 = '1' THEN
            state <= "000";
          END IF;

        WHEN OTHERS =>
          state <= "000";
      END CASE;
    END IF;
  END PROCESS;

  -- Output assignments
  digit0 <= STD_LOGIC_VECTOR(hex0);
  digit1 <= STD_LOGIC_VECTOR(hex1);
  stackview <= STD_LOGIC_VECTOR(stack_ptr);

  -- Port mapping
  RAM0 : memram
  PORT MAP(
    address => STD_LOGIC_VECTOR(stack_ptr),
    clock => clock,
    data => RAM_input,
    wren => RAM_we,
    q => RAM_output
  );

  HEXD0 : hexdisplay
  PORT MAP(
    a => unsigned(mbr(3 DOWNTO 0)),
    segments => hex0
  );

  HEXD1 : hexdisplay
  PORT MAP(
    a => unsigned(mbr(7 DOWNTO 4)),
    segments => hex1
  );

END rtl;