-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 16 November 2024
-- Fungsi       : Testbench untuk ArctanCordic

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity tb_ArctanCordic is
end tb_ArctanCordic;

architecture Behavioral of tb_ArctanCordic is
    component ArctanCordic
        PORT (
            X_in      : IN signed(11 DOWNTO 0);
            Y_in      : IN signed(11 DOWNTO 0);
            Theta_out : OUT signed(17 DOWNTO 0);
            clk       : IN STD_LOGIC
        );
    end component;

    signal X_in, Y_in : signed(11 DOWNTO 0);
    signal Theta_out : signed(17 DOWNTO 0);
    signal clk : STD_LOGIC := '0';

    constant clk_period : time := 10 ns;

begin
    -- Instantiate ArctanCordic
    DUT: ArctanCordic
        PORT MAP (
            X_in => X_in,
            Y_in => Y_in,
            Theta_out => Theta_out,
            clk => clk
        );

    -- Clock generation
    clk_process: process
    begin
        while True loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Test process
    process
    begin
        -- Test case 1: arctan(1)
        X_in <= to_signed(1, 12);
        Y_in <= to_signed(1, 12);
        wait for 200 ns;

        -- Test case 2: arctan(0.5)
        X_in <= to_signed(2, 12);
        Y_in <= to_signed(1, 12);
        wait for 200 ns;

        -- Test case 3: arctan(-1)
        X_in <= to_signed(-1, 12);
        Y_in <= to_signed(1, 12);
        wait for 200 ns;

        wait;
    end process;
end Behavioral;
