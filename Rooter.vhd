-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 8 Desember 2024
-- Fungsi       : Menghitung akar kuadrat dari bilangan 24-bit signed menggunakan 
--                komponen Multiplier12bit12bit untuk perkalian dan ShiftRegister 
--                untuk menghasilkan nilai iterasi.

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

entity Rooter is
    PORT (
        InVal : IN signed(23 DOWNTO 0); -- Input bilangan kuadrat (24-bit signed)
        Root  : OUT signed(11 DOWNTO 0) -- Output akar kuadrat (12-bit signed)
    );
end Rooter;

architecture Behavioral of Rooter is
    -- Sinyal internal
    signal Temp : signed(11 DOWNTO 0) := (OTHERS => '0'); -- Hasil sementara akar kuadrat
    signal Increment : signed(11 DOWNTO 0);               -- Nilai iterasi untuk percobaan (2^i)
    signal TestValue : signed(23 DOWNTO 0);               -- Kuadrat hasil sementara
    signal ShiftedValue : signed(11 DOWNTO 0);            -- Nilai geser untuk menghasilkan increment
    signal CurrentShiftAmt : integer range 0 to 11 := 0;  -- Nilai shift saat ini

    -- Deklarasi komponen
    component Multiplier12bit12bit
        PORT (
            A : IN  signed(11 DOWNTO 0);
            B : IN  signed(11 DOWNTO 0);
            P : OUT signed(23 DOWNTO 0)
        );
    end component;

    component ShiftRegister
        PORT (
            D_in : IN signed(11 DOWNTO 0);
            Shifted : OUT signed(11 DOWNTO 0);
            shift_amt : IN integer
        );
    end component;

begin
    -- Instansiasi ShiftRegister
    ShiftRegister_Inst: ShiftRegister
        PORT MAP (
            D_in => to_signed(1, 12), -- Masukkan nilai awal 1
            Shifted => Increment,    -- Keluar sebagai nilai geser
            shift_amt => CurrentShiftAmt -- Geser sesuai shift_amt
        );

    -- Instansiasi Multiplier12bit12bit
    Multiplier_Inst: Multiplier12bit12bit
        PORT MAP (
            A => Temp + Increment, -- Nilai sementara ditambah iterasi
            B => Temp + Increment, -- Nilai sementara ditambah iterasi
            P => TestValue         -- Hasil perkalian
        );

    -- Proses utama
    process(InVal)
    begin
        -- Inisialisasi
        Temp <= (OTHERS => '0'); -- Mulai dari nol

        -- Iterasi dari bit paling signifikan (MSB) ke bit paling tidak signifikan (LSB)
        for CurrentShiftAmt in 11 DOWNTO 0 loop
            -- Periksa apakah kuadrat dari nilai sementara valid
            if TestValue <= InVal then
                Temp <= Temp + Increment; -- Perbarui hasil jika valid
            end if;
        end loop;

        -- Simpan hasil akhir ke output
        Root <= Temp;
    end process;

end Behavioral;
