LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY stacker IS
  PORT (
    clock : IN STD_LOGIC;
    data : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    b0 : IN STD_LOGIC;
    b1 : IN STD_LOGIC;
    b2 : IN STD_LOGIC;
    mbrview : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    stackview : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    stateview : OUT STD_LOGIC_VECTOR (2 DOWNTO 0));
END stacker;

ARCHITECTURE Behavioral OF stacker IS
  SIGNAL RAM_input, RAM_output, mbr : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL RAM_we : STD_LOGIC;
  SIGNAL stack_ptr : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL state : STD_LOGIC_VECTOR (2 DOWNTO 0);

  COMPONENT memram_lab
    PORT (
      address : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      clock : IN STD_LOGIC := '1';
      data : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      wren : IN STD_LOGIC;
      q : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
  END COMPONENT;

BEGIN

  RAM_instance : memram_lab
  PORT MAP(
    address => stack_ptr,
    clock => clock,
    data => RAM_input,
    wren => RAM_we,
    q => RAM_output
  );

  mbrview <= mbr;
  stackview <= stack_ptr;
  stateview <= state;

  PROCESS (clock)
  BEGIN
    IF b1 = '0' AND b2 = '0' THEN -- Reset condition
      stack_ptr <= (OTHERS => '0');
      mbr <= (OTHERS => '0');
      RAM_input <= (OTHERS => '0');
      RAM_we <= '0';
      state <= "000";
    ELSE
      IF rising_edge(clock) THEN
        CASE state IS
            -- State "000": this state is waiting for a button press. If Button 0 is pressed, assign the data signal to the MBR and move to state "111". If Button 1 is pressed, assign the MBR to the RAM_input, assign '1' to the RAM_we signal, and move to state "001". The RAM_we signal tells the RAM to write the value on the RAM_input to the address specified by the stack pointer. If Button 2 is pressed, check if the stack pointer value is not zero. If it is not zero, then subtract one from the stack pointer, then move to state "100".
          WHEN "000" =>
            IF b0 = '0' THEN
              mbr <= data;
              state <= "111";
            ELSIF b1 = '0' THEN
              RAM_input <= mbr;
              RAM_we <= '1';
              state <= "001";
            ELSIF b2 = '0' THEN
              IF stack_ptr /= "0000" THEN
                stack_ptr <= stack_ptr - 1;
                state <= "100";
              END IF;
            END IF;
            -- State "001": this is the next step in the process of writing to memory. Set the RAM_we back to '0', and increment the stack pointer so it has the address of the next free memory location. Move to state "111".
          WHEN "001" =>
            RAM_we <= '0';
            stack_ptr <= stack_ptr + 1;
            state <= "111";
            -- State "100": this is the next step in the read process. Since the address of the RAM was just modified in state "000", we need to wait for two clock cycles for the new address to be accepted and the proper output to appear. Do nothing except go to state "101".
          WHEN "100" =>
            state <= "101";
            -- State "101": Again, do nothing except go to state "110".
          WHEN "101" =>
            state <= "110";
            -- State "110": The output should be available, so assign the RAM_output to the MBR. Go to state "111".
          WHEN "110" =>
            mbr <= RAM_output;
            state <= "111";
            -- State "111": This is a state that waits for all of the buttons to be released. If Buttons 0, 1, and 2 all have the value '1', then go to state "000".
          WHEN "111" =>
            IF b0 = '1' AND b1 = '1' AND b2 = '1' THEN
              state <= "000";
            END IF;
            -- The when others case should go to state "000".
          WHEN OTHERS =>
            state <= "000";
        END CASE;
      END IF;
    END IF;
  END PROCESS;

END Behavioral;