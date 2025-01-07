LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY fixtobinary IS
    PORT(
        clk : IN STD_LOGIC;
        FIX : IN UNSIGNED(9 DOWNTO 0); 
        start : IN STD_LOGIC;
        DONE : OUT STD_LOGIC;
        A_OUT : OUT UNSIGNED(9 DOWNTO 0) := (OTHERS => '0')
    );
END fixtobinary;

ARCHITECTURE fixtobinary OF fixtobinary IS
    SIGNAL A : UNSIGNED(9 DOWNTO 0) := (OTHERS => '0');
    SIGNAL counter : UNSIGNED(3 DOWNTO 0) := "0000";
    SIGNAL state : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    TYPE array_of_lut IS ARRAY(0 TO 9) OF UNSIGNED(8 DOWNTO 0);
    CONSTANT lut_fix : array_of_lut := (
        "000000001", -- 1
        "000000010", -- 2
        "000000100", -- 4
        "000001000", -- 8
        "000010000", -- 16
        "000011111", -- 31
        "000111111", -- 63
        "001111101", -- 125
        "011111010", -- 250
        "111110100"  -- 500
    );
    
BEGIN 
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            CASE state IS
                WHEN "00" => -- idle
                    if start = '1' then
                        DONE <= '0';
                        A <= (OTHERS => '0');
                        counter <= "0000";
                        state <= "01";
                    END IF;
                
                WHEN "01" => -- processing
                    IF FIX(to_integer(counter)) = '1' THEN
                        A <= A + lut_fix(to_integer(counter));
                    END IF;
                    IF counter = "1001" THEN
                        state <= "10";
                    ELSE
                        counter <= counter + 1;
                    END IF;

                WHEN "10" => -- done
                    DONE <= '1';
                    state <= "00";
                    

                WHEN OTHERS =>
                    state <= "00";
            END CASE;
        END IF;
    END PROCESS;
    A_OUT <= A;
END fixtobinary;
