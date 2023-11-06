library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pld2 is
  port(
    clk, reset : in std_logic;
    lights : out std_logic_vector(7 downto 0)
  );
end entity;

architecture FSM_arch of pld2 is
  -- Define states
  type state_type is (sFetch, sExecute1, sExecute2);
  signal state: state_type;

  signal IR: std_logic_vector(9 downto 0);
  signal ROMvalue: std_logic_vector(9 downto 0);
  signal PC: unsigned(3 downto 0);
  signal ACC, SRC: unsigned(7 downto 0);
  signal LR: unsigned(7 downto 0);

  -- Component declaration for ROM
  component pldrom is
    port(
      addr: in std_logic_vector(3 downto 0);
      data: out std_logic_vector(9 downto 0)
    );
  end component;

begin
  process(clk, reset)
  begin
    if reset = '0' then
      IR <= "0000000000";
      PC <= "0000";
      LR <= "00000000";
      state <= sFetch;
    elsif rising_edge(clk) then
      case state is
        when sFetch =>
          IR <= ROMvalue;
          PC <= PC + 1;
          state <= sExecute1;

        when sExecute1 =>
          case IR(9 downto 8) is
            when "00" => -- move 
              case IR(5 downto 4) is
                when "00" => SRC <= ACC;
                when "01" => SRC <= LR;
                when "10" =>
                  SRC <= (others => IR(3)); -- sign extend
                  SRC(2 downto 0) <= unsigned(IR(2 downto 0));
                when others => SRC <= "11111111";
              end case;

            when "01" => -- binary operation
              case IR(4 downto 3) is
                when "00" => SRC <= ACC;
                when "01" => SRC <= LR;
                when "10" =>
                  SRC <= (others => IR(1)); -- sign extend
                  SRC(0) <= IR(0); 
                when others => SRC <= "11111111";
              end case;

            when "10" => -- unconditional branch
              PC <= unsigned(IR(3 downto 0));

            when others => -- conditional branch
              if IR(7) = '0' then
                if ACC = "00000000" then
                  PC <= unsigned(IR(3 downto 0));
                end if;
              else
                if LR = "00000000" then
                  PC <= unsigned(IR(3 downto 0));
                end if;
              end if;
          end case;
          state <= sExecute2;

        when sExecute2 =>
          if IR(9 downto 8) = "00" then -- move
            case IR(7 downto 6) is
              when "00" => ACC <= SRC;
              when "01" => LR <= SRC;
              when "10" => ACC(3 downto 0) <= SRC(3 downto 0);
              when others => ACC(7 downto 4) <= SRC(3 downto 0);
            end case;
          elsif IR(9 downto 8) = "01" then -- binary operation
						case IR(7 downto 5) is
              when "000" => -- add
                if IR(2) = '1' then
                  LR <= LR + SRC;
                else
                  ACC <= ACC + SRC;
                end if;
              when "001" => -- sub 
                if IR(2) = '1' then
                  LR <= LR - SRC;
                else
                  ACC <= ACC - SRC;
                end if;
              when "010" => -- shift left
                if IR(2) = '1' then
                  LR <= LR(6 downto 0) & '0';
                else
                  ACC <= ACC(6 downto 0) & '0';
                end if;
              when "011" => -- shift right maintain sign
                if IR(2) = '1' then
                  LR <= LR(7) & LR(7 downto 1);
                else
                  ACC <= ACC(7)& ACC(7 downto 1);
                end if;
              when "100" => -- xor
                if IR(2) = '1' then
                  LR <= LR xor SRC;
                else
                  ACC <= ACC xor SRC;
                end if;
              when "101" => -- and
                if IR(2) = '1' then
                  LR <= LR and SRC;
                else
                  ACC <= ACC and SRC;
                end if;
              when "110" => -- rotate left
                if IR(2) = '1' then
                  LR <= LR(6 downto 0) & LR(7);
                else
                  ACC <= ACC(6 downto 0) & ACC(7);
                end if;
              when others => -- rotate right
                if IR(2) = '1' then
                  LR <= LR(0) & LR(7 downto 1);
                else
                  ACC <= ACC(0) & ACC(7 downto 1);
                end if;
                --end case;
            end case;
          end if;
          state <= sFetch;
      end case;
    end if;
  end process;

  -- Output Lights Handling
  lights <= std_logic_vector(LR);
  
  ROM_Instance: pldrom port map(
    addr => std_logic_vector(PC),
    data => ROMvalue
  );

end FSM_arch;
