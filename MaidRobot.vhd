LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

entity MaidRobot is
    PORT (
        clk         : IN STD_LOGIC;                 -- Clock signal
        reset       : IN STD_LOGIC;                 -- Reset signal
        start       : IN STD_LOGIC;                 -- Start signal
        X_target    : IN STD_LOGIC_VECTOR(9 DOWNTO 0); -- Target X-coordinate
        Y_target    : IN STD_LOGIC_VECTOR(9 DOWNTO 0); -- Target Y-coordinate
        X_current   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0); -- Current X-coordinate
        Y_current   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0); -- Current Y-coordinate
        T_current   : OUT STD_LOGIC_VECTOR(18 DOWNTO 0); -- Current angle
        R_out       : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- Magnitude
        dT_out      : OUT STD_LOGIC_VECTOR(17 DOWNTO 0)  -- Delta angle
    );
end MaidRobot;

architecture Behavioral of MaidRobot is
    -- State declarations
    type state_type is (IDLE, START, CALCULATE, OUTPUT);
    signal state : state_type := IDLE;

    -- Signals for calculations
    signal X0, Y0, X1, Y1 : STD_LOGIC_VECTOR(9 DOWNTO 0); -- Coordinates
    signal Delta_X, Delta_Y : signed(11 DOWNTO 0); -- Differences
    signal R_magnitude : STD_LOGIC_VECTOR(11 DOWNTO 0); -- Magnitude
    signal dT_angle : STD_LOGIC_VECTOR(17 DOWNTO 0); -- Delta angle
    signal Theta_current : STD_LOGIC_VECTOR(18 DOWNTO 0); -- Current angle

    -- Internal calculation components
    component Subtraktor_10bit is
        PORT (
            A : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            R : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
    end component;

    component ArctanCordic is
        PORT (
            X_in      : IN signed(11 DOWNTO 0);
            Y_in      : IN signed(11 DOWNTO 0);
            Theta_out : OUT signed(17 DOWNTO 0);
            clk       : IN STD_LOGIC
        );
    end component;

    component Rooter is
        PORT (
            InVal : IN signed(23 DOWNTO 0);
            Root : OUT signed(11 DOWNTO 0)
        );
    end component;

    -- Other signals
    signal Delta_X_signed, Delta_Y_signed : signed(11 DOWNTO 0);
    signal Magnitude_squared : signed(23 DOWNTO 0);

begin
    -- State machine
    process (clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            X0 <= (OTHERS => '0');
            Y0 <= (OTHERS => '0');
            Theta_current <= (OTHERS => '0');
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    if start = '1' then
                        state <= START;
                    end if;

                when START =>
                    X1 <= X_target;
                    Y1 <= Y_target;
                    state <= CALCULATE;

                when CALCULATE =>
                    -- Calculate Delta_X and Delta_Y
                    Delta_X_Calc: Subtraktor_10bit
                        PORT MAP (
                            A => X1,
                            B => X0,
                            R => Delta_X_signed(9 DOWNTO 0)
                        );

                    Delta_Y_Calc: Subtraktor_10bit
                        PORT MAP (
                            A => Y1,
                            B => Y0,
                            R => Delta_Y_signed(9 DOWNTO 0)
                        );

                    -- Calculate magnitude
                    Magnitude_squared <= Delta_X_signed * Delta_X_signed +
                                         Delta_Y_signed * Delta_Y_signed;

                    Rooter_Inst: Rooter
                        PORT MAP (
                            InVal => Magnitude_squared,
                            Root => R_magnitude
                        );

                    -- Calculate delta angle using CORDIC
                    Cordic_Inst: ArctanCordic
                        PORT MAP (
                            X_in => Delta_X_signed,
                            Y_in => Delta_Y_signed,
                            Theta_out => dT_angle,
                            clk => clk
                        );

                    state <= OUTPUT;

                when OUTPUT =>
                    -- Output values
                    R_out <= R_magnitude;
                    dT_out <= dT_angle;

                    -- Update current position and angle
                    X0 <= X1;
                    Y0 <= Y1;
                    Theta_current <= std_logic_vector(signed(Theta_current) + signed(dT_angle));
                    state <= IDLE;
            end case;
        end if;
    end process;

    -- Assign outputs
    X_current <= X0;
    Y_current <= Y0;
    T_current <= Theta_current;

end Behavioral;
