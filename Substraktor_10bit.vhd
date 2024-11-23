-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 16 November 2024
-- Fungsi       : Melakukan pengurangan dua angka 10-bit bertipe unsigned

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Substraktor_10bit is
    Port ( A : in  unsigned(9 downto 0);
           B : in  unsigned(9 downto 0);
           R : out unsigned(9 downto 0));
end Substraktor_10bit;

architecture Behavioral of Substraktor_10bit is
begin
    R <= A - B; -- Pengurangan langsung menggunakan operator "-"
end Behavioral;
