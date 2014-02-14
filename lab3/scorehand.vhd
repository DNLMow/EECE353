LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY scorehand IS
	PORT(
	   card1, card2, card3 : IN STD_LOGIC_VECTOR(3 downto 0);
		total : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)  -- total value of hand
	);
END scorehand;


ARCHITECTURE behavioral OF scorehand IS

BEGIN

-- Your code goes here.
	PROCESS( card1, card2, card3 ) 
	
	VARIABLE card1_value : STD_LOGIC_VECTOR(3 DOWNTO 0);
	VARIABLE card2_value : STD_LOGIC_VECTOR(3 DOWNTO 0);
	VARIABLE card3_value : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	BEGIN
	
-- card1 control statements 
		IF 	card1="0000" THEN		-- if card1 is 0 the card1_value is 0
			card1_value := "0000";	
		ELSIF card1="0001" THEN		-- if card1 is 1 (Ace) the card1_value is 1
			card1_value := "0001";
		ELSIF card1="0010" THEN		-- if card1 is 2 the card1_value is 2
			card1_value := "0010";
		ELSIF card1="0011" THEN		-- if card1 is 3 the card1_value is 3
			card1_value := "0011";
		ELSIF card1="0100" THEN		-- if card1 is 4 the card1_value is 4
			card1_value := "0100";
		ELSIF card1="0101" THEN		-- if card1 is 5 the card1_value is 5
			card1_value := "0101";
		ELSIF card1="0110" THEN		-- if card1 is 6 the card1_value is 6
			card1_value := "0110";
		ELSIF card1="0111" THEN		-- if card1 is 7 the card1_value is 7
			card1_value := "0111";
		ELSIF card1="1000" THEN		-- if card1 is 8 the card1_value is 8
			card1_value := "1000";
		ELSIF card1="1001" THEN		-- if card1 is 9 the card1_value is 9
			card1_value := "1001";
		ELSIF card1="1010" THEN 	-- if card1 is 10 the card1_value is 0
			card1_value := "0000";
		ELSIF card1="1011" THEN	 	-- if card1 is 11 (Jack) the card1_value is 0
			card1_value := "0000";
		ELSIF card1="1100" THEN 	-- if card1 is 12 (Queen) the card1_value is 0
			card1_value := "0000";
		ELSIF card1="1101" THEN 	-- if card1 is 13 (King) the card1_value is 0
			card1_value := "0000";
		ELSE								-- everything else is an error
			card1_value := "0000";
		END IF;	
	
-- card2 control statements	
		IF 	card2="0000" THEN		-- if card2 is 0 the card2_value is 0
			card2_value := "0000";	
		ELSIF card2="0001" THEN		-- if card2 is 1 (Ace) the card2_value is 1
			card2_value := "0001";
		ELSIF card2="0010" THEN		-- if card2 is 2 the card2_value is 2
			card2_value := "0010";
		ELSIF card2="0011" THEN		-- if card2 is 3 the card2_value is 3
			card2_value := "0011";
		ELSIF card2="0100" THEN		-- if card2 is 4 the card2_value is 4
			card2_value := "0100";
		ELSIF card2="0101" THEN		-- if card2 is 5 the card2_value is 5
			card2_value := "0101";
		ELSIF card2="0110" THEN		-- if card2 is 6 the card2_value is 6
			card2_value := "0110";
		ELSIF card2="0111" THEN		-- if card2 is 7 the card2_value is 7
			card2_value := "0111";
		ELSIF card2="1000" THEN		-- if card2 is 8 the card2_value is 8
			card2_value := "1000";
		ELSIF card2="1001" THEN		-- if card2 is 9 the card2_value is 9
			card2_value := "1001";
		ELSIF card2="1010" THEN 	-- if card2 is 10 the card2_value is 0
			card2_value := "0000";
		ELSIF card2="1011" THEN	 	-- if card2 is 11 (Jack) the card2_value is 0
			card2_value := "0000";
		ELSIF card2="1100" THEN 	-- if card2 is 12 (Queen) the card2_value is 0
			card2_value := "0000";
		ELSIF card2="1101" THEN 	-- if card2 is 13 (King) the card2_value is 0
			card2_value := "0000";
		ELSE								-- everything else is an error
			card2_value := "0000";
		END IF;	

		-- card3 control statements	
		IF 	card3="0000" THEN		-- if card3 is 0 the card3_value is 0
			card3_value := "0000";	
		ELSIF card3="0001" THEN		-- if card3 is 1 (Ace) the card3_value is 1
			card3_value := "0001";
		ELSIF card3="0010" THEN		-- if card3 is 2 the card3_value is 2
			card3_value := "0010";
		ELSIF card3="0011" THEN		-- if card3 is 3 the card3_value is 3
			card3_value := "0011";
		ELSIF card3="0100" THEN		-- if card3 is 4 the card3_value is 4
			card3_value := "0100";
		ELSIF card3="0101" THEN		-- if card3 is 5 the card3_value is 5
			card3_value := "0101";
		ELSIF card3="0110" THEN		-- if card3 is 6 the card3_value is 6
			card3_value := "0110";
		ELSIF card3="0111" THEN		-- if card3 is 7 the card3_value is 7
			card3_value := "0111";
		ELSIF card3="1000" THEN		-- if card3 is 8 the card3_value is 8
			card3_value := "1000";
		ELSIF card3="1001" THEN		-- if card3 is 9 the card3_value is 9
			card3_value := "1001";
		ELSIF card3="1010" THEN 	-- if card3 is 10 the card3_value is 0
			card3_value := "0000";
		ELSIF card3="1011" THEN	 	-- if card3 is 11 (Jack) the card3_value is 0
			card3_value := "0000";
		ELSIF card3="1100" THEN 	-- if card3 is 12 (Queen) the card3_value is 0
			card3_value := "0000";
		ELSIF card3="1101" THEN 	-- if card3 is 13 (King) the card3_value is 0
			card3_value := "0000";
		ELSE								-- everything else, if the third card isn't drawn
			card3_value := "0000";
		END IF;	
		
	total <= STD_LOGIC_VECTOR((UNSIGNED(card1_value) + UNSIGNED(card2_value) + UNSIGNED(card3_value)) MOD 10);
	END PROCESS;

END;
