-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 6 Desember 2024
-- Fungsi       : Menghitung sudut arctan menggunakan algoritma CORDIC.

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

entity ArctanCordic is
    PORT (
        X_in      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Y_in      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Theta_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        clk       : IN STD_LOGIC
    );
end ArctanCordic;

architecture Behavioral of ArctanCordic is
    signal X, Y, X_new, Y_new : signed(15 DOWNTO 0);
    signal Theta : signed(15 DOWNTO 0);
    signal iter : integer := 0;
    signal LUT_value : STD_LOGIC_VECTOR(15 DOWNTO 0);

    component LUTArctan
        PORT (
            iterasi : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            HasilLUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    end component;

begin
    -- LUT Instance
    LUT: LUTArctan
        PORT MAP (
            iterasi => std_logic_vector(to_unsigned(iter, 4)),
            HasilLUT => LUT_value
        );

    process (clk)
    begin
        if rising_edge(clk) then
            if iter < 16 then
                if Y < X then
                    -- Rotate counter-clockwise
                    X_new <= X - (Y srl iter);
                    Y_new <= Y + (X srl iter);
                    Theta <= Theta + signed(LUT_value);
                else
                    -- Rotate clockwise
                    X_new <= X + (Y srl iter);
                    Y_new <= Y - (X srl iter);
                    Theta <= Theta - signed(LUT_value);
                end if;

                -- Update X and Y for next iteration
                X <= X_new;
                Y <= Y_new;
                iter <= iter + 1;
            else
                -- Stop iterations
                Theta_out <= std_logic_vector(Theta);
            end if;
        end if;
    end process;
end Behavioral;
