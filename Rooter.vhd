-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 5 Desember 2024
-- Fungsi       : Menghitung akar kuadrat dari bilangan 24-bit bertipe signed.

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

entity Rooter is
    PORT (
        InVal : IN signed(23 DOWNTO 0); -- Input bilangan kuadrat (24-bit signed)
        Root : OUT signed(11 DOWNTO 0) -- Output akar kuadrat (12-bit signed)
    );
end Rooter;

architecture Behavioral of Rooter is
    signal Temp : signed(11 DOWNTO 0) := (OTHERS => '0');
    signal i : integer := 0;
begin
    process(InVal)
    begin
        Temp <= (OTHERS => '0');
        -- Algoritma iteratif untuk menghitung akar kuadrat
        for i in 11 DOWNTO 0 loop
            if (Temp + (1 sll i)) * (Temp + (1 sll i)) <= InVal then
                Temp <= Temp + (1 sll i);
            end if;
        end loop;
        Root <= Temp; -- Hasil akhir akar kuadrat
    end process;
end Behavioral;
