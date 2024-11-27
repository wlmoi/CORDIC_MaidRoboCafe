-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 27 November 2024
-- Fungsi       : Memperoleh hasil TAN dan ARCTAN dengan OUTPUT_THETA

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TanArcTan is
    Port (
        X0      : in STD_LOGIC_VECTOR(9 downto 0); -- Input X awal (10-bit)
        Y0      : in STD_LOGIC_VECTOR(9 downto 0); -- Input Y awal (10-bit)
        XI      : in STD_LOGIC_VECTOR(9 downto 0); -- Input X tujuan (10-bit)
        YI      : in STD_LOGIC_VECTOR(9 downto 0); -- Input Y tujuan (10-bit)
        OUTPUT_THETA : out STD_LOGIC_VECTOR(15 downto 0) -- Output combined TAN (8-bit) and ARCTAN (8-bit)
    );
end TanArcTan;

architecture Behavioral of TanArcTan is
    -- Signals for TAN calculation
    signal Sub_X, Sub_Y : STD_LOGIC_VECTOR(9 downto 0); -- 10-bit subtractions
    signal Delta_X, Delta_Y : signed(11 downto 0);      -- 12-bit signed values
    signal Tan_Result : STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit TAN result

    -- Signals for ARCTAN calculation
    signal X_reg, Y_reg : signed(15 downto 0) := (others => '0');
    signal Z_reg : signed(15 downto 0) := (others => '0');
    signal Iter : integer range 0 to 7 := 0; -- Limited to 8 iterations for 8-bit accuracy
    signal ArcTan_Result : STD_LOGIC_VECTOR(7 downto 0); -- 8-bit ARCTAN result

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

    -- CORDIC ARCTAN Calculation
    process (X0, Y0)
    begin
        -- Initialize registers
        X_reg <= signed(X0 & "000000"); -- Extend ke 16 bits
        Y_reg <= signed(Y0 & "000000");
        Z_reg <= (others => '0');
        Iter <= 0;

        -- Iterative CORDIC
        while Iter < 8 loop
            if Y_reg < 0 then
                X_reg <= X_reg + (Y_reg srl Iter);
                Y_reg <= Y_reg - (X_reg srl Iter);
                Z_reg <= Z_reg - to_signed(45 / (2 ** Iter), 16); 
            else
                X_reg <= X_reg - (Y_reg srl Iter);
                Y_reg <= Y_reg + (X_reg srl Iter);
                Z_reg <= Z_reg + to_signed(45 / (2 ** Iter), 16);
            end if;

            -- Increment iteration
            Iter <= Iter + 1;
        end loop;

        -- Assign final ARCTAN result
        ArcTan_Result <= std_logic_vector(Z_reg(7 downto 0));
    end process;

    -- Combine TAN and ARCTAN results
    OUTPUT_THETA <= Tan_Result & ArcTan_Result;

end Behavioral;

-- ======================================================================
-- PENJELASAN DETIL KODE
-- ======================================================================
--
-- Kode ini mengimplementasikan kombinasi dua fungsi trigonometri penting, 
-- yaitu TAN dan ARCTAN, dan menghasilkan keluaran gabungan pada sinyal 
-- `OUTPUT_THETA`. Hasil TAN dan ARCTAN disusun dalam format 16-bit,
-- di mana 8 bit pertama adalah hasil TAN, dan 8 bit terakhir adalah hasil ARCTAN.
--
-- **Input**
-- - `X0`, `Y0`: Koordinat awal dalam sistem kartesian, yang digunakan untuk
--               menghitung ARCTAN.
-- - `XI`, `YI`: Koordinat tujuan dalam sistem kartesian, yang digunakan untuk
--               menghitung TAN.
--
-- Proses Perhitungan
-- 1. Perhitungan TAN
--    - Pertama-tama, dua input `X0` dan `XI`, serta `Y0` dan `YI`, 
--      dilakukan operasi pengurangan menggunakan komponen `Subtraktor_10Bit`.
--      Ini menghasilkan `Sub_X` dan `Sub_Y` (selisih X dan Y).
--    - Hasil pengurangan kemudian diperluas menjadi 12-bit (`Delta_X` dan 
--      `Delta_Y`) dengan menambahkan padding dua bit '0' (shift left 2 bit).
--    - Operasi pembagian dilakukan menggunakan komponen `Divisor12Bit`, 
--      di mana `Delta_X` adalah pembilang, dan `Delta_Y` adalah penyebut.
--      Hasilnya adalah `Tan_Result`, yang berupa nilai 8-bit representasi 
--      TAN (kemiringan antara dua titik dalam sistem kartesian).
--
-- 2. Perhitungan ARCTAN
--    - Algoritma CORDIC digunakan untuk menghitung nilai ARCTAN dengan 
--      mendekati nilai sudut secara iteratif. 
--    - Register internal `X_reg`, `Y_reg`, dan `Z_reg` digunakan untuk 
--      menyimpan nilai sementara selama iterasi.
--    - Proses dimulai dengan nilai awal `X_reg` dan `Y_reg` yang merupakan
--      nilai masukan `X0` dan `Y0`, diperluas menjadi 16-bit. `Z_reg` diinisialisasi
--      dengan nilai nol, yang mewakili sudut awal.
--    - Pada setiap iterasi:
--      - Jika `Y_reg` bernilai negatif, sistem akan melakukan rotasi searah
--        jarum jam dengan menyesuaikan nilai `X_reg`, `Y_reg`, dan `Z_reg`.
--      - Jika `Y_reg` bernilai positif, sistem akan melakukan rotasi 
--        berlawanan arah jarum jam.
--      - Sudut yang digunakan pada setiap iterasi dihitung menggunakan deret
--        \(\arctan(1 / 2^n)\), yang disederhanakan menjadi pembagian sederhana.
--    - Proses ini diulang sebanyak 8 kali untuk mendapatkan presisi 8-bit.
--    - Setelah iterasi selesai, nilai sudut akhir (`Z_reg`) dikonversi menjadi
--      8-bit (`ArcTan_Result`).
--
-- 3. Penggabungan Output
--    - Hasil TAN (`Tan_Result`) dan ARCTAN (`ArcTan_Result`) digabungkan
--      menjadi satu sinyal 16-bit bernama `OUTPUT_THETA`. Formatnya:
--      - Bit [15:8]: TAN (8-bit).
--      - Bit [7:0]: ARCTAN (8-bit).
-- ======================================================================

