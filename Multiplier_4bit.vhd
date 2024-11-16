-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 16 November 2024
-- Fungsi       : Melakukan perkalian dua angka 4-bit bertipe unsigned

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multiplier_4bit is
    Port ( A : in  unsigned(3 downto 0);
           B : in  unsigned(3 downto 0);
           PRODUCT : out unsigned(7 downto 0)); -- Hasil bisa 8 bit
end Multiplier_4bit;

architecture Behavioral of Multiplier_4bit is
begin
    PRODUCT <= A * B; -- Perkalian langsung menggunakan operator "*"
end Behavioral;
