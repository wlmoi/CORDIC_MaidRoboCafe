-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 16 November 2024
-- Fungsi       : Melakukan pengurangan dua angka 8-bit bertipe unsigned

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Substraktor_8bit is
    Port ( A : in  unsigned(7 downto 0);
           B : in  unsigned(7 downto 0);
           DIFF : out unsigned(7 downto 0));
end Substraktor_8bit;

architecture Behavioral of Substraktor_8bit is
begin
    DIFF <= A - B; -- Pengurangan langsung menggunakan operator "-"
end Behavioral;
