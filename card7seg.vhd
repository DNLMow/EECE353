LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY card7seg IS
	PORT(
		card : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- card type (Ace, 2..10, J, Q, K)
		seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- top seg 'a' = bit0, proceed clockwise
	);
END;


ARCHITECTURE behavioral OF card7seg IS
BEGIN

   -- your code goes here.  Hint: this is a simple combinational block
   -- like you did in Lab 1.  If you find this difficult, you are on the
   -- wrong track.

END;
