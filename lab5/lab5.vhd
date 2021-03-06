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
	signal COUNTERSUP : unsigned(25 downto 0) := "00000000000000000000000000";

	signal CLOCK_SLOW : std_logic;
	
	signal DRAW_TOP_WALL : std_logic := '1';
	signal DRAW_BOT_WALL : std_logic := '1';
	
	signal DRAW_P1G	: std_logic := '1';
	signal REDRAW_P1G : std_logic := '0';
	signal DRAW_P1F	: std_logic := '1';
	signal REDRAW_P1F : std_logic := '0';
	
	signal DRAW_P2G	: std_logic := '1';
	signal REDRAW_P2G : std_logic := '0';
	signal DRAW_P2F	: std_logic := '1';
	signal REDRAW_P2F : std_logic := '0';

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
			if (COUNTER > "00000001001001000010000000") then
						if (COUNTERSUP > "00000000000001000000000000") then
						COUNTER <= "00000000001001000010000000";
						COUNTERSUP <=    "00000000000001000000000000" - 100;
						end if;
				COUNTERSUP <= COUNTERSUP + 100;
				COUNTER <= "00000000000000000000000000" + COUNTERSUP;
				CLOCK_SLOW <= '1';
			else 
				COUNTER <= COUNTER + 1;
				CLOCK_SLOW <= '0';
			end if;
		end if;
		
	end process;
	
	-- process for the paddles and wall:
	process(CLOCK_SLOW) 
	
		variable CURRENT_STATE : unsigned(3 DOWNTO 0) := "0000";
		
		variable Y_VAR		  : unsigned(6 downto 0);
		variable X_VAR		  : unsigned(7 downto 0);
		
		variable WALL_TOP_Y : unsigned(6 downto 0);
		variable TOP_WALL   : unsigned(7 downto 0);
		
		variable WALL_BOT_Y : unsigned(6 downto 0);
		variable BOT_WALL   : unsigned(7 downto 0);
	
		variable P1_GOAL	  : unsigned(6 downto 0);
		variable P1_GOALER  : unsigned(6 downto 0);
		variable P1_GOALER2 : unsigned(6 downto 0);
		variable P1G_X		  : unsigned(7 downto 0);
		
		variable P1_FORW	  : unsigned(6 downto 0);
		variable P1_FORWER  : unsigned(6 downto 0);
		variable P1_FORWER2 : unsigned(6 downto 0);
		variable P1F_X		  : unsigned(7 downto 0);
		
		variable P2_GOAL	  : unsigned(6 downto 0);
		variable P2_GOALER  : unsigned(6 downto 0);
		variable P2_GOALER2 : unsigned(6 downto 0);
		variable P2G_X		  : unsigned(7 downto 0);
		
		variable P2_FORW 	  : unsigned(6 downto 0);
		variable P2_FORWER  : unsigned(6 downto 0);
		variable P2_FORWER2 : unsigned(6 downto 0);
		variable P2F_X		  : unsigned(7 downto 0);
		
		variable BALL_X	  : unsigned(7 downto 0);
		variable BALL_Y	  : unsigned(6 downto 0);
		
	begin 
	
		if (rising_edge(CLOCK_SLOW)) then
		
-- Clear the screen -----------------------------------------------------------------
-- Clear the screen -----------------------------------------------------------------	

		case CURRENT_STATE is 

			when "0000" => CURRENT_STATE := "0001";
-- Top wall bounds ------------------------------------------------------------------
				-- draw top wall
				WALL_TOP_Y := "0000000";
			
				-- draw top wall in the horizontal
				colour <= "111";
				if (DRAW_TOP_WALL = '1') then
					TOP_WALL := "00000000";
				else 
					TOP_WALL := TOP_WALL + 1;
				end if;
				
				-- draw top wall for whole screen in the x
				if (TOP_WALL = "10011111") then
					DRAW_TOP_WALL <= '1';
				else 
					DRAW_TOP_WALL <= '0';
				end if;

				x <= std_logic_vector(TOP_WALL(7 downto 0));
				y <= std_logic_vector(WALL_TOP_Y(6 downto 0));
				plot <= '1';
-- Top wall bounds ------------------------------------------------------------------

			when "0001" => CURRENT_STATE := "0010";
