LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY calculator_tb IS
  -- Testbench has no ports!
END calculator_tb;

ARCHITECTURE behavior OF calculator_tb IS

  -- Component Declaration for the Unit Under Test (UUT)
  COMPONENT calculator
    PORT (
      clock : IN STD_LOGIC;
      b0 : IN STD_LOGIC;
      b1 : IN STD_LOGIC;
      b2 : IN STD_LOGIC;
      op : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      digit0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      digit1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      stackview : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
  END COMPONENT;

  --Inputs
  SIGNAL clock : STD_LOGIC := '0';
  SIGNAL b0 : STD_LOGIC := '1'; -- Initially not pressed
  SIGNAL b1 : STD_LOGIC := '1'; -- Initially not pressed
  SIGNAL b2 : STD_LOGIC := '1'; -- Initially not pressed
  SIGNAL op : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL data : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');

  --Outputs
  SIGNAL digit0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL digit1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL stackview : STD_LOGIC_VECTOR(3 DOWNTO 0);

  -- Clock period definitions
  CONSTANT clock_period : TIME := 10 ns;

BEGIN

  -- Instantiate the Unit Under Test (UUT)
  uut : calculator PORT MAP(
    clock => clock,
    b0 => b0,
    b1 => b1,
    b2 => b2,
    op => op,
    data => data,
    digit0 => digit0,
    digit1 => digit1,
    stackview => stackview
  );

  -- Clock process definitions
  clock_process : PROCESS
  BEGIN
    WHILE true LOOP
      clock <= '0';
      WAIT FOR clock_period/2;
      clock <= '1';
      WAIT FOR clock_period/2;
    END LOOP;
  END PROCESS;

  -- Stimulus process
  stim_proc : PROCESS
  BEGIN
    -- initial wait and reset
    b1 <= '0'; -- Button press to enter data onto the stack
    b2 <= '0'; -- Button press to perform operation
    WAIT FOR clock_period * 10;

    b1 <= '1'; -- Release button
    b2 <= '1'; -- Release button

    -- push 2 onto stack
    b0 <= '0'; -- Button press to capture data
    data <= "00000010"; -- Data input 2
    WAIT FOR clock_period * 10;
    b0 <= '1'; -- Release button
    b1 <= '0'; -- Button press to enter data onto the stack
    WAIT FOR clock_period * 10;
    b1 <= '1'; -- Release button

    -- -- push 6 onto stack
    -- b0 <= '0';
    -- data <= "00000110"; -- Data input 6
    -- WAIT FOR clock_period * 10;
    -- b0 <= '1';
    -- b1 <= '0';
    -- WAIT FOR clock_period * 10;
    -- b1 <= '1';

    -- -- push 4 onto stack
    -- b0 <= '0';
    -- data <= "00000100"; -- Data input 4
    -- WAIT FOR clock_period * 10;
    -- b0 <= '1';
    -- b1 <= '0';
    -- WAIT FOR clock_period * 10;
    -- b1 <= '1';

    -- -- push 0 onto stack
    -- b0 <= '0';
    -- data <= "00000000"; -- Data input 0
    -- WAIT FOR clock_period * 10;
    -- b0 <= '1';
    -- b1 <= '0';
    -- WAIT FOR clock_period * 10;
    -- b1 <= '1';

    -- -- perform subtraction (4-0)
    -- b2 <= '0';
    -- op <= "01"; -- Opcode for subtraction
    -- WAIT FOR clock_period * 10;
    -- b2 <= '1'; -- Release button

    -- -- perform subtraction (6-4)
    -- b2 <= '0';
    -- WAIT FOR clock_period * 10;
    -- b2 <= '1';

    -- -- perform addition (2+2)
    -- op <= "00"; -- Opcode for addition
    -- b2 <= '0';
    -- WAIT FOR clock_period * 10;
    -- b2 <= '1';

    -- end simulation
    WAIT;
  END PROCESS;

END behavior;