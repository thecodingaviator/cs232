library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_tb is
end entity;

architecture sim of adder_tb is
    signal a, b  : UNSIGNED (3 downto 0);
    signal c, c_int : UNSIGNED (4 downto 0); -- to hold the result of the adder
    signal c_ext : UNSIGNED (3 downto 0); -- extended signal for the hex display
	 
	 signal disp0 : unsigned(6 downto 0);
    signal disp1 : unsigned(6 downto 0);
    
    component adder
        port
        (
            a : in UNSIGNED (3 downto 0);
            b : in UNSIGNED (3 downto 0);
            c : out UNSIGNED (4 downto 0)
        );
    end component;
    
    component hexdisplay
        port 
        (
            a       : in UNSIGNED (3 downto 0);
            segments: out UNSIGNED (6 downto 0)
        );
    end component;
	 
	 component task2 is
			port
			(
				a : in unsigned(3 downto 0);
				b : in unsigned(3 downto 0)
			);
	 end component;
    
begin
    uut: adder port map(a => a, b => b, c => c_int);
    c <= c_int; -- map the internal c to the output port c
    
    c_ext <= "000" & c_int(4);
    
    stim_proc: process
        variable va, vb : UNSIGNED (3 downto 0);
    begin
        for i in 0 to 15 loop
            for j in 0 to 15 loop
                va := to_unsigned(i, 4);
                vb := to_unsigned(j, 4);
                
                a <= va;
                b <= vb;
                wait for 100 ns;
            end loop;
        end loop;
        wait;
    end process stim_proc;
	 
		T0: task2 port map(a,b);
		T1: hexdisplay port map(c(3 downto 0), disp0);
		T2: hexdisplay port map(c_ext(3 downto 0), disp1);
		
end architecture sim;