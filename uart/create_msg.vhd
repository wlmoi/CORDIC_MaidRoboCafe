library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity create_msg is
    port (
        clk : in std_logic;
        dT : in unsigned(17 downto 0); -- 101101010110101001 -53,425
        i_start : IN STD_LOGIC;
        R : in unsigned(11 downto 0); -- 001011010111 363,5
        create_done : out std_logic := '0';
        msg : out std_logic_vector(179 downto 0)
    );
end create_msg;

architecture behavioral of create_msg is

    signal state : std_logic_vector(2 downto 0) := "000";
    signal next_state : std_logic_vector(2 downto 0) := "000";
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
            i_RST <= '0';
            
        end if;

        case state is
            when "000" => -- pengisian dT:
                msg(29 downto 0) <= "100111010010101010001011001000";
                next_state <= "001";
            when "001" => -- pengisian tanda - dt
                i_rst <= '1';
                if dT(17) = '1' then
                    msg(39 downto 30) <= "1001011010";
                    
                else 
                    msg(39 downto 30) <= "1001010110";
                end if;    

                next_state <= "010";
            when "010" =>  -- pengisian angka di depan koma dT
                -- data_biner <= "0000" & dT(16 downto 10);
                data_biner <= "00000110101";
                
                msg(59 downto 40) <= "10011" & std_logic_vector(data_bcd(3 downto 0)) & '0' & "10011" & std_logic_vector(data_bcd(7 downto 4) & '0');
                if convert_done = '0' then
                    next_state <= "010";
                else 
                    next_state <= "011";
                    i_rst <= '1';
                end if;

            when "011" => -- pengisian angka di belakang koma dT

                data_biner <= "0" & dT(9 downto 0);
                msg(99 downto 60) <=  "10011" & std_logic_vector(data_bcd(11 downto 8) & '0')  & "10011" & std_logic_vector(data_bcd(7 downto 4)) & '0' & "10011" & std_logic_vector(data_bcd(3 downto 0) & '0')  & "1001011000"; 
                if convert_done = '0' then
                    next_state <= "011";
                else 
                    next_state <= "100";
                    i_rst <= '1';
                end if;

            when "100" => -- pengisian R:
                msg(119 downto 100) <= "10011101001010100100";
                next_state <= "101";
            
            when "101" => -- pengisian isi R
                data_biner <= R(11 downto 1);
                msg(159 downto 120) <= "10011" & std_logic_vector(data_bcd(3 downto 0) & '0') & 
                "10011" & std_logic_vector(data_bcd(7 downto 4) & '0') & 
                "10011" & std_logic_vector(data_bcd(11 downto 8) & '0') & 
                "10011" & std_logic_vector(data_bcd(15 downto 12) & '0') ;

                if convert_done = '0' then
                    next_state <= "101";
                else 
                    next_state <= "110";
                    i_rst <= '1';
                end if;
            
            when "110" => -- pengisian koma seetelah R
                msg(169 downto 160) <=   "1001011000";
                
                if R(0) = '1' then
                    msg(179 downto 170) <= "1001101010";
                else 
                    msg(179 downto 170) <= "1001100000";
                end if;

                next_state <= "111";
            
            when "111" => -- selesai
                create_done <= '1';

                if i_start = '1' then
                    next_state <= "000";
                else 
                    next_state <= "111";
                end if;

            when others =>
                next_state <= "000";
        end case;
    end process;

end behavioral;
