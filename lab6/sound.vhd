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

	type freq_data is array (0 to 6) of UNSIGNED(9 DOWNTO 0);--constant array of frequencies, starting from the left is C, D and so on
	CONSTANT frequencies : freq_data := ("0001010100","0001001011","0001000011","0000111111","0000111000","0000110010","0000101101");

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

		VARIABLE counter_c, counter_d, counter_e, counter_f, counter_g, counter_a, counter_b	:UNSIGNED(9 DOWNTO 0) := "0000000000"; --counter that are going to be assigned by frequencies (the number is actually acquired by dividing frequencies by 44000 and then by 2)
		VARIABLE switch_c, switch_d, switch_e, switch_f, switch_g, switch_a, switch_b		:STD_LOGIC := '0'; --signal to switch wave (positive to negative)
		VARIABLE input_c, input_d, input_e, input_f, input_g, input_a, input_b, input_all     :SIGNED(23 DOWNTO 0) := "000000000000000000000000"; --variable for number operation
		VARIABLE current_state: state_types;

	--To Bojan, the following code can control C and D with switch 6 and 5. However simutaneous playback is not implemented yet.
	--To do so you need to superimpose my the amlitude, which means you need to add them together at the end, thus some codes need to be changed
	--GLHF!

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
						if (sw(6) = '1') then
							if(switch_c = '0') then
								input_c := not(max_amp) + 1;
							elsif(switch_c = '1') then
								input_c := max_amp - 1;
							end if;
							counter_c := counter_c + 1;
							if(counter_c = frequencies(0)) then
								counter_c := "0000000000";
								switch_c := not(switch_c);
							end if;	
						end if;
						if (sw(5) = '1') then
							if(switch_d = '0') then
								input_d := not(max_amp) + 1;
							elsif(switch_d = '1') then
								input_d := max_amp - 1;
							end if;
							counter_d := counter_d + 1;
							if(counter_d = frequencies(1)) then
								counter_d := "0000000000";
								switch_d := not(switch_d);
							end if;	
						end if;
						if (sw(4) = '1') then
							if(switch_e = '0') then
								input_e := not(max_amp) + 1;
							elsif(switch_e = '1') then
								input_e := max_amp - 1;
							end if;
							counter_e := counter_e + 1;
							if(counter_e = frequencies(2)) then
								counter_e := "0000000000";
								switch_e := not(switch_e);
							end if;	
						end if;
						if (sw(3) = '1') then
							if(switch_f = '0') then
								input_f := not(max_amp) + 1;
							elsif(switch_f = '1') then
								input_f := max_amp - 1;
							end if;
							counter_f := counter_f + 1;
							if(counter_f = frequencies(3)) then
								counter_f := "0000000000";
								switch_f := not(switch_f);
							end if;	
						end if;
						if (sw(2) = '1') then
							if(switch_g = '0') then
								input_g := not(max_amp) + 1;
							elsif(switch_g = '1') then
								input_g := max_amp - 1;
							end if;
							counter_g := counter_g + 1;
							if(counter_g = frequencies(4)) then
								counter_g := "0000000000";
								switch_g := not(switch_g);
							end if;	
						end if;
						if (sw(1) = '1') then
							if(switch_a = '0') then
								input_a := not(max_amp) + 1;
							elsif(switch_a = '1') then
								input_a := max_amp - 1;
							end if;
							counter_a := counter_a + 1;
							if(counter_a = frequencies(5)) then
								counter_a := "0000000000";
								switch_a := not(switch_a);
							end if;	
						end if;
						if (sw(0) = '1') then
							if(switch_b = '0') then
								input_b := not(max_amp) + 1;
							elsif(switch_b = '1') then
								input_b := max_amp - 1;
							end if;
							counter_b := counter_b + 1;
							if(counter_b = frequencies(6)) then
								counter_b := "0000000000";
								switch_b := not(switch_b);
							end if;	
						end if;
						input_all := input_c + input_d +  input_e +  input_f +  input_g +  input_a +  input_b;
						writedata_left <= (STD_LOGIC_VECTOR(input_all));
						writedata_right <= (STD_LOGIC_VECTOR(input_all));
						write_s <= '1';
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
