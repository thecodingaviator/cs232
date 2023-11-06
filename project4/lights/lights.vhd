-- Importing necessary libraries for VHDL design
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Entity declaration for 'lights'
entity lights is
    -- Defining the ports of the entity
    port ( clk : in  STD_LOGIC;                 -- Clock input
           reset : in  STD_LOGIC;               -- Reset input
           lightsig : out STD_LOGIC_VECTOR(7 downto 0); -- Output signal for lights
           IRView : out STD_LOGIC_VECTOR(2 downto 0)    -- Output signal for instruction register view
			  );
end lights;

-- Architecture definition for 'lights'
architecture rtl of lights is

	 -- State type declaration for FSM
    type state_type is (sFetch, sExecute);
    
    -- Internal signals declaration
    signal IR, ROMvalue : STD_LOGIC_VECTOR(2 downto 0);
    signal PC : unsigned(3 downto 0);           -- Program Counter
    signal LR : unsigned(7 downto 0);           -- Light Register
    signal slowclock : std_logic;               -- Clock signal to be generated
    signal counter: unsigned (26 downto 0);     -- Counter to generate slowclock
	 signal state: state_type;                  -- FSM state signal
    
    -- Component declaration for ROM
    component lightrom
        Port ( addr : in  STD_LOGIC_VECTOR(3 downto 0); -- Address input
               data : out STD_LOGIC_VECTOR(2 downto 0)  -- Data output
					);
    end component;

begin

    -- Process to generate slowclock using a counter
    process(clk, reset) 
    begin
        -- Asynchronous reset
        if reset = '0' then
            counter <= (others => '0');
        -- Count on every rising edge of clk
        elsif (rising_edge(clk)) then
            counter <= counter + 1;
        end if;
    end process;
	
    -- Generate slowclock from the MSB of the counter
    slowclock <= counter(26);

    -- Instance of ROM component
    ROM_instance : lightrom
        port map(addr => std_logic_vector(PC), data => ROMvalue);

    -- Process for FSM logic and operations
    process(clk, reset)
    begin
        -- Asynchronous reset
        if reset = '0' then
            PC <= "0000";
            IR <= "000";
            LR <= "00000000";
            state <= sFetch;
        -- FSM logic
        elsif rising_edge(clk) then
            -- Remain in the current state by default
            state <= state;
            case state is
                -- Fetch phase of FSM
                when sFetch =>
                    IR <= ROMvalue;         -- Load the instruction
                    PC <= PC + 1;           -- Increment program counter
                    state <= sExecute;      -- Transition to execute phase
                -- Execute phase of FSM
                when sExecute =>
                    -- Perform operations based on the instruction
                    case IR is
                        when "000" => LR <= "00000000";
                        when "001" => LR <= "0" & LR(7 downto 1);
                        when "010" => LR <= LR(6 downto 0) & "0";
                        when "011" => LR <= LR + 1;
                        when "100" => LR <= LR - 1;
                        when "101" => LR <= not LR;
                        when "110" => LR <= LR(0) & LR(7 downto 1);
                        when "111" => LR <= LR(6 downto 0) & LR(7);
                        when others => null;
                    end case;
                    -- Transition back to fetch phase
                    state <= sFetch;
            end case;
        end if;
    end process;

    -- Assigning output signals
    irview <= IR;
    lightsig <= std_logic_vector(LR);

end rtl;
