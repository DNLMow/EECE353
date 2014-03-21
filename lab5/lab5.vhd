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
	signal DRAW_P1F	: std_logic := '1';
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
	
--	-- process for the paddles:
--	process(CLOCK_SLOW) 
--	
--		variable CURRENT_STATE : unsigned(3 DOWNTO 0) := "0000";
--	
--		variable P1_GOAL	: unsigned(6 downto 0);
--		variable P1G_X		: unsigned(7 downto 0);
--		
--		variable P1_FORW	: unsigned(6 downto 0);
--		variable P1F_X		: unsigned(7 downto 0);
--		
--	begin 
--	
--		if (rising_edge(CLOCK_SLOW)) then
--		
--		if (key(3) = '0') then
--			CURRENT_STATE := "0000";
--		end if;
--		
--		case CURRENT_STATE is 
-- Player 1: Goalie -----------------------------------------------------------------
--			when "0000" => CURRENT_STATE := "0001";
--				-- draw player 1 goalie with x offset of 5
--				colour <= "111";
--				P1G_X := "00000101";
--			
--				-- draw player 1 goalie in the verticle
--				colour <= "100";
--				if (DRAW_P1G = '1') then
--					P1_GOAL := "0000100";
--				else 
--					P1_GOAL := P1_GOAL + 1;
--				end if;
--				
--				-- draw player 1 goalie for 10 pixels in the y
--				if (P1_GOAL = "0001110") then
--					DRAW_P1G <= '1';
--				else 
--					DRAW_P1G <= '0';
--				end if;
--				
--				colour <= "100";
--				x <= std_logic_vector(P1G_X(7 downto 0));
--				y <= std_logic_vector(P1_GOAL(6 downto 0));
--				plot <= '1';
-- Player 1: Goalie -----------------------------------------------------------------	
--
-- Player 1: Forward ----------------------------------------------------------------
--			when "0001" => CURRENT_STATE := "0010";
--				-- draw player 1 forward with x offset of 15
--				colour <= "111";
--				P1F_X := "00001111";
--			
--				-- draw player 1 forward in the verticle
--				colour <= "100";
--				if (DRAW_P1F = '1') then
--					P1_FORW := "0000100";
--				else 
--					P1_FORW := P1_FORW + 1;
--				end if;
--				
--				-- draw player 1 forward for 10 pixels in the y
--				if (P1_FORW = "0001110") then
--					DRAW_P1F <= '1';
--				else 
--					DRAW_P1F <= '0';
--				end if;
--				
--				colour <= "100";
--				x <= std_logic_vector(P1F_X(7 downto 0));
--				y <= std_logic_vector(P1_FORW(6 downto 0));
--				plot <= '1';
-- Player 1: Forward ----------------------------------------------------------------				
--			when others => CURRENT_STATE := "0001"; 
--			
--			end case;
--			
--		end if;
--		
--	end process;
		
	process(CLOCK_SLOW)
	
		variable Y_VAR		: unsigned(6 downto 0);
		variable X_VAR		: unsigned(7 downto 0);
		
	begin
					
		-- This if block is to fill entire screen
		if (falling_edge(CLOCK_SLOW)) then 
			
			if (INITY = '1') then 
				Y_VAR := "0000000";
			else
				Y_VAR := Y_VAR + 1;
			end if;
			
			if (INITX = '1') then 
				X_VAR := "00000000";
			end if;
			
			if (Y_VAR = "1110111") then 
				INITY <= '1';
			else 
				INITY <= '0';
			end if;
			
			if (X_VAR = "10011111" and Y_VAR = "1110111") then
				INITX <= '1';
			else
				INITX <= '0';
			end if;
			
			colour <= "100";
			x <= std_logic_vector(X_VAR(7 downto 0));
			y <= std_logic_vector(Y_VAR(6 downto 0));
			plot <= '1';
			
			if (Y_VAR = "1110111") then
			X_VAR := X_VAR + 1;
			end if;
			
		end if;
		
		end process;
		
end RTL;