-- Bottom wall bounds ---------------------------------------------------------------
				-- draw bottom wall
				WALL_BOT_Y := "1110111";
			
				-- draw bottom wall in the horizontal
				colour <= "111";
				if (DRAW_BOT_WALL = '1') then
					BOT_WALL := "00000000";
				else 
					BOT_WALL := BOT_WALL + 1;
				end if;
				
				-- draw bottom wall for whole screen in the x
				if (BOT_WALL = "10011111") then
					DRAW_BOT_WALL <= '1';
				else 
					DRAW_BOT_WALL <= '0';
				end if;

				x <= std_logic_vector(BOT_WALL(7 downto 0));
				y <= std_logic_vector(WALL_BOT_Y(6 downto 0));
				plot <= '1';
-- Bottom wall bounds ---------------------------------------------------------------

			when "0010" => CURRENT_STATE := "0011";
-- Player 1: Goalie -----------------------------------------------------------------
				-- draw player 1 goalie with x offset of 5
				P1G_X := "00000101";
			
				-- draw player 1 goalie in the verticle
				colour <= "100";
				if (DRAW_P1G = '1' and REDRAW_P1G = '0') then
					P1_GOAL := "0000100";
				elsif (DRAW_P1G = '0' and REDRAW_P1G = '0') then
					P1_GOAL := P1_GOAL + 1;
				end if;
				
				-- draw player 1 goalie for 10 pixels in the y
				if (P1_GOAL = "0001110" and REDRAW_P1G = '0') then					
					DRAW_P1G <= '1';
					REDRAW_P1G <= '1';
				else 
					DRAW_P1G <= '0';
				end if;
							
				x <= std_logic_vector(P1G_X(7 downto 0));
				y <= std_logic_vector(P1_GOAL(6 downto 0));
				plot <= '1';
				
				if (SW(17) = '1' and REDRAW_P1G = '1') then
					P1_GOAL := P1_GOAL - 1;
					colour <= "000";
				elsif (SW(17) = '0' and REDRAW_P1G = '1') then
					P1_GOAL := P1_GOAL + 1;
				end if;
-- Player 1: Goalie -----------------------------------------------------------------

			when "0011" => CURRENT_STATE := "0100";
-- Player 1: Forward ----------------------------------------------------------------
				-- draw player 1 forward with x offset of 50
				P1F_X := "00110010";
			
				-- draw player 1 goalie in the verticle
				colour <= "100";
				if (DRAW_P1F = '1' and REDRAW_P1F = '0') then
					P1_FORW := "0000100";
				elsif (DRAW_P1F = '0' and REDRAW_P1F = '0') then
					P1_FORW := P1_FORW + 1;
				end if;
				
				-- draw player 1 goalie for 10 pixels in the y
				if (P1_FORW = "0001110" and REDRAW_P1F = '0') then					
					DRAW_P1F <= '1';
					REDRAW_P1F <= '1';
				else 
					DRAW_P1F <= '0';
				end if;
							
				x <= std_logic_vector(P1F_X(7 downto 0));
				y <= std_logic_vector(P1_FORW(6 downto 0));
				plot <= '1';
				
				if (SW(16) = '1' and REDRAW_P1F = '1') then
					P1_FORW := P1_FORW - 1;
					colour <= "000";
				elsif (SW(16) = '0' and REDRAW_P1F = '1') then
					P1_FORW := P1_FORW + 1;
				end if;
-- Player 1: Forward ----------------------------------------------------------------	
			
			when "0100" => CURRENT_STATE := "0101"; 
-- Player 2: Goalie -----------------------------------------------------------------
				-- draw player 2 goalie with x offset of -5
				P2G_X := "10011010";
			
				-- draw player 2 goalie in the verticle
				colour <= "001";
				if (DRAW_P2G = '1' and REDRAW_P2G = '0') then
					P2_GOAL := "0000100";
				elsif (DRAW_P2G = '0' and REDRAW_P2G = '0') then
					P2_GOAL := P2_GOAL + 1;
				end if;
				
				-- draw player 1 goalie for 10 pixels in the y
				if (P2_GOAL = "0001110" and REDRAW_P2G = '0') then					
					DRAW_P2G <= '1';
					REDRAW_P2G <= '1';
				else 
					DRAW_P2G <= '0';
				end if;
							
				x <= std_logic_vector(P2G_X(7 downto 0));
				y <= std_logic_vector(P2_GOAL(6 downto 0));
				plot <= '1';
				
				if (SW(0) = '1' and REDRAW_P2G = '1') then
					P2_GOAL := P2_GOAL - 1;
					colour <= "000";
				elsif (SW(0) = '0' and REDRAW_P2G = '1') then
					P2_GOAL := P2_GOAL + 1;
				end if;
