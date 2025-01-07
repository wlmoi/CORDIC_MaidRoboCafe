-- Spesifikasi
-- Menerima dua inputm yaitu X0 dan Y0 dengan nilai maksimal masin masing 1000

--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart is
	port (
		i_CLOCK     : in std_logic;
		i_DISPLAY   : in std_logic;  -- Sinyal "tampilkan data", berasal dari komponen lain
		i_RX        : in std_logic;  -- Garis masukan
		i_rst       : in std_logic;
		o_TX        : out std_logic := '1';  -- Garis keluaran
		i_calc      : in std_logic;
		lampu 		: out std_logic_vector(3 downto 0) := "1111";
		-- RX memiliki log 255 register yang terhubung ke DATA_OUT, pilih alamat di sin
		o_sig_CRRP_DATA : out std_logic;  -- Sinyal data rusak
		o_sig_RX_BUSY   : out std_logic;  -- tanda jika RX sibuk atau dalam mode menerima.
		o_sig_TX_BUSY   : out std_logic;  -- tanda jika TX sibuk atau dalam mode mengirim.
		led             : out std_logic_vector(3 downto 0);
		hex1            : out std_logic_vector(6 downto 0)  -- Sinyal HEX (7 Segmen).
	);
end uart;

architecture behavior of uart is
	-- SINYAL
	signal r_TX_DATA    : std_logic_vector(189 downto 0) := (others => '1');  -- Register yang menyimpan pesan untuk dikirim
	signal s_TX_START   : std_logic := '0';  -- Sinyal yang disimpan untuk memulai transmisi
	signal s_TX_BUSY    : std_logic;  -- Sinyal yang disimpan yang mengingatkan komponen utama bahwa sub komponennya "TX" sedang sibuk
	signal s_rx_data    : std_logic_vector(7 downto 0);  -- Data RX yang dibaca dari Buffer RX
	signal s_hex        : std_logic_vector(6 downto 0);  -- Sinyal HEX (7 Segmen) dari Konverter ASCII-HEX.
	signal s_ascii      : std_logic_vector(7 downto 0);  -- Data RX yang dibaca dari Buffer RX dan menjadi input Konverter ASCII-HEX.
	signal tx_done      : std_logic := '0';
	signal tx_run       : std_logic := '0';
	signal s_button_counter : integer range 0 to 50000000 := 0;  -- penghitung untuk menunda penekanan tombol.
	signal s_allow_press : std_logic := '0';  -- sinyal untuk mengizinkan tombol ditekan.
	signal i_send       : std_logic := '1';
	signal state        : std_logic_vector(3 downto 0) := "0001";
	signal X1           : std_logic_vector(9 downto 0) := (others => '0');
	signal Y1           : std_logic_vector(9 downto 0) := (others => '0');
	signal X0           : std_logic_vector(9 downto 0) := (others => '0');
	signal Y0           : std_logic_vector(9 downto 0) := (others => '0');
	signal cordic_done  : std_logic := '0';
	signal dT           : unsigned(18 downto 0);
	signal R            : unsigned(11 downto 0);
	signal msg          : std_logic_vector(189 downto 0);
	signal msg_ready 	: std_logic_vector(189 downto 0);
	signal create_done  : std_logic := '0';
	signal i_start_msg  : std_logic := '0';
	signal rst_msg 	: std_logic := '0';
	signal hex_bcd : std_logic_vector (7 downto 0) := (others => '0');

	signal convert_bcd_r_done : std_logic := '0';
	signal convert_bcd_dt1_done : std_logic := '0';
	signal convert_bcd_dt2_done : std_logic := '0';
    signal data_biner : unsigned(10 downto 0) := (others => '0');
    signal data_bcd : unsigned(15 downto 0) := (others => '0');
    signal RST_bcd : std_logic := '0';

	signal dT1_bcd : unsigned(15 downto 0) := (others => '0');
	signal dT2_bcd : unsigned(15 downto 0) := (others => '0');
	signal R_bcd : unsigned(15 downto 0) := (others => '0');

	signal dt_min : std_logic := '0';
	signal r_koma : std_logic := '0';

	signal start_fix : std_logic := '0';
	signal fix_done : std_logic := '0';
	signal dt_fix : unsigned(9 downto 0) := (others => '0');
	
	SIGNAL START_BCD : STD_LOGIC := '0';

	-- KOMPONENT
	component uart_tx is
		port (
			i_CLOCK : in std_logic;
			i_START : in std_logic;
			o_BUSY  : out std_logic;
			tx_done : out std_logic;
			i_DATA  : in std_logic_vector(189 downto 0);
			o_TX_LINE : out std_logic := '1'
		);
	end component;

	component uart_rx is
		port (
			i_CLOCK         : in std_logic;
			i_rst           : in std_logic;
			i_RX            : in std_logic;
			o_sig_CRRP_DATA : out std_logic := '0';  -- Currupted data flag
			x_biner         : out std_logic_vector(9 downto 0) := (others => '0');
			y_biner         : out std_logic_vector(9 downto 0) := (others => '0');
			o_BUSY          : out std_logic
		);
	end component;

	component asciiHex is
		port (
			i_ascii : in std_logic_vector(7 downto 0);
			hex1    : out std_logic_vector(6 downto 0)
		);
	end component;

	component cordic is
		port (
			x_in      : in std_logic_vector(9 downto 0);
			y_in      : in std_logic_vector(9 downto 0);
			cordic_on : in std_logic;
			z         : out std_logic;
			dT        : out unsigned(18 downto 0);
			r_cordic  : out unsigned(11 downto 0);
			clk       : in std_logic
		);
	end component;

	component create_msg is
		port (
			clk         : in std_logic;
			i_start     : in std_logic;
			create_done : out std_logic := '0';
			reset       : in std_logic;
			dT_min      : in std_logic;
			R_koma      : in std_logic;
			dT1_bcd : in  unsigned(11 downto 0) := (others => '0');
	    	dT2_bcd : in  unsigned(11 downto 0) := (others => '0');
	    	R_bcd : in unsigned(15 downto 0) := (others => '0');
			msg         : out std_logic_vector(189 downto 0)
		);
	end component;

	component binary_to_bcd is
        port(
            i_DATA : IN UNSIGNED(10 DOWNTO 0);
            i_CLK : IN STD_LOGIC;
            i_START		:	IN STD_LOGIC;
            convert_done : OUT STD_LOGIC := '0';
            o_bcd : OUT UNSIGNED(15 DOWNTO 0)
        );
    end component;


	component fixtobinary is
		PORT(
        clk : IN STD_LOGIC;
        FIX : IN UNSIGNED(9 DOWNTO 0); 
        start : IN STD_LOGIC;
        DONE : OUT STD_LOGIC;
        A_OUT : OUT UNSIGNED(9 DOWNTO 0) := (OTHERS => '0')
    );
	end component;

