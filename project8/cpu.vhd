-- Parth Parth
-- CS 232 Fall 2023

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY cpu IS

  PORT (
    clk : IN STD_LOGIC; -- main clock
    reset : IN STD_LOGIC; -- reset button

    PCview : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- debugging outputs for testbench
    IRview : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    RAview : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    RBview : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    RCview : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    RDview : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    REview : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

    iport : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- input port
    oport : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)); -- output port
END cpu;

ARCHITECTURE program OF cpu IS

  COMPONENT ProgramROM IS
    PORT (
      address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      clock : IN STD_LOGIC := '1';
      q : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT DataRAM IS
    PORT (
      address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      clock : IN STD_LOGIC := '1';
      data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      wren : IN STD_LOGIC;
      q : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT alu IS
    PORT (
      srcA : IN unsigned(15 DOWNTO 0); -- input A
      srcB : IN unsigned(15 DOWNTO 0); -- input B
      op : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- operation
      cr : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- condition outputs
      dest : OUT unsigned(15 DOWNTO 0)); -- output value

  END COMPONENT;

  TYPE state_type IS (sStart, sFetch, sExecuteSetup, sExecuteALU, sExecuteMemWait, sExecuteWrite, sExecuteReturn1, sExecuteReturn2, sHalt);
  SIGNAL state : state_type;
  SIGNAL counter3bit : unsigned(2 DOWNTO 0); -- 3 bit counter for 8 cycles

  -- registers
  SIGNAL PC : unsigned(7 DOWNTO 0); -- program counter
  SIGNAL IR : STD_LOGIC_VECTOR(15 DOWNTO 0); -- instruction register
  SIGNAL SP : unsigned(15 DOWNTO 0) := "0000000000000000"; -- stack pointer
  SIGNAL RA : STD_LOGIC_VECTOR(15 DOWNTO 0); -- register A
  SIGNAL RB : STD_LOGIC_VECTOR(15 DOWNTO 0); -- register B
  SIGNAL RC : STD_LOGIC_VECTOR(15 DOWNTO 0); -- register C
  SIGNAL RD : STD_LOGIC_VECTOR(15 DOWNTO 0); -- register D
  SIGNAL RE : STD_LOGIC_VECTOR(15 DOWNTO 0); -- register E
  SIGNAL MBR : STD_LOGIC_VECTOR(15 DOWNTO 0); -- memory buffer register
  SIGNAL MAR : unsigned(7 DOWNTO 0); -- memory address register
  SIGNAL CR : STD_LOGIC_VECTOR(3 DOWNTO 0); -- condition register
  SIGNAL OUTREG : STD_LOGIC_VECTOR(15 DOWNTO 0); -- output register

  -- signals for alu
  SIGNAL alusrcA : unsigned(15 DOWNTO 0);
  SIGNAL alusrcB : unsigned(15 DOWNTO 0);
  SIGNAL aluOP : STD_LOGIC_VECTOR(2 DOWNTO 0); -- operation
  SIGNAL aluCR : STD_LOGIC_VECTOR(3 DOWNTO 0); -- condition outputs
  SIGNAL aluOUT : unsigned(15 DOWNTO 0);

  -- signals for memory
  SIGNAL ROMout : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL RAMout : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL RAMwe : STD_LOGIC := '0'; -- write enable

BEGIN
  -- 9 state machine for RISC CPU
  PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      PC <= (OTHERS => '0');
      IR <= (OTHERS => '0');
      OUTREG <= (OTHERS => '0');
      MAR <= (OTHERS => '0');
      MBR <= (OTHERS => '0');
      RA <= (OTHERS => '0');
      RB <= (OTHERS => '0');
      RC <= (OTHERS => '0');
      RD <= (OTHERS => '0');
      RE <= (OTHERS => '0');
      SP <= (OTHERS => '0');
      CR <= (OTHERS => '0'); -- 
      counter3bit <= (OTHERS => '0');
      state <= sStart;

    ELSIF (rising_edge(clk)) THEN
      CASE state IS
        WHEN sStart => -- initialize and stay here for 7 counts
          IF counter3bit = "111" THEN
            state <= sFetch;
          ELSE
            counter3bit <= counter3bit + 1;
          END IF;

        WHEN sFetch => -- copy ROM data to IR
          IR <= ROMout;
          PC <= PC + 1;
          state <= sExecuteSetup;

        WHEN sExecuteSetup =>
          aluOP <= IR(14 DOWNTO 12); -- operation

          CASE IR(15 DOWNTO 12) IS
            WHEN "0000" => -- load
              IF IR(11) = '1' THEN
                MAR <= unsigned(IR(7 DOWNTO 0)) + unsigned(RE(7 DOWNTO 0));
              ELSE
                MAR <= unsigned(IR(7 DOWNTO 0));
              END IF;
            WHEN "0001" => -- store
              IF IR(11) = '1' THEN
                MAR <= unsigned(IR(7 DOWNTO 0)) + unsigned(RE(7 DOWNTO 0));
              ELSE
                MAR <= unsigned(IR(7 DOWNTO 0));
              END IF;
              CASE IR(10 DOWNTO 8) IS
                WHEN "000" => MBR <= RA;
                WHEN "001" => MBR <= RB;
                WHEN "010" => MBR <= RC;
                WHEN "011" => MBR <= RD;
                WHEN "100" => MBR <= RE;
                WHEN "101" => MBR <= STD_LOGIC_VECTOR(SP);
                WHEN OTHERS => NULL;
              END CASE;

            WHEN "0010" => --unconditional branch
              PC <= unsigned(IR(7 DOWNTO 0));

            WHEN "0011" => --conditional branch, call, return, (exit)
              CASE IR(11 DOWNTO 10) IS
                WHEN "00" => -- conditional branch
                  CASE IR(9 DOWNTO 8) IS
                    WHEN "00" =>
                      IF aluCR(0) = '1' THEN
                        PC <= unsigned(IR(7 DOWNTO 0));
                      END IF;
                    WHEN "01" =>
                      IF aluCR(1) = '1' THEN
                        PC <= unsigned(IR(7 DOWNTO 0));
                      END IF;
                    WHEN "10" =>
                      IF aluCR(2) = '1' THEN
                        PC <= unsigned(IR(7 DOWNTO 0));
                      END IF;
                    WHEN OTHERS =>
                      IF aluCR(3) = '1' THEN
                        PC <= unsigned(IR(7 DOWNTO 0));
                      END IF;
                  END CASE;

                WHEN "01" => -- call 
                  PC <= unsigned(IR(7 DOWNTO 0));
                  MAR <= SP(7 DOWNTO 0);
                  MBR <= "0000" & CR & STD_LOGIC_VECTOR(PC);
                  SP <= SP + 1;
                WHEN "10" => -- return
                  MAR <= SP(7 DOWNTO 0) - 1;
                  SP <= SP - 1;
                WHEN OTHERS => -- exit
                  state <= sHalt;
              END CASE;

            WHEN "0100" => -- push
              MAR <= SP(7 DOWNTO 0);
              SP <= SP + 1;
              CASE IR(11 DOWNTO 9) IS
                WHEN "000" => MBR <= RA;
                WHEN "001" => MBR <= RB;
                WHEN "010" => MBR <= RC;
                WHEN "011" => MBR <= RD;
                WHEN "100" => MBR <= RE;
                WHEN "101" => MBR <= STD_LOGIC_VECTOR(SP);
                WHEN "110" => MBR <= STD_LOGIC_VECTOR("00000000" & PC);
                WHEN OTHERS => MBR <= "000000000000" & CR;
              END CASE;

            WHEN "0101" => -- pop
              MAR <= SP(7 DOWNTO 0) - 1;
              SP <= SP - 1;

            WHEN "1000" | "1001" | "1010" | "1011" | "1100" => -- ALU binary
              CASE IR(11 DOWNTO 9) IS -- srcA
                WHEN "000" => alusrcA <= unsigned(RA);
                WHEN "001" => alusrcA <= unsigned(RB);
                WHEN "010" => alusrcA <= unsigned(RC);
                WHEN "011" => alusrcA <= unsigned(RD);
                WHEN "100" => alusrcA <= unsigned(RE);
                WHEN "101" => alusrcA <= SP;
                WHEN "110" => alusrcA <= "0000000000000000";
                WHEN OTHERS => alusrcA <= "1111111111111111";
              END CASE;
              CASE IR(8 DOWNTO 6) IS -- srcB
                WHEN "000" => alusrcB <= unsigned(RA);
                WHEN "001" => alusrcB <= unsigned(RB);
                WHEN "010" => alusrcB <= unsigned(RC);
                WHEN "011" => alusrcB <= unsigned(RD);
                WHEN "100" => alusrcB <= unsigned(RE);
                WHEN "101" => alusrcB <= SP;
                WHEN "110" => alusrcB <= "0000000000000000";
                WHEN "111" => alusrcB <= "1111111111111111";
                WHEN OTHERS => NULL;
              END CASE;

            WHEN "1101" | "1110" => -- ALU unary
              CASE IR(10 DOWNTO 8) IS -- srcA
                WHEN "000" => alusrcA <= unsigned(RA);
                WHEN "001" => alusrcA <= unsigned(RB);
                WHEN "010" => alusrcA <= unsigned(RC);
                WHEN "011" => alusrcA <= unsigned(RD);
                WHEN "100" => alusrcA <= unsigned(RE);
                WHEN "101" => alusrcA <= SP;
                WHEN "110" => alusrcA <= "0000000000000000";
                WHEN OTHERS => alusrcA <= "1111111111111111";
              END CASE;
              alusrcB <= (OTHERS => '0');
              IF IR(11) = '1' THEN
                alusrcB <= alusrcB + 1;
              END IF;

            WHEN "1111" => -- move
              IF IR(11) = '1' THEN
                IF IR(10) = '1' THEN -- sign extend 
                  alusrcA <= unsigned("11111111" & IR(10 DOWNTO 3)); -- negative
                ELSE
                  alusrcA <= unsigned("00000000" & IR(10 DOWNTO 3)); -- positive
                END IF;
              ELSE
                CASE IR(10 DOWNTO 8) IS -- srcA
                  WHEN "000" => alusrcA <= unsigned(RA);
                  WHEN "001" => alusrcA <= unsigned(RB);
                  WHEN "010" => alusrcA <= unsigned(RC);
                  WHEN "011" => alusrcA <= unsigned(RD);
                  WHEN "100" => alusrcA <= unsigned(RE);
                  WHEN "101" => alusrcA <= SP;
                  WHEN "110" => alusrcA <= "00000000" & PC;
                  WHEN OTHERS => alusrcA <= unsigned(IR);
                END CASE;
              END IF;

            WHEN OTHERS => NULL;
          END CASE;
          state <= sExecuteALU;

        WHEN sExecuteALU =>
          -- store, call, push
          IF IR(15 DOWNTO 12) = "0001" OR IR(15 DOWNTO 10) = "001101" OR IR(15 DOWNTO 12) = "0100" THEN
            RAMwe <= '1';
          END IF;
          -- load, pop, return
          IF IR(15 DOWNTO 12) = "0000" OR IR(15 DOWNTO 12) = "0101" OR IR(15 DOWNTO 10) = "001110" THEN
            state <= sExecuteMemWait;
          ELSE
            state <= sExecuteWrite;
          END IF;

        WHEN sExecuteMemWait =>
          state <= sExecuteWrite;

        WHEN sExecuteWrite =>
          RAMwe <= '0';
          
          CASE IR(15 DOWNTO 12) IS
            WHEN "0000" => -- load
              CASE IR(10 DOWNTO 8) IS
                WHEN "000" => RA <= RAMout;
                WHEN "001" => RB <= RAMout;
                WHEN "010" => RC <= RAMout;
                WHEN "011" => RD <= RAMout;
                WHEN "100" => RE <= RAMout;
                WHEN "101" => SP <= unsigned(RAMout);
                WHEN OTHERS => NULL;
              END CASE;
            WHEN "0011" => -- return
              IF IR(11 DOWNTO 10) = "10" THEN
                PC <= unsigned(RAMout(7 DOWNTO 0));
                CR <= RAMout(11 DOWNTO 8);
              END IF;
            WHEN "0101" => -- pop
              CASE IR(11 DOWNTO 9) IS
                WHEN "000" => RA <= RAMout;
                WHEN "001" => RB <= RAMout;
                WHEN "010" => RC <= RAMout;
                WHEN "011" => RD <= RAMout;
                WHEN "100" => RE <= RAMout;
                WHEN "101" => SP <= unsigned(RAMout);
                WHEN "110" => PC <= unsigned(RAMout(7 DOWNTO 0));
                WHEN OTHERS => CR <= RAMout(3 DOWNTO 0);
              END CASE;
            WHEN "0110" => -- store out
              CASE IR(11 DOWNTO 9) IS
                WHEN "000" => OUTREG <= RA;
                WHEN "001" => OUTREG <= RB;
                WHEN "010" => OUTREG <= RC;
                WHEN "011" => OUTREG <= RD;
                WHEN "100" => OUTREG <= RE;
                WHEN "101" => OUTREG <= STD_LOGIC_VECTOR(SP);
                WHEN "110" => OUTREG <= STD_LOGIC_VECTOR("00000000" & PC);
                WHEN OTHERS => OUTREG <= IR;
              END CASE;
            WHEN "0111" => -- load in
              CASE IR(11 DOWNTO 9) IS
                WHEN "000" =>
                  IF iport(7) = '1' THEN
                    RA <= "11111111" & iport;
                  ELSE
                    RA <= "00000000" & iport;
                  END IF;
                WHEN "001" =>
                  IF iport(7) = '1' THEN
                    RB <= "11111111" & iport;
                  ELSE
                    RB <= "00000000" & iport;
                  END IF;
                WHEN "010" =>
                  IF iport(7) = '1' THEN
                    RC <= "11111111" & iport;
                  ELSE
                    RC <= "00000000" & iport;
                  END IF;
                WHEN "011" =>
                  IF iport(7) = '1' THEN
                    RD <= "11111111" & iport;
                  ELSE
                    RD <= "00000000" & iport;
                  END IF;
                WHEN "100" =>
                  IF iport(7) = '1' THEN
                    RE <= "11111111" & iport;
                  ELSE
                    RE <= "00000000" & iport;
                  END IF;
                WHEN "101" =>
                  IF iport(7) = '1' THEN
                    SP <= "11111111" & unsigned(iport);
                  ELSE
                    SP <= "00000000" & unsigned(iport);
                  END IF;
                WHEN OTHERS => NULL;
              END CASE;

            WHEN "1000" | "1001" | "1010" | "1011" | "1100" | "1101" | "1110" | "1111" => -- add, sub, and, or, xor, shift, rotate
              CASE IR(2 DOWNTO 0) IS
                WHEN "000" => RA <= STD_LOGIC_VECTOR(aluOUT);
                WHEN "001" => RB <= STD_LOGIC_VECTOR(aluOUT);
                WHEN "010" => RC <= STD_LOGIC_VECTOR(aluOUT);
                WHEN "011" => RD <= STD_LOGIC_VECTOR(aluOUT);
                WHEN "100" => RE <= STD_LOGIC_VECTOR(aluOUT);
                WHEN "101" => SP <= aluOUT;
                WHEN OTHERS => NULL;
              END CASE;
              CR <= aluCR;

            WHEN OTHERS =>
              NULL;
          END CASE;

          IF IR(15 DOWNTO 10) = "001110" THEN -- return
            state <= sExecuteReturn1;
          ELSE
            state <= sFetch;
          END IF;
        WHEN sExecuteReturn1 =>
          state <= sExecuteReturn2;
        WHEN sExecuteReturn2 =>
          state <= sFetch;
        WHEN OTHERS =>
          NULL;
      END CASE;
    END IF;
  END PROCESS;

  -- outputs
  oport <= OUTREG; -- output register to output port
  IRview <= IR;
  PCview <= STD_LOGIC_VECTOR(PC);
  RAview <= RA;
  RBview <= RB;
  RCview <= RC;
  RDview <= RD;
  REview <= RE;

  -- port maps
  ProgramROM_0 : ProgramROM PORT MAP(address => STD_LOGIC_VECTOR(PC), clock => clk, q => ROMout);
  DataRAM_0 : DataRAM PORT MAP(address => STD_LOGIC_VECTOR(MAR), clock => clk, data => MBR, wren => RAMwe, q => RAMout);
  alu_0 : alu PORT MAP(srcA => alusrcA, srcB => alusrcB, op => aluOP, cr => aluCR, dest => aluOUT);

  -- Extension 3: Board Output
END program;