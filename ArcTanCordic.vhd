-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 6 Desember 2024
-- Fungsi       : Menghitung sudut arctan menggunakan algoritma CORDIC.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ArctanCordic is
    PORT (
        X_in      : IN signed(15 DOWNTO 0);  -- Input X (16-bit signed)
        Y_in      : IN signed(15 DOWNTO 0);  -- Input Y (16-bit signed)
        Theta_out : OUT signed(15 DOWNTO 0); -- Output angle (16-bit signed)
        clk       : IN STD_LOGIC            -- Clock signal
    );
end ArctanCordic;

architecture Behavioral of ArctanCordic is
    signal X, Y, X_new, Y_new : signed(15 DOWNTO 0);
    signal Theta : signed(15 DOWNTO 0);
    signal iter : integer := 0;
    signal LUT_value : signed(15 DOWNTO 0);

    component LUTArctan
        PORT (
            iterasi : IN unsigned(3 DOWNTO 0);
            HasilLUT : OUT signed(15 DOWNTO 0)
        );
    end component;

begin
    -- LUT Instance
    LUT: LUTArctan
        PORT MAP (
            iterasi => to_unsigned(iter, 4),
            HasilLUT => LUT_value
        );

    process (clk)
    begin
        if rising_edge(clk) then
            if iter < 16 then
                if Y < 0 then
                    -- Rotate counter-clockwise
                    X_new <= X - (Y srl iter);
                    Y_new <= Y + (X srl iter);
                    Theta <= Theta + LUT_value;
                else
                    -- Rotate clockwise
                    X_new <= X + (Y srl iter);
                    Y_new <= Y - (X srl iter);
                    Theta <= Theta - LUT_value;
                end if;

                -- Update X and Y for next iteration
                X <= X_new;
                Y <= Y_new;
                iter <= iter + 1;
            else
                -- Stop iterations
                Theta_out <= Theta;
            end if;
        end if;
    end process;

end Behavioral;
