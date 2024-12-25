-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 16 November 2024
-- Fungsi       : Melakukan penjumlahan dua angka 4-bit bertipe unsigned

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Adder_4bit is
    Port ( A : in  unsigned(3 downto 0);
           B : in  unsigned(3 downto 0);
           SUM : out unsigned(3 downto 0));
end Adder_4bit;

architecture Behavioral of Adder_4bit is
begin
    SUM <= A + B; -- Penjumlahan langsung untuk 4-bit
end Behavioral;
