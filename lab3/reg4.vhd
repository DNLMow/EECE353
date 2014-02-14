LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- ensure components in other 'vhd' project files can be included  
LIBRARY WORK;
USE WORK.ALL;

ENTITY reg4 IS
	PORT(
		load_card : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		slow_clock : IN STD_LOGIC;
		incard : in STD_LOGIC_VECTOR(3 downto 0);
		outcard : out STD_LOGIC_VECTOR(3 downto 0)
	);
END reg4;

ARCHITECTURE DEFN of reg4 is
BEGIN
	PROCESS(slow_clock , resetb)
	BEGIN
	if (resetb = '0') then
		outcard<="0000";
	elsif (rising_edge(slow_clock) and load_card = '1') then
		outcard<=incard;
	else
	end if;
	END PROCESS;
END DEFN;	
