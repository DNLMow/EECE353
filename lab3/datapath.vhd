LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- ensure components in other 'vhd' project files can be included  
LIBRARY WORK;
USE WORK.ALL;

ENTITY datapath IS
	PORT(

	   slow_clock : IN STD_LOGIC;
		fast_clock : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		load_pcard1, load_pcard2, load_pcard3 : IN STD_LOGIC;
		load_dcard1, load_dcard2, load_dcard3 : IN STD_LOGIC;
		
		dscore_out, pscore_out : out STD_LOGIC_VECTOR(3 downto 0);
		pcard3_out	: out STD_LOGIC_VECTOR(3 downto 0);
		
		HEX7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 7
		HEX6 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 6
		HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 5
		HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 4
		HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 3
		HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 2
		HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 1
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- digit 0
	);
END datapath;


ARCHITECTURE mixed OF datapath IS

	component dealcard
		PORT(
		clock : IN  STD_LOGIC;
		resetb : IN  STD_LOGIC; 
		new_card  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)   -- new card to deal
		);
	end component;
	component scorehand
		PORT(
		card1, card2, card3 : IN STD_LOGIC_VECTOR(3 downto 0);
		total : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0)  -- total value of hand
		);
	end component;
	component score7seg
		PORT(
		score : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- score (0 to 9)
		seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- top seg 'a' = bit0, proceed clockwise
		);
	end component;
	component card7seg
		PORT(
		card : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- card type (Ace, 2..10, J, Q, K)
		seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- top seg 'a' = bit0, proceed clockwise
		);
	end component;
	component PCard1
		PORT(
		load_pcard1 : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		slow_clock : IN STD_LOGIC;
		pcard1 : out STD_LOGIC_VECTOR(3 downto 0)
		);
	end component;
	component PCard2
		PORT(
		load_pcard2 : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		slow_clock : IN STD_LOGIC;
		pcard2 : out STD_LOGIC_VECTOR(3 downto 0)
		);
	end component;
	component PCard3
		PORT(
		load_pcard3 : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		slow_clock : IN STD_LOGIC;
		pcard3 : out STD_LOGIC_VECTOR(3 downto 0)
		);
	end component;
	component DCard1
		PORT(
		load_dcard1 : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		slow_clock : IN STD_LOGIC;
		dcard1 : out STD_LOGIC_VECTOR(3 downto 0)
		);
	end component;
	component DCard2
		PORT(
		load_dcard2 : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		slow_clock : IN STD_LOGIC;
		dcard2 : out STD_LOGIC_VECTOR(3 downto 0)
		);
	end component;
	component DCard3
		PORT(
		load_dcard3 : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		slow_clock : IN STD_LOGIC;
		dcard3 : out STD_LOGIC_VECTOR(3 downto 0)
		);
	end component;
	
	 SIGNAL new_card_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
	 SIGNAL pcard1_out_sig,pcard2_out_sig,pcard3_out_sig :  STD_LOGIC_VECTOR(3 DOWNTO 0);
	 SIGNAL dcard1_out_sig,dcard2_out_sig,dcard3_out_sig :  STD_LOGIC_VECTOR(3 DOWNTO 0);
	 SIGNAL pscore_out_sig,dscore_out_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
	 
BEGIN

    -- Your code goes here
	
END;
