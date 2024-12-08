LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

entity LUTArctan is
    PORT (
        iterasi : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        HasilLUT : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
end LUTArctan;

architecture Behavioral of LUTArctan is
begin
    process (iterasi)
    begin
        CASE iterasi IS
            when "0000" => -- Iterasi 0
                HasilLUT <= "0010000000000000"; -- 1.0 rad
            when "0001" => -- Iterasi 1
                HasilLUT <= "0001011010000000"; -- 0.7853981634
            when "0010" => -- Iterasi 2
                HasilLUT <= "0000110101001000"; -- 0.463647609
            when "0011" => -- Iterasi 3
                HasilLUT <= "0000011100000100"; -- 0.2449786631
            when "0100" => -- Iterasi 4
                HasilLUT <= "0000001110010000"; -- 0.1243549945
            when "0101" => -- Iterasi 5
                HasilLUT <= "0000000111001001"; -- 0.06241881
            when "0110" => -- Iterasi 6
                HasilLUT <= "0000000011100101"; -- 0.03123983343
            when "0111" => -- Iterasi 7
                HasilLUT <= "0000000001110010"; -- 0.01562372862
            when "1000" => -- Iterasi 8
                HasilLUT <= "0000000000111001"; -- 0.00781234106
            when "1001" => -- Iterasi 9
                HasilLUT <= "0000000000011100"; -- 0.003906230132
            when "1010" => -- Iterasi 10
                HasilLUT <= "0000000000001110"; -- 0.001953122516
            when "1011" => -- Iterasi 11
                HasilLUT <= "0000000000000111"; -- 0.00097656219
            when "1100" => -- Iterasi 12
                HasilLUT <= "0000000000000011"; -- 0.00048828125
            when "1101" => -- Iterasi 13
                HasilLUT <= "0000000000000010"; -- 0.000244140625
            when "1110" => -- Iterasi 14
                HasilLUT <= "0000000000000001"; -- 0.000122070313
            when "1111" => -- Iterasi 15
                HasilLUT <= "0000000000000000"; -- 0.00006103515625
            when OTHERS =>
                HasilLUT <= "0000000000000000"; -- Default
        end CASE;
    end PROCESS;
end Behavioral;
