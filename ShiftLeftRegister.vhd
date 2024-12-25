LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

entity ShiftRegister is
    PORT (
        D_in      : IN  signed(11 DOWNTO 0); -- Input data
        Shifted   : OUT signed(21 DOWNTO 0); -- Output data setelah pergeseran
        shift_amt : IN  unsigned(               -- Besar pergeseran (0-11)
    );
end ShiftRegister;

architecture Behavioral of ShiftRegister is
begin
    process(D_in, shift_amt)
    begin
        while shift_amt > 0 loop
        Shifted <= Shifted(10 DOWNTO 0) & Shifted(21 DOWNTO 11);
        shift_amt <= shift_amt - 1;
        end loop;
    end process;