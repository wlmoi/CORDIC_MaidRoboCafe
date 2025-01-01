library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity create_msg is
    port (
        clk : in std_logic;
        dT : in unsigned(17 downto 0); -- 110000001110101001 -53,425
        i_start : IN STD_LOGIC;
        R : in unsigned(11 downto 0); -- 001011010111 363,5
        create_done : out std_logic := '0';
        reset : in std_logic;
        msg : out std_logic_vector(189 downto 0)

    );
end create_msg;

architecture behavioral of create_msg is

    signal state : std_logic_vector(3 downto 0) := "1111";
    signal next_state : std_logic_vector(3 downto 0) := "1111";
    signal convert_done : std_logic := '0';
    signal data_biner : unsigned(10 downto 0) := (others => '0');
    signal data_bcd : unsigned(15 downto 0) := (others => '0');
    signal i_RST : std_logic := '0';
    
    component binary_to_bcd is
        port(
            i_DATA : IN UNSIGNED(10 DOWNTO 0);
            i_CLK : IN STD_LOGIC;
            i_RST		:	IN STD_LOGIC;
            convert_done : OUT STD_LOGIC := '0';
            o_bcd : OUT UNSIGNED(15 DOWNTO 0)
        );
    end component;
    
begin

    u_msg_t1 : binary_to_bcd port map(
        i_DATA => (data_biner),
        i_CLK => clk,
        i_RST => i_RST,
        convert_done => convert_done,
        o_bcd => data_bcd);

    process(clk)
    begin
        if rising_edge(clk) then
            state <= next_state;
            -- i_rst <= '0';
            
        end if;
    end process;
    
    process(state, dT, R, convert_done, i_start)
    begin
        case state is
            when "1111" =>-- idle
                if i_start = '1' then
                    next_state <= "0000";
                    create_done <= '0';
                else 
                    next_state <= "1111";
                end if;

            when "0000" => -- pengisian dT:
                msg(29 downto 0) <= "100111010010101010001011001000";
                next_state <= "0001";
            when "0001" => -- pengisian tanda - dt
                i_rst <= '1';
    
                if dT(17) = '1' then
                    msg(39 downto 30) <= "1001011010";
                    
                else 
                    msg(39 downto 30) <= "1001010110";
                end if;    

                next_state <= "0010";

            when "0010" =>  -- pengisian angka di depan koma dT
                i_rst <= '0';
                data_biner <= "000" & dT(16 downto 9);
                -- data_biner <= "00010000001";
                
                msg(69 downto 40) <= "10011" & std_logic_vector(data_bcd(3 downto 0)) & '0' 
                                    & "10011" & std_logic_vector(data_bcd(7 downto 4) & '0') 
                                    & "10011" & std_logic_vector(data_bcd(11 downto 8)) & '0';
                if convert_done = '0' then
                    next_state <= "0010";
                else 
                    next_state <= "0011";
                    i_rst <= '1';
        
                end if;

            when "0011" => -- pengisian angka di belakang koma dT
                i_rst <= '0';
                data_biner <= "00" & dT(8 downto 0);
                msg(109 downto 70) <=  "10011" & std_logic_vector(data_bcd(3 downto 0) & '0')  
                                        & "10011" & std_logic_vector(data_bcd(7 downto 4)) & '0' 
                                        & "10011" & std_logic_vector(data_bcd(11 downto 8) & '0')  & "1001011000"; 
                if convert_done = '0' then
                    next_state <= "0011";
                else 
                    next_state <= "0100";
                    i_rst <= '1';
        

                end if;

            when "0100" => -- pengisian R:
                msg(129 downto 110) <= "10011101001010100100";
                next_state <= "0101";
            
            when "0101" => -- pengisian isi R
                i_rst <= '0';
                data_biner <= R(11 downto 1);
                msg(169 downto 130) <= "10011" & std_logic_vector(data_bcd(3 downto 0) & '0') & 
                "10011" & std_logic_vector(data_bcd(7 downto 4) & '0') & 
                "10011" & std_logic_vector(data_bcd(11 downto 8) & '0') & 
                "10011" & std_logic_vector(data_bcd(15 downto 12) & '0') ;

                if convert_done = '0' then
                    next_state <= "0101";
                else 
                    next_state <= "0110";
                    i_rst <= '1';
        
                end if;
            
            when "0110" => -- pengisian koma seetelah R
                msg(179 downto 170) <=   "1001011000";
                
                if R(0) = '1' then
                    msg(189 downto 180) <= "1001101010";
                else 
                    msg(189 downto 180) <= "1001100000";
                end if;

                next_state <= "0111";
            
            when "0111" => -- done
                create_done <= '1';
                if reset = '1' then
                    next_state <= "1111";
                    msg <= (others => '0');
                end if;

            when others =>
                next_state <= "1111";
                create_done <= '0';
        end case;
    end process;

end behavioral;