-- Player 2: Goalie -----------------------------------------------------------------
			
			when "0101" => CURRENT_STATE := "0110"; 
-- Player 2: Forward ----------------------------------------------------------------
				-- draw player 2 forward with x offset of -50
				P2F_X := "01101101";
			
				-- draw player 2 forward in the verticle
				colour <= "001";
				if (DRAW_P2F = '1' and REDRAW_P2F = '0') then
					P2_FORW := "0000100";
				elsif (DRAW_P2F = '0' and REDRAW_P2F = '0') then
					P2_FORW := P2_FORW + 1;
				end if;
				
				-- draw player 1 goalie for 10 pixels in the y
				if (P2_FORW = "0001110" and REDRAW_P2F = '0') then					
					DRAW_P2F <= '1';
					REDRAW_P2F <= '1';
				else 
					DRAW_P2F <= '0';
				end if;
							
				x <= std_logic_vector(P2F_X(7 downto 0));
				y <= std_logic_vector(P2_FORW(6 downto 0));
				plot <= '1';
				
				if (SW(1) = '1' and REDRAW_P2F = '1') then
					P2_FORW := P2_FORW - 1;
					colour <= "000";
				elsif (SW(1) = '0' and REDRAW_P2F = '1') then
					P2_FORW := P2_FORW + 1;
				end if;
			
			when "0110" => CURRENT_STATE := "0111";  
-- Player 1: Goalie Erase -----------------------------------------------------------------
			-- draw player 1 goalie with x offset of 5
			
				-- draw player 1 goalie in the verticle
				colour <= "100";
				if (DRAW_P1G = '1' and REDRAW_P1G = '0') then
					P1_GOAL := "0000100";
				elsif (DRAW_P1G = '0' and REDRAW_P1G = '0') then
					P1_GOAL := P1_GOAL + 1;
				end if;
				
				-- draw player 1 goalie for 10 pixels in the y
				if (P1_GOAL = "0001110" and REDRAW_P1G = '0') then					
					DRAW_P1G <= '1';
					REDRAW_P1G <= '1';
					P1_GOALER := "0000100";
				else 
					DRAW_P1G <= '0';
				end if;
							
				x <= std_logic_vector(P1G_X(7 downto 0));
				y <= std_logic_vector(P1_GOALER(6 downto 0));
				plot <= '1';
				
				if (SW(17) = '1' and REDRAW_P1G = '1') then
					P1_GOALER:= P1_GOALER - 1;
				elsif (SW(17) = '0' and REDRAW_P1G = '1') then
					P1_GOALER := P1_GOALER + 1;
					colour <= "000";
				end if;
				
			when "0111" => CURRENT_STATE := "1000";  
-- Player 2: Goalie Erase -----------------------------------------------------------------
			-- draw player 1 goalie with x offset of 5
			
				-- draw player 1 goalie in the verticle
				colour <= "001";
				if (DRAW_P2G = '1' and REDRAW_P2G = '0') then
					P2_GOAL := "0000100";
				elsif (DRAW_P2G = '0' and REDRAW_P2G = '0') then
					P2_GOAL := P2_GOAL + 1;
				end if;
				
				-- draw player 1 goalie for 10 pixels in the y
				if (P2_GOAL = "0001110" and REDRAW_P2G = '0') then					
					DRAW_P2G <= '1';
					REDRAW_P2G <= '1';
					P2_GOALER := "0000100";
				else 
					DRAW_P2G <= '0';
				end if;
							
				x <= std_logic_vector(P2G_X(7 downto 0));
				y <= std_logic_vector(P2_GOALER(6 downto 0));
				plot <= '1';
				
				if (SW(0) = '1' and REDRAW_P2G = '1') then
					P2_GOALER:= P2_GOALER - 1;
				elsif (SW(0) = '0' and REDRAW_P2G = '1') then
					P2_GOALER := P2_GOALER + 1;
					colour <= "000";
				end if;
