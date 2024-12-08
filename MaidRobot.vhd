-- Nama         : William Anthony
-- NIM          : 13223048
-- Tanggal      : 8 Desember 2024
-- Fungsi       : Desain sistem MaidRobot dengan input start_btn untuk memulai operasi, 
--                menghitung jarak (magnitude) dan sudut delta (dT_out) berdasarkan 
--                koordinat target dan posisi saat ini.

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

entity MaidRobot is
    PORT (
        clk         : IN  STD_LOGIC;                     -- Clock signal
        reset       : IN  STD_LOGIC;                     -- Reset signal
        start_btn   : IN  STD_LOGIC;                     -- Start button signal
        X_target    : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);  -- Target X-coordinate
        Y_target    : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);  -- Target Y-coordinate
        X_current   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);  -- Current X-coordinate
        Y_current   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);  -- Current Y-coordinate
        T_current   : OUT STD_LOGIC_VECTOR(18 DOWNTO 0); -- Current angle
        R_out       : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- Magnitude
        dT_out      : OUT STD_LOGIC_VECTOR(17 DOWNTO 0)  -- Delta angle
    ); 
end MaidRobot;

architecture Behavioral of MaidRobot is
    -- State declarations
    type state_type is (IDLE, START, CALCULATE, OUTPUT);
    signal state : state_type := IDLE;

    -- Signals for internal calculations
    signal X0, Y0, X1, Y1 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    signal Delta_X, Delta_Y : STD_LOGIC_VECTOR(9 DOWNTO 0);
    signal Delta_X_signed, Delta_Y_signed : signed(11 DOWNTO 0);
    signal R_magnitude_signed : signed(11 DOWNTO 0);      -- Magnitude as signed
    signal Magnitude_squared : signed(23 DOWNTO 0);
    signal dT_angle : signed(17 DOWNTO 0);
    signal Theta_current : STD_LOGIC_VECTOR(18 DOWNTO 0);

    -- Component declarations
    component Subtraktor_10bit is
        PORT (
            A : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
            B : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
            R : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
    end component;

    component Rooter is
        PORT (
            InVal : IN  signed(23 DOWNTO 0);
            Root  : OUT signed(11 DOWNTO 0)
        );
    end component;

    component ArctanCordic is
        PORT (
            X_in      : IN  signed(11 DOWNTO 0);
            Y_in      : IN  signed(11 DOWNTO 0);
            Theta_out : OUT signed(17 DOWNTO 0);
            clk       : IN  STD_LOGIC
        );
    end component;

begin
    -- Subtraction logic
    Sub_X: Subtraktor_10bit
        PORT MAP (
            A => X1,
            B => X0,
            R => Delta_X
        );

    Sub_Y: Subtraktor_10bit
        PORT MAP (
            A => Y1,
            B => Y0,
            R => Delta_Y
        );

    -- Magnitude calculation
    Rooter_Inst: Rooter
        PORT MAP (
            InVal => Magnitude_squared,
            Root  => R_magnitude_signed -- Output sebagai signed
        );

    -- Angle calculation
    Cordic_Inst: ArctanCordic
        PORT MAP (
            X_in      => Delta_X_signed,
            Y_in      => Delta_Y_signed,
            Theta_out => dT_angle,
            clk       => clk
        );

    -- State machine process
    process (clk, reset, start_btn)
    begin
        if reset = '1' then
            -- Reset all signals
            state <= IDLE;
            X0 <= (OTHERS => '0');
            Y0 <= (OTHERS => '0');
            Theta_current <= (OTHERS => '0');
            X1 <= (OTHERS => '0');
            Y1 <= (OTHERS => '0');
            Delta_X <= (OTHERS => '0');
            Delta_Y <= (OTHERS => '0');
            Delta_X_signed <= (OTHERS => '0');
            Delta_Y_signed <= (OTHERS => '0');
            R_magnitude_signed <= (OTHERS => '0');
            Magnitude_squared <= (OTHERS => '0');
            dT_angle <= (OTHERS => '0');
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    -- Wait for start button signal
                    if start_btn = '1' then
                        state <= START;
                    end if;

                when START =>
                    -- Assign target coordinates
                    X1 <= X_target;
                    Y1 <= Y_target;
                    state <= CALCULATE;

                when CALCULATE =>
                    -- Convert Delta_X and Delta_Y to signed
                    Delta_X_signed <= signed(Delta_X);
                    Delta_Y_signed <= signed(Delta_Y);

                    -- Calculate magnitude squared (Delta_X^2 + Delta_Y^2)
                    Magnitude_squared <= Delta_X_signed * Delta_X_signed + Delta_Y_signed * Delta_Y_signed;

                    state <= OUTPUT;

                when OUTPUT =>
                    -- Assign output values
                    R_out <= std_logic_vector(R_magnitude_signed); -- Konversi ke std_logic_vector
                    dT_out <= std_logic_vector(dT_angle);

                    -- Update current coordinates and angle
                    X0 <= X1;
                    Y0 <= Y1;
                    Theta_current <= std_logic_vector(signed(Theta_current) + dT_angle);

                    -- Return to IDLE state
                    state <= IDLE;

                when others =>
                    -- Default state
                    state <= IDLE;
            end case;
        end if;
    end process;

    -- Output assignments
    X_current <= X0;
    Y_current <= Y0;
    T_current <= Theta_current;

end Behavioral;
