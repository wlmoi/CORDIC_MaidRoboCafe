-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 8 Desember 2024
-- Fungsi       : Menggeser nilai signed 12-bit ke kanan sebanyak shift_amt bit.

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

entity ShiftRegister is
    PORT (
        D_in      : IN  signed(11 DOWNTO 0); -- Input data
        Shifted   : OUT signed(11 DOWNTO 0); -- Output data setelah pergeseran
        shift_amt : IN  integer               -- Besar pergeseran (0-11)
    );
end ShiftRegister;

architecture Behavioral of ShiftRegister is
begin
    process(D_in, shift_amt)
    begin
        -- Geser nilai ke kanan sebanyak shift_amt
        if shift_amt >= 0 and shift_amt <= 11 then
            -- Perbaiki penggunaan slicing untuk tipe signed
            Shifted <= resize(D_in(11 DOWNTO shift_amt) & (others => '0'), 12);
        else
            Shifted <= D_in; -- Jika shift_amt tidak valid, keluarkan nilai asli
        end if;
    end process;
end Behavioral;
