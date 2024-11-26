library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity divider is
    Port ( dividend : in  unsigned(11 downto 0);
           divisor : in  unsigned(11 downto 0);
           quotient : out unsigned(11 downto 0);
           en_div : in std_logic;
           reset : in std_logic := '0';
           clock : in std_logic
    );
end divider;


-- 10101 | 000010101 | 101010000
-- 00010 | 000010101
-- 

architecture Behavioral of divider is
    signal memory : unsigned(20 downto 0) := (others => '0');
    signal dikurang : unsigned(10 downto 0) := (others => '0');
    signal next_memory : unsigned(20 downto 0) := (others => '0');
    signal pembagi : unsigned(10 downto 0);
    signal hasil : unsigned(11 downto 0) := (others => '0');
    signal current_state : unsigned(2 downto 0) := "000";
    signal next_state : unsigned(2 downto 0);
    signal comp_result : std_logic;
    signal counter : integer := 0;
    -- signal substrac_result : unsigned(10 downto 0);

    component Comparator11bit is
        Port ( A : in  unsigned(10 downto 0);
               B : in  unsigned(10 downto 0);
               RESULT : out std_logic);  -- Sinyal HIGH jika A < B
    end component;

begin
    pembagi <= divisor(10 downto 0);
    comp : comparator11bit port map(A => next_memory(20 downto 10), B => pembagi, RESULT => comp_result);

    process(clock)
    begin
        if rising_edge(clock) then 
          current_state <= next_state;
          memory <= next_memory;
        end if;
    end process;    

    process(current_state, memory, pembagi, dividend)
    begin
        case current_state is
            when "000" =>
                
                if en_div = '1' then
                    next_memory <= "0000000000" & dividend(10 downto 0);    
                    hasil <= (others => '0');
                    next_state <= "001";
                else
                    next_state <= "000";
                end if;

            when "001" =>
                
                if comp_result = '1' then
                    hasil(10 - counter) <= '1';
                    dikurang <= memory(20 downto 10) - pembagi;
                    next_memory <= dikurang(9 downto 0) & memory(9 downto 0) & '0';
                else 
                
                    next_memory <= memory(19 downto 0) & '0';
                    
                end if;
                if memory(9 downto 0) = "0000000000" then
                    next_state <= "010";
                else
                    next_state <= "001";
                end if;

                counter <= counter + 1;
                    
            when "010" =>
                quotient <= hasil;
                if reset = '1' then
                    quotient <= (others => '0');
                    next_state <= "000";
                end if;
            
            when others =>
                next_state <= "000";

        end case;
    
    end process;

end Behavioral;
    
    
-- force -freeze sim:/divider/dividend 000000001111 0
-- force -freeze sim:/divider/divisor 000000000011 0
-- force -freeze sim:/divider/en_div 1 0
-- force -freeze sim:/divider/clock 1 0, 0 {25 ps} -r 50