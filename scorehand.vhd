LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY scorehand IS
	PORT(
	   card1, card2, card3 : IN STD_LOGIC_VECTOR(3 downto 0);
		total : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0)  -- total value of hand
	);
END scorehand;


ARCHITECTURE behavioral OF scorehand IS

BEGIN

-- Your code goes here.

END;
