-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 23 November 2024
-- Fungsi       : Memperoleh hasil TAN

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Top-level Entity
entity Tan is
    Port (
        X0      : in STD_LOGIC_VECTOR(9 downto 0); -- Input X awal (10-bit)
        Y0      : in STD_LOGIC_VECTOR(9 downto 0); -- Input Y awal (10-bit)
        XI      : in STD_LOGIC_VECTOR(9 downto 0); -- Input X tujuan (10-bit)
        YI      : in STD_LOGIC_VECTOR(9 downto 0); -- Input Y tujuan (10-bit)
        OUTPUT  : out STD_LOGIC_VECTOR(11 downto 0) -- Output 12-bit
    );
end Tan;

architecture Behavioral of Tan is
    -- Internal signals for subtraction
    signal Sub_X : STD_LOGIC_VECTOR(9 downto 0); -- Result of X subtraction (10-bit)
    signal Sub_Y : STD_LOGIC_VECTOR(9 downto 0); -- Result of Y subtraction (10-bit)
    signal Delta_X : signed(11 downto 0); -- Extended X subtraction result (12-bit)
    signal Delta_Y : signed(11 downto 0); -- Extended Y subtraction result (12-bit)
    signal Quotient : STD_LOGIC_VECTOR(11 downto 0); -- Result from Divisor12Bit component

    component Subtraktor_10Bit is
        Port (
            A : in STD_LOGIC_VECTOR(9 downto 0); -- Minuend (10-bit)
            B : in STD_LOGIC_VECTOR(9 downto 0); -- Subtrahend (10-bit)
            R : out STD_LOGIC_VECTOR(9 downto 0) -- Result (10-bit)
        );
    end component;

    -- Component Declaration for Divisor12Bit
    component Divisor12Bit is
        Port (
            Dividend : in signed(11 downto 0);
            Divisor  : in signed(11 downto 0);
            Quotient : out STD_LOGIC_VECTOR(11 downto 0)
        );
    end component;
begin
    -- Subtraction for X and Y using Subtractor10Bit
    U1: Subtraktor_10Bit
        Port map (
            A => XI,    -- Input X tujuan
            B => X0,    -- Input X awal
            R => Sub_X  -- Hasil pengurangan X
        );

    U2: Subtraktor_10Bit
        Port map (
            A => YI,    -- Input Y tujuan
            B => Y0,    -- Input Y awal
            R => Sub_Y  -- Hasil pengurangan Y
        );

    -- Tambahkan padding "00" (shift left 2-bit) untuk hasil pengurangan
    Delta_X <= signed(Sub_X & "00"); -- Extend Sub_X to 12-bit
    Delta_Y <= signed(Sub_Y & "00"); -- Extend Sub_Y to 12-bit

    -- Memetakan komponen Divisor12Bit
    U3: Divisor12Bit
        Port map (
            Dividend => Delta_X,    -- Delta_X sebagai dividend
            Divisor  => Delta_Y,    -- Delta_Y sebagai divisor
            Quotient => Quotient    -- Hasil keluar ke Quotient
        );

    -- OUTPUT dihubungkan ke Quotient
    OUTPUT <= Quotient;
end Behavioral;
