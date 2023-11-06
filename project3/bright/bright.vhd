-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;

entity bright is

	port(
		clk		 : in	std_logic;
		buttonOne : in std_logic;
		buttonTwo : in std_logic;
		buttonThree : in std_logic;
		reset	 : in	std_logic;
		greenLed	 : out	std_logic_vector(3 downto 0)
	);

end entity;

architecture rtl of bright is

	-- Build an enumerated type for the state machine
	type state_type is (sIdle, sOne, sTwo, sThree);

	-- Register to hold the current state
	signal state   : state_type;

begin

    process (clk, reset)
    begin
        if reset = '0' then
            state <= sIdle;
        elsif (rising_edge(clk)) then
            case state is
                when sIdle=>
                    if buttonOne = '0' then
                        state <= sOne;
                    end if;
                when sOne=>
                    if buttonTwo = '0' then
                        state <= sTwo;
                    elsif buttonThree = '0' then
                        state <= sIdle;
                    end if;
                when sTwo=>
                    if buttonThree = '0' then
                        state <= sThree;
                    elsif buttonOne = '0' then
                        state <= sIdle;
                    end if;
                when sThree =>
                    if buttonOne = '0' or buttonTwo = '0' then
                        state <= sIdle;
                    end if;
            end case;
        end if;
    end process;

    process (state)
    begin
        case state is
            when sIdle =>
                greenLed <= "0001"; -- green LED 0 is active
            when sOne =>
                greenLed <= "0010"; -- green LED 1 is active
            when sTwo =>
                greenLed <= "0100"; -- green LED 2 is active
            when sThree =>
                greenLed <= "1000"; -- green LED 9 is active, assuming bit 0 represents green LED 9
        end case;
    end process;

end rtl;
