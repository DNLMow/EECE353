LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- ensure components in other 'vhd' project files can be included  
LIBRARY WORK;
USE WORK.ALL;

--ENTITY reg4 IS
--	PORT(
--		load_card : IN STD_LOGIC;
--		resetb : IN STD_LOGIC;
--		slow_clock : IN STD_LOGIC;
--		incard : in STD_LOGIC_VECTOR(3 downto 0);
--		outcard : out STD_LOGIC_VECTOR(3 downto 0)
--	);
--END reg4;
--
--ARCHITECTURE DEFN of reg4 is
--BEGIN
--	PROCESS(slow_clock , resetb)
--	BEGIN
--	if (resetb = '0') then
--		outcard<="0000";
--	elsif (rising_edge(slow_clock) and load_card = '1') then
--		outcard<=incard;
--	else
--	end if;
--	END PROCESS;
--END DEFN;	

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
	component scoreseg7
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
	component reg4
		PORT(
		load_card : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		slow_clock : IN STD_LOGIC;
		incard : in STD_LOGIC_VECTOR(3 downto 0);
		outcard : out STD_LOGIC_VECTOR(3 downto 0)
		);
	end component;
	
	 SIGNAL new_card_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
	 SIGNAL pcard1_out_sig,pcard2_out_sig,pcard3_out_sig :  STD_LOGIC_VECTOR(3 DOWNTO 0);
	 SIGNAL dcard1_out_sig,dcard2_out_sig,dcard3_out_sig :  STD_LOGIC_VECTOR(3 DOWNTO 0);
	 SIGNAL pscore_out_sig,dscore_out_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN

    -- Your code goes here
	A1: dealcard
	port map(clock=>fast_clock , resetb=>resetb , new_card=> new_card_sig);
	P1: reg4
	port map(load_card=>load_pcard1,resetb=>resetb,slow_clock=>slow_clock,incard=>new_card_sig,outcard=>pcard1_out_sig);
	P2: reg4
	port map(load_card=>load_pcard2,resetb=>resetb,slow_clock=>slow_clock,incard=>new_card_sig,outcard=>pcard2_out_sig);
	P3: reg4
	port map(load_card=>load_pcard3,resetb=>resetb,slow_clock=>slow_clock,incard=>new_card_sig,outcard=>pcard3_out);
	D1: reg4
	port map(load_card=>load_dcard1,resetb=>resetb,slow_clock=>slow_clock,incard=>new_card_sig,outcard=>dcard1_out_sig);
	D2: reg4
	port map(load_card=>load_dcard2,resetb=>resetb,slow_clock=>slow_clock,incard=>new_card_sig,outcard=>dcard2_out_sig);
	D3: reg4
	port map(load_card=>load_dcard3,resetb=>resetb,slow_clock=>slow_clock,incard=>new_card_sig,outcard=>dcard3_out_sig);
	S1: card7seg
	port map(card=>pcard1_out_sig,seg7=>HEX0);
	S2: card7seg
	port map(card=>pcard2_out_sig,seg7=>HEX1);
	S3: card7seg
	port map(card=>pcard3_out_sig,seg7=>HEX2);
	S4: card7seg
	port map(card=>dcard1_out_sig,seg7=>HEX4);
	S5: card7seg
	port map(card=>dcard2_out_sig,seg7=>HEX5);
	S6: card7seg
	port map(card=>dcard3_out_sig,seg7=>HEX6);
	H1: scorehand
	port map(card1=>pcard1_out_sig,card2=>pcard2_out_sig,card3=>pcard3_out_sig,total=>pscore_out);
	H2: scorehand
	port map(card1=>dcard1_out_sig,card2=>dcard2_out_sig,card3=>dcard3_out_sig,total=>dscore_out);
	C1: scoreseg7
	port map(score=>pscore_out_sig,seg7=>HEX3);
	C2: scoreseg7
	port map(score=>dscore_out_sig,seg7=>HEX7);
END mixed;
