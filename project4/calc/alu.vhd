-- ALU VHDL file: alu.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port 
    (
        d      : in unsigned  (3 downto 0);
        e      : in unsigned  (3 downto 0);
        f      : in std_logic_vector (1 downto 0);
        q      : out unsigned (4 downto 0)
    );
end entity alu;

architecture rtl of alu is
begin
    process (d, e, f)
    begin
        case f is
            when "00" => 
                q <= ('0' & d) + ('0' & e); -- Sum

            when "01" => 
                q <= ('0' & d) - ('0' & e); -- Difference

            when "10" => 
                q <= ('0' & d) and ('0' & e); -- Bitwise AND

            when others => 
                q <= ('0' & d) or ('0' & e);  -- Bitwise OR
        end case;
    end process;
end rtl;
