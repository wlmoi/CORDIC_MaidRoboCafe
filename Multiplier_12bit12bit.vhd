entity Multiplier12bit12bit is
    PORT (
        A : IN  signed(11 DOWNTO 0);
        B : IN  signed(11 DOWNTO 0);
        P : OUT signed(23 DOWNTO 0) -- Hasil perkalian (24-bit signed)
    );
end Multiplier12bit12bit;

architecture Behavioral of Multiplier12bit12bit is
begin
    P <= A * B; -- Operasi perkalian langsung
end Behavioral;
