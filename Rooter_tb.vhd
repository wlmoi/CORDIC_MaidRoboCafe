-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 16 November 2024
-- Fungsi       : Testbench untuk Rooter

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity tb_Rooter is
end tb_Rooter;

architecture Behavioral of tb_Rooter is
    component Rooter
        PORT (
            InVal : IN signed(23 DOWNTO 0);
            Root : OUT signed(11 DOWNTO 0)
        );
    end component;

    signal InVal : signed(23 DOWNTO 0);
    signal Root : signed(11 DOWNTO 0);

begin
    -- Instantiate Rooter
    DUT: Rooter
        PORT MAP (
            InVal => InVal,
            Root => Root
        );

    -- Test process
    process
    begin
        -- Test case 1: √(144)
        InVal <= to_signed(144, 24);
        wait for 10 ns;

        -- Test case 2: √(1024)
        InVal <= to_signed(1024, 24);
        wait for 10 ns;

        -- Test case 3: √(65536)
        InVal <= to_signed(65536, 24);
        wait for 10 ns;

        wait;
    end process;
end Behavioral;
