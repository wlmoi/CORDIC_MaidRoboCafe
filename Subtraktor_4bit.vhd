-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 16 November 2024
-- Fungsi       : Melakukan pengurangan dua angka 4-bit bertipe unsigned

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Substraktor_4bit is
    Port ( A : in  unsigned(3 downto 0);
           B : in  unsigned(3 downto 0);
           DIFF : out unsigned(3 downto 0));
end Substraktor_4bit;

architecture Behavioral of Substraktor_4bit is
begin
    DIFF <= A - B; -- Pengurangan langsung untuk 4-bit
end Behavioral;
