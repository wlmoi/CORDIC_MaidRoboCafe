library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bcd_to_biner is
    Port ( bcd : in  STD_LOGIC_VECTOR (15 downto 0);
           bin : out  STD_LOGIC_VECTOR (9 downto 0));
end bcd_to_biner;

architecture Behavioral of bcd_to_biner is
begin
    process(bcd)
        variable temp_bin : INTEGER := 0;
    begin
        temp_bin := (to_integer(unsigned(bcd(15 downto 12))) * 1000) +
                    (to_integer(unsigned(bcd(11 downto 8))) * 100) +
                    (to_integer(unsigned(bcd(7 downto 4))) * 10) +
                    to_integer(unsigned(bcd(3 downto 0)));
        bin <= std_logic_vector(to_unsigned(temp_bin, 10));
    end process;
end Behavioral;