-- Player 1: Goalie Erase -----------------------------------------------------------------

			when "1000" => CURRENT_STATE := "1001";  
-- Player 2: Goalie Erase -----------------------------------------------------------------
			-- draw player 1 goalie with x offset of 5
			
				-- draw player 1 goalie in the verticle
				colour <= "100";
				if (DRAW_P1F = '1' and REDRAW_P1F = '0') then
					P1_FORW := "0000100";
				elsif (DRAW_P1F = '0' and REDRAW_P1F = '0') then
					P1_FORW := P1_FORW + 1;
				end if;
				
				-- draw player 1 goalie for 10 pixels in the y
				if (P1_FORW = "0001110" and REDRAW_P1F = '0') then					
					DRAW_P1F <= '1';
					REDRAW_P1F <= '1';
					P1_FORWER := "0000100";
				else 
					DRAW_P1F <= '0';
				end if;
							
				x <= std_logic_vector(P1F_X(7 downto 0));
				y <= std_logic_vector(P1_FORWER(6 downto 0));
				plot <= '1';
				
				if (SW(16) = '1' and REDRAW_P1F = '1') then
					P1_FORWER:= P1_FORWER - 1;
				elsif (SW(16) = '0' and REDRAW_P1F = '1') then
					P1_FORWER := P1_FORWER + 1;
					colour <= "000";
				end if;
-- Player 1: Goalie Erase -----------------------------------------------------------------
			
	when "1001" => CURRENT_STATE := "1010";  
-- Player 2: Goalie Erase -----------------------------------------------------------------
			-- draw player 1 goalie with x offset of 5
			
				-- draw player 1 goalie in the verticle
				colour <= "001";
				if (DRAW_P2F = '1' and REDRAW_P2F = '0') then
					P2_FORW := "0000100";
				elsif (DRAW_P2F = '0' and REDRAW_P2F = '0') then
					P2_FORW := P2_FORW + 1;
				end if;
				
				-- draw player 1 goalie for 10 pixels in the y
				if (P2_FORW = "0001110" and REDRAW_P2F = '0') then					
					DRAW_P2F <= '1';
					REDRAW_P2F <= '1';
					P2_FORWER := "0000100";
				else 
					DRAW_P2F <= '0';
				end if;
							
				x <= std_logic_vector(P2F_X(7 downto 0));
				y <= std_logic_vector(P2_FORWER(6 downto 0));
				plot <= '1';
				
				if (SW(1) = '1' and REDRAW_P2F = '1') then
					P2_FORWER:= P2_FORWER - 1;
				elsif (SW(1) = '0' and REDRAW_P2F = '1') then
					P2_FORWER := P2_FORWER + 1;
					colour <= "000";
				end if;

when "1010" => CURRENT_STATE := "1011"; 
				colour <= "011";
				
				BALL_X := "01001111";
				BALL_Y := "0111011";
				
				x <= std_logic_vector(BALL_X(7 downto 0));
				y <= std_logic_vector(BALL_Y(6 downto 0));
				plot <= '1';
-- Player 1: Goalie Erase2 -----------------------------------------------------------------
--			-- draw player 1 goalie with x offset of 5
--				P1G_X := "00000101";
--				
--				if (SW(17) = '1' and REDRAW_P1G = '1') then
--					P1_GOALER2:= P1_GOAL + 1;
--					colour <= "000";
--				elsif (SW(17) = '0' and REDRAW_P1G = '1') then
--					P1_GOALER2:= P1_GOALER - 1;
--					colour <= "000";
--				end if;
--							
--				x <= std_logic_vector(P1G_X(7 downto 0));
--				y <= std_logic_vector(P1_GOALER2(6 downto 0));
--				plot <= '1';
-- Player 1: Goalie Erase2 -----------------------------------------------------------------
			
			when others => CURRENT_STATE := "0000";
			
		end case;
			
		end if;
		
	end process;
				
end RTL;


