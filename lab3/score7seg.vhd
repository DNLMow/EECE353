LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY scoreseg7 IS
	PORT(
		score : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- score (0 to 9)
		seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- top seg 'a' = bit0, proceed clockwise
	);
END;


ARCHITECTURE behavioral OF scoreseg7 IS
BEGIN
   -- your code goes here.  Hint: this is a simple combinational block
   -- like you did in Lab 1.  If you find this difficult, you are on the
   -- wrong track.
	PROCESS(score)
	BEGIN
		IF score = "0000" THEN
			seg7 <= "1000000";
		ELSIF score="0001" THEN		-- if score is 1 display 1
			seg7 <= "1111001";
		ELSIF score="0010" THEN	-- if score is 2 display 2
			seg7 <= "0100100";
		ELSIF score="0011" THEN	-- if score is 3 display 3
			seg7 <= "0110000";
		ELSIF score="0100" THEN	-- if score is 4 display 4
			seg7 <= "0011001";
		ELSIF score="0101" THEN	-- if score is 5 display 5
			seg7 <= "0010010";
		ELSIF score="0110" THEN	-- if score is 6 display 6
			seg7 <= "0000010";
		ELSIF score="0111" THEN	-- if score is 7 display 7
			seg7 <= "1111000";
		ELSIF score="1000" THEN	-- if score is 8 display 8
			seg7 <= "0000000";
		ELSIF score="1001" THEN	-- if score is 9 display 9 (9 should look different then q)
			seg7 <= "0001000";
		ELSE							-- if score is another number display an ERROR on the 7 segment
			seg7 <= "1111111";
		END IF;
	END PROCESS;
END;
