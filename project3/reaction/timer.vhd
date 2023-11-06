library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    port (
        clk : in std_logic;
        reset : in std_logic;
        start : in std_logic;
        react : in std_logic;
        cycles : out std_logic_vector(7 downto 0);
        leds : out std_logic_vector(2 downto 0);
        curstate: out std_logic_vector(1 downto 0)
    );
end entity timer;

architecture rtl of timer is
    type state_type is (sIdle, sWait, sCount);

    signal count: unsigned(7 downto 0) := (others => '0');
    signal internal_state: state_type := sIdle;

begin
    process (clk, reset)
    begin
        if reset = '0' then
            count <= (others => '0');
            internal_state <= sIdle;
        elsif (rising_edge(clk)) then
            case internal_state is
                when sIdle =>
                    if start = '0' then
                        internal_state <= sWait;
                    end if;
                when sWait =>
                    if react = '0' then
                        count <= (others => '1');
                        internal_state <= sIdle;
                    elsif count = "00000011" then
                        count <= (others => '0');
                        internal_state <= sCount;
                    else
                        count <= count + 1;
                        internal_state <= sWait;
                    end if;
                when sCount =>
                    if react = '0' then
                        internal_state <= sIdle;
                    else
                        count <= count + 1;
                        internal_state <= sCount;
                    end if;
            end case;
        end if;

        case internal_state is
            when sIdle =>
                leds <= "100";
                cycles <= std_logic_vector(count(7 downto 0));
                curstate <= "00";
            when sWait =>
                leds <= "010";
                cycles <= "00000000";
                curstate <= "01";
            when sCount =>
                if react = '0' then
                    internal_state <= sIdle;
                else
                    count <= count + 1;
                end if;
                leds <= "001";
                cycles <= std_logic_vector(count(7 downto 0));
                curstate <= "10";
        end case;
    end process;
end rtl;
