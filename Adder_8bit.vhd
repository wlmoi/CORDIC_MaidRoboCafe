-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 16 November 2024
-- Fungsi       : Melakukan penjumlahan dua angka 8-bit bertipe unsigned

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Adder_8bit is
    Port ( A : in  unsigned(7 downto 0);
           B : in  unsigned(7 downto 0);
           SUM : out unsigned(7 downto 0));
end Adder_8bit;

architecture Behavioral of Adder_8bit is
begin
    SUM <= A + B; -- Penjumlahan langsung menggunakan operator "+"
end Behavioral;
