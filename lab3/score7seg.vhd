LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY score7seg IS
	PORT(
		score : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- score (0 to 9)
		seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- top seg 'a' = bit0, proceed clockwise
	);
END;


ARCHITECTURE behavioral OF score7seg IS
BEGIN

   -- your code goes here.  Hint: this is a simple combinational block
   -- like you did in Lab 1.  If you find this difficult, you are on the
   -- wrong track.


END;
