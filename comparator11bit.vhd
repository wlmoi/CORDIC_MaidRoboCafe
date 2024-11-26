library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Comparator11bit is
    Port ( A : in  unsigned(10 downto 0);
           B : in  unsigned(10 downto 0);
           RESULT : out std_logic);  -- Sinyal HIGH jika A < B
end Comparator11bit;

architecture Behavioral of comparator11bit is
begin
    -- Menggunakan operator logika
     -- HIGH jika A lebih besar
    RESULT <= '0' when A < B else '1'; -- A >= B
end Behavioral;
