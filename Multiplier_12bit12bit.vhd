-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 8 Desember 2024
-- Fungsi       : Melakukan perkalian dua bilangan 12-bit bertipe signed 
--                dan menghasilkan output 24-bit signed.

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL; -- Pustaka untuk mendukung tipe signed

entity Multiplier12bit12bit is
    PORT (
        A : IN  signed(11 DOWNTO 0); -- Input bilangan pertama (12-bit signed)
        B : IN  signed(11 DOWNTO 0); -- Input bilangan kedua (12-bit signed)
        P : OUT signed(23 DOWNTO 0)  -- Output hasil perkalian (24-bit signed)
    );
end Multiplier12bit12bit;

architecture Behavioral of Multiplier12bit12bit is
    -- Sinyal internal untuk menampung versi diperpanjang dari A dan B
    signal A_extended : signed(23 DOWNTO 0); -- A diperluas menjadi 24 bit
    signal B_extended : signed(23 DOWNTO 0); -- B diperluas menjadi 24 bit
begin
    -- Proses utama
    process(A, B)
    begin
        -- Tambahkan nol di awal agar panjang A dan B menjadi 24 bit
        A_extended <= signed("000000000000" & A); -- Tambah 12 nol di awal
        B_extended <= signed("000000000000" & B); -- Tambah 12 nol di awal

        -- Operasi perkalian
        P <= A_extended * B_extended;
    end process;
end Behavioral;