begin
	lampu(3) <= create_done;
	lampu(2 downto 0) <= state(2 downto 0);
	dT <= "1101100110111010010";
	-- "1101100110111010010";
	R  <= "001011100011";
	dt_min <= dT(18);
	r_koma <= R(0);

	led <= "0000";

	hex_bcd <= "0011" & std_logic_vector(dt2_bcd(3 downto 0));
	-- hex_bcd <= "0011" & std_lodT1_bcd(3 downto 0);

	

	-- Modul Penerima
	u_RX : uart_rx port map (
		i_CLOCK        => i_CLOCK,
		i_rst          => i_rst,
		i_RX           => i_RX,
		o_sig_CRRP_DATA => o_sig_CRRP_DATA,
		o_BUSY         => o_sig_RX_BUSY,
		x_biner        => X1,
		y_biner        => Y1
	);

	u_TX : uart_tx port map (
		i_CLOCK  => i_CLOCK,
		i_START  => s_TX_START,
		o_BUSY   => s_TX_BUSY,
		i_DATA   => r_TX_DATA,
		tx_done  => tx_done,
		o_TX_LINE => o_TX
	);

	u_convert_msg : create_msg port map (
		clk         => i_CLOCK,
		i_start     => i_start_msg,
		reset       => '0',
		dT1_bcd     => dt1_bcd(11 downto 0),
		dT2_bcd     => dT2_bcd(11 downto 0),	
		R_bcd       => R_bcd,
		-- dT1_bcd     => "001101000101",
		-- dT2_bcd     => "011001111000",	
		-- R_bcd       => "0100011100100011",
		dt_min      => dt_min,
		R_koma      => r_koma,
		create_done => create_done,
		msg         => msg
	);

	p_button : process(i_CLOCK)
	begin
		if rising_edge(i_CLOCK) then
			if s_button_counter = 49999900 then
				s_button_counter <= 0;
				s_allow_press <= '1';
			else
				s_button_counter <= s_button_counter + 1;
				s_allow_press <= '0';
			end if;
		end if;
	end process;

	u_msg_t1 : binary_to_bcd port map(
        i_DATA => "000" & dT(17 downto 10),
        i_CLK => i_clock,
        i_start => START_BCD,
        convert_done => convert_bcd_dt1_done,
        o_bcd => dT1_bcd);

	u_msg_t2 : binary_to_bcd port map(
        i_DATA => '0' & dt_fix,
        i_CLK => i_clock,
        i_start => START_BCD,
        convert_done => convert_bcd_dt2_done,
        o_bcd => dT2_bcd);

	u_msg_r : binary_to_bcd port map(
        i_DATA => R(11 downto 1),
        i_CLK => i_clock,
        i_start => START_BCD,
        convert_done => convert_bcd_r_done,
        o_bcd => R_bcd);

	u_fixtobinary : fixtobinary port map(
		clk => i_CLOCK,
		FIX => dT(9 downto 0),
		start => start_fix,
		DONE => fix_done,
		A_OUT => dt_fix
	);
	


	-- u_cordic : cordic port map(
	--  x_in => X1,
	--  y_in => Y1,
	--  clk => i_CLOCK,
	--  cordic_on => i_calc,
	--  z => cordic_done,
	--  dT => dT,
	--  r_cordic => R
	-- );

	-- Modul Konverter ASCII ke HEX (7 Segmen)
	a2h : asciiHex port map (
		i_ascii => hex_bcd,
		hex1    => s_hex
	);

	s_ascii <= s_rx_data;  -- data rx yang dibaca dari buffer menjadi input konverter ascii-hex
	hex1 <= s_hex;  -- data rx yang dibaca dari buffer ditampilkan pada 7 Segmen.
	
			

	p_TRANSMIT	:	process(i_CLOCK) begin
	
		if(rising_edge(i_CLOCK)) then
			------------------------------------------------------------
		
			--- Jika memungkinkan, kirim byte data di input.
			if( 
				i_calc = '0' and 		----	Tombol Kirim ditekan
				s_TX_BUSY = '0' and 	----	pengirim tidak sibuk / tidak mengirim
				s_allow_press = '1'		----  	tombol diizinkan untuk ditekan
				) then 					----	Kirim pesan jika subkomponen "TX" tidak sibuk
			
				-- r_TX_DATA	<=	"1001101010100101100010011001101001101100100110011010011000001001110100101010010010011010101001100100100110100010010110001001110010100110010010011000101001011010100111010010101010001011001000";									----Berikan pesan subkomponen
				r_TX_DATA	<=	msg;									----Berikan pesan subkomponen
				s_TX_START	<=	'1';									----Beri tahu untuk mengirim

			else
			
				s_TX_START <= '0';									----Jika Subkomponen "TX" sibuk, atau tombol tidak ditekan, jangan kirim
				
			end if;	---KEY(0) = '0' dan s_TX_BUSY = '0'
		end if;
	end process;



	process (state, i_calc, i_clock, create_done, tx_done)
	begin
		if rising_edge(i_clock) then
			rst_bcd <= '0';
			case state is
				when "0001" =>  -- idle
					i_start_msg <= '0';
					start_fix <= '1';
					-- rst_msg <= '1';
					if (i_display = '0') then
						start_fix <= '0';
						-- state <= "0010";
						state <= "0010";
						rst_msg <= '1';
						
					end if;

				when "0010" =>
				    -- rst_msg <= '0';
					
					
					if fix_done = '1' then
						start_bcd <= '1';
						state <= "0011";
						rst_msg <= '0';
					end if;
				
				when "0011" =>
					rst_msg <= '0';
					start_bcd <= '0';
				    if convert_bcd_dt1_done = '1' and convert_bcd_dt2_done = '1' and convert_bcd_r_done = '1'then 
						i_start_msg <= '1';
					
				        state <= "0101";

				    else
				        state <= "0011";
				    end if;

				
				-- when "0010" =>
				-- 	start_calculation <= '1';

				-- 	if cordic_done = '1' then
				-- 		state <= "0011";
				-- 	else
				-- 		state <= "0010";
				-- 	end if;

				-- when "0011" =>
				-- 	calc_dt_start <= '1';

				-- 	if calc_dt_done = '1' then
				-- 		state <= "0100";
				-- 	else
				-- 		state <= "0011";
				-- 	end if;

				when "0101" =>
					i_start_msg <= '0';
					if create_done = '1' then
						state <= "0110";
						i_start_msg <= '0';
						-- msg_ready <= msg;
					else
						state <= "0101";
					end if;

				when "0110" =>

					if tx_done = '1' then
						state <= "0001";
						-- rst_msg <= '0';
					end if;

				when others =>
			end case;
		end if;
	end process;
end behavior;
