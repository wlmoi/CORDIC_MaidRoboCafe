-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 16 November 2024
-- Fungsi       : Membandingkan dua angka 4-bit bertipe unsigned untuk menentukan:
--                apakah mereka sama, A lebih besar, atau B lebih besar

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ComparatorJelas_4bit is
    Port ( A : in  unsigned(3 downto 0);
           B : in  unsigned(3 downto 0);
           EQUAL : out std_logic;  -- Sinyal HIGH jika A = B
           GREATER : out std_logic; -- Sinyal HIGH jika A > B
           LESS : out std_logic);  -- Sinyal HIGH jika A < B
end ComparatorJelas_4bit;

architecture Behavioral of ComparatorJelas_4bit is
begin
    -- Menggunakan operator logika
    EQUAL <= '1' when A = B else '0'; -- HIGH jika A sama dengan B
    GREATER <= '1' when A > B else '0'; -- HIGH jika A lebih besar
    LESS <= '1' when A < B else '0'; -- HIGH jika A lebih kecil
end Behavioral;
