
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

entity LUTArctan is
PORT (
    iterasi : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    HasilLUT : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
emd LUTArctan;


ARCHITECTURE Behavioral OF LUTArctan IS
    BEGIN
    PROCESS (iterasi)
    BEGIN
    CASE iterasi IS
        WHEN "0001" => --1
            HasilLUT <= "0001011010000000"; -- 0.7853981634
        WHEN "0010" => --2
            HasilLUT <= "0000110101001000"; -- 0.463647609
        WHEN "0011" => --3
            HasilLUT <= "0000011100000100"; -- 0.2449786631
        WHEN "0100" => --4
            HasilLUT <= "0000001110010000"; -- 0.1243549945
        WHEN "0101" => --5
            HasilLUT <= "0000000111001001"; -- 0.06241881
        WHEN "0110" => --6
            HasilLUT <= "0000000011100101"; -- 0.03123983343
        WHEN "0111" => --7
            HasilLUT <= "0000000001110010"; -- 0.01562372862
        WHEN "1000" => --8
            HasilLUT <= "0000000000111001"; -- 0.00781234106
        WHEN "1001" => --9
           HasilLUT <= "0000000000011100"; -- 0.003906230132
        WHEN "1010" => --10
            HasilLUT <= "0000000000001110"; -- 0.001953122516
        WHEN OTHERS => -- >10
            HasilLUT <= "0000000000000000";
        END CASE;
    END PROCESS;
END Behavioral;