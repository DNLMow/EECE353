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

BEGIN

    -- Your code goes here
	
END;
