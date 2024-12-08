

entity ShiftRegister is
    PORT (
        D_in : IN  signed(11 DOWNTO 0);
        Shifted : OUT signed(11 DOWNTO 0);
        shift_amt : IN  integer -- Besar pergeseran
    );
end ShiftRegister;

architecture Behavioral of ShiftRegister is
begin
    Shifted <= D_in / (2 ** shift_amt); -- Pergeseran dilakukan dengan pembagian
end Behavioral;
