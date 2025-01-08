library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity fixConverter is
    port(
        
        i_fix : in unsigned(14 downto 0);
        A_out : out unsigned(9 downto 0)
    );
end entity fixConverter;

architecture behavioral of fixConverter is 
    signal A : unsigned(24 downto 0) := (others => '0');
    begin
        A <= i_fix * ("1111101000");
        A_out <= A(24 downto 15) + "0000000001";
end architecture behavioral;

