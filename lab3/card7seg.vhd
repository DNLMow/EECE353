LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY card7seg IS
	PORT(
		card : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- card type (Ace, 2..10, J, Q, K)
		seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- top seg 'a' = bit0, proceed clockwise
	);
END;


ARCHITECTURE behavioral OF card7seg IS

	SIGNAL	to7seg : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

   -- your code goes here.  Hint: this is a simple combinational block
   -- like you did in Lab 1.  If you find this difficult, you are on the
   -- wrong track.
	PROCESS( card )
	BEGIN
		IF card="0001" THEN		-- if card is 1 display A
			to7seg <= "0001000";
		ELSIF card="0010" THEN	-- if card is 2 display 2
			to7seg <= "0010010";
		ELSIF card="0011" THEN	-- if card is 3 display 3
			to7seg <= "0000110";
		ELSIF card="0100" THEN	-- if card is 4 display 4
			to7seg <= "1001100";
		ELSIF card="0101" THEN	-- if card is 5 display 5
			to7seg <= "0100100";
		ELSIF card="0110" THEN	-- if card is 6 display 6
			to7seg <= "0100000";
		ELSIF card="0111" THEN	-- if card is 7 display 7
			to7seg <= "0001111";
		ELSIF card="1000" THEN	-- if card is 8 display 8
			to7seg <= "0000000";
		ELSIF card="1001" THEN	-- if card is 9 display 9 (9 should look different then q)
			to7seg <= "0000100";				
		ELSIF card="1010" THEN	-- if card is 10 display 0
			to7seg <= "0000001";
		ELSIF card="1011" THEN	-- if card is 11 display J
			to7seg <= "0000011";
		ELSIF card="1100" THEN	-- if card is 12 display q (q should look different than 9)
			to7seg <= "0001100";
		ELSIF card="1101" THEN	-- if card is 13 display H
			to7seg <= "1001000";
		ELSE							-- if card is another number display an ERROR on the 7 segment
			to7seg <= "0110110";
		END IF;
	END PROCESS;
	
	seg7 <= to7seg;
	
END;
