library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TanArcTan1 is
    Port (
        X0      : in STD_LOGIC_VECTOR(9 downto 0); -- Input X awal (10-bit)
        Y0      : in STD_LOGIC_VECTOR(9 downto 0); -- Input Y awal (10-bit)
        XI      : in STD_LOGIC_VECTOR(9 downto 0); -- Input X tujuan (10-bit)
        YI      : in STD_LOGIC_VECTOR(9 downto 0); -- Input Y tujuan (10-bit)
        OUTPUT_THETA : out STD_LOGIC_VECTOR(15 downto 0) -- Output combined TAN (8-bit) and ARCTAN (8-bit)
    );
end TanArcTan1;

architecture Behavioral of TanArcTan1 is
    -- Signals for TAN calculation
    signal Sub_X, Sub_Y : STD_LOGIC_VECTOR(9 downto 0);
    signal Delta_X, Delta_Y : signed(11 downto 0);
    signal Tan_Result : STD_LOGIC_VECTOR(7 downto 0);

    -- Signals for LUTArctan
    signal Iter : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    signal LUT_Result : STD_LOGIC_VECTOR(15 downto 0);

    -- Internal components
    component Subtraktor_10Bit is
        Port (
            A : in STD_LOGIC_VECTOR(9 downto 0);
            B : in STD_LOGIC_VECTOR(9 downto 0);
            R : out STD_LOGIC_VECTOR(9 downto 0)
        );
    end component;

    component Divisor12Bit is
        Port (
            Dividend : in signed(11 downto 0);
            Divisor  : in signed(11 downto 0);
            Quotient : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component LUTArctan is
        Port (
            iterasi : in STD_LOGIC_VECTOR(3 downto 0);
            HasilLUT : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

begin
    -- Subtraction for TAN calculation
    U1: Subtraktor_10Bit
        Port map (
            A => XI,
            B => X0,
            R => Sub_X
        );

    U2: Subtraktor_10Bit
        Port map (
            A => YI,
            B => Y0,
            R => Sub_Y
        );

    -- Shift for 12-bit representation
    Delta_X <= signed(Sub_X & "00");
    Delta_Y <= signed(Sub_Y & "00");

    -- Division for TAN calculation
    U3: Divisor12Bit
        Port map (
            Dividend => Delta_X,
            Divisor  => Delta_Y,
            Quotient => Tan_Result
        );

    -- LUT-based ARCTAN calculation
    U4: LUTArctan
        Port map (
            iterasi => Iter,
            HasilLUT => LUT_Result
        );

    -- Combine TAN and ARCTAN results
    OUTPUT_THETA <= Tan_Result & LUT_Result(7 downto 0);

end Behavioral;
