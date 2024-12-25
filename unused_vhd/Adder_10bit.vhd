-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 16 November 2024
-- Fungsi       : Melakukan penjumlahan dua angka 8-bit bertipe unsigned

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Adder_10bit is
    Port ( A : in  unsigned(9 downto 0);
           B : in  unsigned(9 downto 0);
           SUM : out unsigned(9 downto 0));
end Adder_10bit;

architecture Behavioral of Adder_10bit is
begin
    SUM <= A + B; -- Penjumlahan langsung menggunakan operator "+"
end Behavioral;
