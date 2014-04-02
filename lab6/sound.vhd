LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY sound IS
	PORT (CLOCK_50,AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK,AUD_ADCDAT			:IN STD_LOGIC;
	      CLOCK_27															:IN STD_LOGIC;
	      KEY																:IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	      SW																	:IN STD_LOGIC_VECTOR(17 downto 0);
	      I2C_SDAT															:INOUT STD_LOGIC;
	I2C_SCLK,AUD_DACDAT,AUD_XCK								:OUT STD_LOGIC);
END sound;

ARCHITECTURE Behavior OF sound IS

	-- CODEC Cores

	COMPONENT clock_generator
		PORT(	CLOCK_27														:IN STD_LOGIC;
		      reset															:IN STD_LOGIC;
		      AUD_XCK														:OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT audio_and_video_config
		PORT(	CLOCK_50,reset												:IN STD_LOGIC;
		      I2C_SDAT														:INOUT STD_LOGIC;
		      I2C_SCLK														:OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT audio_codec
		PORT(	CLOCK_50,reset,read_s,write_s							:IN STD_LOGIC;
		writedata_left, writedata_right						:IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		AUD_ADCDAT,AUD_BCLK,AUD_ADCLRCK,AUD_DACLRCK		:IN STD_LOGIC;
		read_ready, write_ready									:OUT STD_LOGIC;
		readdata_left, readdata_right							:OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		AUD_DACDAT													:OUT STD_LOGIC);
	END COMPONENT;

	SIGNAL read_ready, write_ready, read_s, write_s		      :STD_LOGIC;
	SIGNAL writedata_left, writedata_right							:STD_LOGIC_VECTOR(23 DOWNTO 0);	
	SIGNAL readdata_left, readdata_right							:STD_LOGIC_VECTOR(23 DOWNTO 0);	
	SIGNAL reset															:STD_LOGIC;

	CONSTANT max_amp														:SIGNED(23 DOWNTO 0) := "000000001000000000000000";

	type state_types is (C1 ,C2, C3);

BEGIN

	reset <= NOT(KEY(0));
	read_s <= '0';	

	my_clock_gen: clock_generator PORT MAP (CLOCK_27, reset, AUD_XCK);
	cfg: audio_and_video_config PORT MAP (CLOCK_50, reset, I2C_SDAT, I2C_SCLK);
	codec: audio_codec PORT MAP(CLOCK_50,reset,read_s,write_s,writedata_left, writedata_right,AUD_ADCDAT,AUD_BCLK,AUD_ADCLRCK,AUD_DACLRCK,read_ready, write_ready,readdata_left, readdata_right,AUD_DACDAT);

	--- rest of your code goes here
	PROCESS(CLOCK_50,reset)

		VARIABLE counter_c	:UNSIGNED(9 DOWNTO 0) := "0000000000";
		VARIABLE switch_c		:STD_LOGIC := '0';
		VARIABLE input_c     :SIGNED(23 DOWNTO 0) := "000000000000000000000000";
		VARIABLE current_state: state_types;

	BEGIN
		if (reset = '1') then
			current_state := C1;
		elsif(rising_edge(CLOCK_50)) then

			case current_state is
				when C1 =>
					write_s <= '0';			
					current_state := C2;

				when C2 =>
					if(write_ready = '1') then
						if(switch_c = '0') then
							input_c := not(max_amp) + 1;
							writedata_left <= (STD_LOGIC_VECTOR(input_c));
							writedata_right <= (STD_LOGIC_VECTOR(input_c));
						elsif(switch_c = '1') then
							input_c := max_amp - 1;
							writedata_left <= (STD_LOGIC_VECTOR(input_c));
							writedata_right <= (STD_LOGIC_VECTOR(input_c));
						end if;
						write_s <= '1';
						counter_c := counter_c + 1;
						if(counter_c = "0001010100") then
							counter_c := "0000000000";
							switch_c := not(switch_c);
						end if;	
						current_state := C3;
					else
						current_state := C1;
					end if;	
					

				when C3 =>
					if(write_ready = '0') then
						write_s <= '0';
					end if;
						current_state := C2;
					


			end case;
		end if;
	END PROCESS;

END Behavior;