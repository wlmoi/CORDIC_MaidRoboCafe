LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

entity tb_Multiplier12bit12bit is
end tb_Multiplier12bit12bit;

architecture Behavioral of tb_Multiplier12bit12bit is
    component Multiplier12bit12bit
        PORT (
            A : IN  signed(11 DOWNTO 0);
            B : IN  signed(11 DOWNTO 0);
            P : OUT signed(23 DOWNTO 0)
        );
    end component;

    signal A : signed(11 DOWNTO 0);
    signal B : signed(11 DOWNTO 0);
    signal P : signed(23 DOWNTO 0);

begin
    -- Instansiasi modul Multiplier12bit12bit
    DUT: Multiplier12bit12bit
        PORT MAP (
            A => A,
            B => B,
            P => P
        );

    -- Proses pengujian
    process
    begin
        -- Test case 1
        A <= to_signed(5, 12);
        B <= to_signed(3, 12);
        wait for 10 ns;

        -- Test case 2
        A <= to_signed(-4, 12);
        B <= to_signed(2, 12);
        wait for 10 ns;

        -- Test case 3
        A <= to_signed(10, 12);
        B <= to_signed(-1, 12);
        wait for 10 ns;

        wait;
    end process;
end Behavioral;
