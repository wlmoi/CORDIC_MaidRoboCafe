library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TanArcTan_tb is
end TanArcTan_tb;

architecture Behavioral of TanArcTan_tb is
    -- Component Declaration
    component TanArcTan is
        Port (
            X0      : in STD_LOGIC_VECTOR(9 downto 0);
            Y0      : in STD_LOGIC_VECTOR(9 downto 0);
            XI      : in STD_LOGIC_VECTOR(9 downto 0);
            YI      : in STD_LOGIC_VECTOR(9 downto 0);
            OUTPUT_THETA : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    -- Signals for test
    signal X0_tb, Y0_tb, XI_tb, YI_tb : STD_LOGIC_VECTOR(9 downto 0);
    signal OUTPUT_THETA_tb : STD_LOGIC_VECTOR(15 downto 0);

begin
    -- Instantiate the Unit Under Test (UUT)
    UUT: TanArcTan
        Port map (
            X0 => X0_tb,
            Y0 => Y0_tb,
            XI => XI_tb,
            YI => YI_tb,
            OUTPUT_THETA => OUTPUT_THETA_tb
        );

    -- Test Process
    process
    begin
        -- Test Case 1: Horizontal line
        X0_tb <= "0000001100"; -- 12
        Y0_tb <= "0000000000"; -- 0
        XI_tb <= "0000011000"; -- 24
        YI_tb <= "0000000000"; -- 0
        wait for 20 ns;

        -- Test Case 2: Diagonal line
        X0_tb <= "0000000100"; -- 4
        Y0_tb <= "0000000100"; -- 4
        XI_tb <= "0000001100"; -- 12
        YI_tb <= "0000001100"; -- 12
        wait for 20 ns;

        -- Test Case 3: Vertical line
        X0_tb <= "0000000000"; -- 0
        Y0_tb <= "0000001100"; -- 12
        XI_tb <= "0000000000"; -- 0
        YI_tb <= "0000011000"; -- 24
        wait for 20 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;
