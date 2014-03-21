library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab5 is
  port(	
			CLOCK_50            : in  std_logic;
			KEY                 : in  std_logic_vector(3 downto 0);
			SW                  : in  std_logic_vector(17 downto 0);
			VGA_R, VGA_G, VGA_B : out std_logic_vector(9 downto 0);  -- The outs go to VGA controller
			VGA_HS              : out std_logic;
			VGA_VS              : out std_logic;
			VGA_BLANK           : out std_logic;
			VGA_SYNC            : out std_logic;
			VGA_CLK             : out std_logic
		 );
end lab5;

architecture RTL of lab5 is

	-- Component from the Verilog file: vga_adapter.v
	component vga_adapter
		generic(RESOLUTION : string);
		port (
					resetn													:	in  std_logic;
					clock														:	in  std_logic;
					colour                                       :	in  std_logic_vector(2 downto 0);
					x                                            :	in  std_logic_vector(7 downto 0);
					y                                            :	in  std_logic_vector(6 downto 0);
					plot                                         :	in  std_logic;
					VGA_R, VGA_G, VGA_B                          :	out std_logic_vector(9 downto 0);
					VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_CLK	:	out std_logic
				);
	end component;
		
	signal x      : std_logic_vector(7 downto 0);
	signal y      : std_logic_vector(6 downto 0);
	signal colour : std_logic_vector(2 downto 0);
	signal plot   : std_logic;
	signal clk 	  : std_logic;
	-- added signals below
	signal INITY  		: std_logic := '1';
	signal INITX  		: std_logic := '1';
	signal COUNTER		: unsigned(25 downto 0) := "00000000000000000000000000";
	signal CLOCK_SLOW : std_logic;
	
	signal DRAW_P1G	: std_logic := '1';
begin 
	
	-- includes the vga adapter, which should be in your project 
	vga_u0 : vga_adapter
		generic map(RESOLUTION => "160x120") 
		port map(
						resetn		=> KEY(3),
						clock			=> CLOCK_50,
						colour		=> colour,
						x				=> x,
						y				=> y,
						plot			=> plot,
						VGA_R			=> VGA_R,
						VGA_G			=> VGA_G,
						VGA_B			=> VGA_B,
						VGA_HS		=> VGA_HS,
						VGA_VS		=> VGA_VS,
						VGA_BLANK	=> VGA_BLANK,
						VGA_SYNC 	=> VGA_SYNC,
						VGA_CLK   	=> VGA_CLK
					);
					
	process(CLOCK_50)
	
	begin
	
		if (rising_edge(CLOCK_50)) then
			if (COUNTER = "00000000001001000010000000") then
				COUNTER <= "00000000000000000000000000";
				CLOCK_SLOW <= '1';
			else 
				COUNTER <= COUNTER + 1;
				CLOCK_SLOW <= '0';
			end if;
		end if;
		
	end process;
	
	-- process for the paddles:
	process(CLOCK_SLOW) 
	
		variable P1_GOAL	: unsigned(6 downto 0);
		
	begin 
	
-- Player 1: Goalie -----------------------------------------------------------------
		if (rising_edge(CLOCK_SLOW)) then
			if (DRAW_P1G = '1') then
				P1_GOAL := "0001000";
			else 
				P1_GOAL := P1_GOAL + 1;
			end if;
			
			if (P1_GOAL = "0011110") then
				DRAW_P1G <= '1';
			else 
				DRAW_P1G <= '0';
			end if;
			
		end if;
		
		colour <= "111";
		y <= std_logic_vector(P1_GOAL(6 downto 0));
		plot <= '1';
-- Player 1: Goalie -----------------------------------------------------------------	
		
	end process;
		
--	process(CLOCK_SLOW)
--	
--		variable Y_VAR		: unsigned(7 downto 0);
--		variable X_VAR		: unsigned(8 downto 0);
--		
--	begin
--					
--		-- This if block is to fill entire screen
--		if (rising_edge(CLOCK_SLOW)) then 
--			
--			if (INITY = '1') then 
--				Y_VAR := "00000000";
--			else
--				Y_VAR := Y_VAR + 1;
--			end if;
--			
--			if (INITX = '1') then 
--				X_VAR := "000000000";
--			elsif (Y_VAR = "1110111") then
--				X_VAR := X_VAR + 1;
--			end if;
--			
--			if (Y_VAR = "1110111") then 
--				INITY <= '1';
--			else 
--				INITY <= '0';
--			end if;
--			
--			if (X_VAR = "10011111") then
--				INITX <= '1';
--			else
--				INITX <= '0';
--			end if;
--			
--			colour <= "111";
--			x <= std_logic_vector(X_VAR(7 downto 0));
--			y <= std_logic_vector(Y_VAR(6 downto 0));
--			plot <= '1';
--			
--		end if;
--		
--		end process;
		
end RTL;


