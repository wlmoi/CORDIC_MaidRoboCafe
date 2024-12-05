-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 16 November 2024
-- Fungsi       : Testbench untuk Subtraktor_10bit

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity tb_Subtraktor_10bit is
end tb_Subtraktor_10bit;

architecture Behavioral of tb_Subtraktor_10bit is
    component Subtraktor_10bit
        PORT (
            A : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            R : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
    end component;

    signal A, B : STD_LOGIC_VECTOR(9 DOWNTO 0);
    signal R : STD_LOGIC_VECTOR(9 DOWNTO 0);

begin
    -- Instantiate Subtraktor_10bit
    DUT: Subtraktor_10bit
        PORT MAP (
            A => A,
            B => B,
            R => R
        );

    -- Test process
    process
    begin
        -- Test case 1: 100 - 50
        A <= "0001100100"; -- 100
        B <= "0000110010"; -- 50
        wait for 10 ns;

        -- Test case 2: -100 - 50
        A <= "1110011000"; -- -100
        B <= "0000110010"; -- 50
        wait for 10 ns;

        -- Test case 3: 50 - (-50)
        A <= "0000110010"; -- 50
        B <= "1111001110"; -- -50
        wait for 10 ns;

        wait;
    end process;
end Behavioral;
