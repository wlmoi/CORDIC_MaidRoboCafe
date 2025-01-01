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
	signal state        : std_logic_vector(2 downto 0) := "001";
	signal X1           : std_logic_vector(9 downto 0) := (others => '0');
	signal Y1           : std_logic_vector(9 downto 0) := (others => '0');
	signal X0           : std_logic_vector(9 downto 0) := (others => '0');
	signal Y0           : std_logic_vector(9 downto 0) := (others => '0');
	signal cordic_done  : std_logic := '0';
	signal dT           : unsigned(17 downto 0);
	signal R            : unsigned(11 downto 0);
	signal msg          : std_logic_vector(189 downto 0);
	signal msg_ready 	: std_logic_vector(189 downto 0);
	signal create_done  : std_logic := '0';
	signal i_start_msg  : std_logic := '0';
	signal rst_msg 	: std_logic := '0';

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
			dT        : out unsigned(17 downto 0);
			r_cordic  : out unsigned(11 downto 0);
			clk       : in std_logic
		);
	end component;

	component create_msg is
		port (
			clk         : in std_logic;
			dT          : in unsigned(17 downto 0);  -- 1 10000001 110101001 -53,425
			i_start     : in std_logic;
			R           : in unsigned(11 downto 0);  -- 001011010111 363,5
			create_done : out std_logic := '0';
			reset       : in std_logic;
			msg         : out std_logic_vector(189 downto 0)
		);
	end component;

begin
	lampu(3) <= create_done;
	lampu(2 downto 0) <= state;

	led <= "0000";

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
		dT          => dT,
		i_start     => i_start_msg,
		R           => R,
		reset       => rst_msg,
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
		i_ascii => x1(7 downto 0),
		hex1    => s_hex
	);

	s_ascii <= s_rx_data;  -- data rx yang dibaca dari buffer menjadi input konverter ascii-hex
	hex1 <= s_hex;  -- data rx yang dibaca dari buffer ditampilkan pada 7 Segmen.
	
			

	p_TRANSMIT	:	process(i_CLOCK) begin
	
		if(rising_edge(i_CLOCK)) then
			------------------------------------------------------------
		
			--- Jika memungkinkan, kirim byte data di input.
			if( 
				i_send = '0' and 		----	Tombol Kirim ditekan
				s_TX_BUSY = '0' and 	----	pengirim tidak sibuk / tidak mengirim
				s_allow_press = '1'		----  	tombol diizinkan untuk ditekan
				) then 					----	Kirim pesan jika subkomponen "TX" tidak sibuk
			
				-- r_TX_DATA	<=	"1001101010100101100010011001101001101100100110011010011000001001110100101010010010011010101001100100100110100010010110001001110010100110010010011000101001011010100111010010101010001011001000";									----Berikan pesan subkomponen
				r_TX_DATA	<=	msg_ready;									----Berikan pesan subkomponen
				s_TX_START	<=	'1';									----Beri tahu untuk mengirim

			else
			
				s_TX_START <= '0';									----Jika Subkomponen "TX" sibuk, atau tombol tidak ditekan, jangan kirim
				
			end if;	---KEY(0) = '0' dan s_TX_BUSY = '0'
		end if;
	end process;

	process (state, i_calc, i_clock, create_done, tx_done)
	begin
		if rising_edge(i_clock) then
			case state is
				when "001" =>  -- idle
					i_start_msg <= '0';
					i_send <= '1';
					-- rst_msg <= '1';
					if (i_calc = '0') then
						-- state <= "010";
						state <= "100";
						-- rst_msg <= '0';
						
					end if;

				-- when "010" =>
				-- 	start_calculation <= '1';

				-- 	if cordic_done = '1' then
				-- 		state <= "011";
				-- 	else
				-- 		state <= "010";
				-- 	end if;

				-- when "011" =>
				-- 	calc_dt_start <= '1';

				-- 	if calc_dt_done = '1' then
				-- 		state <= "100";
				-- 	else
				-- 		state <= "011";
				-- 	end if;

				when "100" =>
					
					dT <= "110000001110101001";
					R  <= "001011010111";
					i_start_msg <= '1';
					if create_done = '1' then
						state <= "101";
						i_start_msg <= '0';
						msg_ready <= msg;
					else
						state <= "100";
					end if;

				when "101" =>
					i_send <= '0';
					rst_msg <= '1';

					if tx_done = '1' then
						i_send <= '1';
						state <= "001";
						rst_msg <= '0';
					end if;

				when others =>
			end case;
		end if;
	end process;
end behavior;
