LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- ensure components in other 'vhd' project files can be included  
LIBRARY WORK;
USE WORK.ALL;

ENTITY statemachine IS
	PORT(

	   slow_clock : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		
		dscore, pscore : IN STD_LOGIC_VECTOR(3 downto 0);
		pcard3 : IN STD_LOGIC_VECTOR(3 downto 0);
		
		load_pcard1, load_pcard2, load_pcard3 : OUT STD_LOGIC;
		load_dcard1, load_dcard2, load_dcard3 : OUT STD_LOGIC;
		
  		LEDG : OUT STD_LOGIC_VECTOR(1 downto 0)	
	);
END statemachine;


ARCHITECTURE behavioural OF statemachine IS
type state_types is ( PT1, BT1, PT2, BT2, PT3, BT3, CI, GO);
signal state : state_types;
BEGIN

PROCESS(slow_clock,resetb)
	VARIABLE currentstate: state_types;
BEGIN
	
	IF (resetb='0') THEN
		currentstate := PT1;
	ELSIF(rising_edge(slow_clock)) THEN
		currentstate :=state;
		
		CASE currentstate IS
			WHEN PT1 => currentstate:=BT1; 	
			WHEN BT1 => currentstate:=PT2;	
			WHEN PT2 => currentstate:=BT2;
			WHEN BT2 => IF(pscore ="1000")THEN
							currentstate:=CI;
							ELSIF (pscore ="1001") THEN
								currentstate:=CI;
							ELSIF (dscore ="1000") THEN
								currentstate:=CI;
							ELSIF (dscore ="1001") THEN
								currentstate:=CI;
							ELSIF ((pscore="0111")or (pscore="0110") ) THEN
									CASE dscore IS
										WHEN "0000" =>currentstate:=BT3;
										WHEN "0001" =>currentstate:=BT3;
										WHEN "0010" =>currentstate:=BT3;
										WHEN "0011" =>currentstate:=BT3;
										WHEN "0100" =>currentstate:=BT3;
										WHEN "0101" =>currentstate:=BT3;
										WHEN OTHERS =>currentstate:=CI;
									END CASE;
							ELSE
									currentstate:=PT3;
							END IF;
			WHEN PT3 => IF(dscore="0111")THEN --dealer score 7 not get card
										currentstate :=CI;
							ELSIF((dscore="0000") or (dscore="0001") or (dscore="0010")) THEN --dealer score 0,1,2 take a card
										currentstate :=BT3;
							ELSIF(dscore="0110") THEN
											CASE pcard3 IS
												WHEN "0110" => currentstate:=BT3;
												WHEN "0111" => currentstate:=BT3;
												WHEN OTHERS => currentstate:=CI;
											END CASE;
							ELSIF(dscore="0101")THEN
											CASE pcard3 IS
												WHEN "0100" => currentstate:=BT3;
												WHEN "0101" => currentstate:=BT3;
												WHEN "0110" => currentstate:=BT3;
												WHEN "0111" => currentstate:=BT3;
												WHEN OTHERS => currentstate:=CI;
											END CASE;
							ELSIF(dscore="0100")THEN
											CASE pcard3 IS
												WHEN "0010" => currentstate:=BT3;
												WHEN "0011" => currentstate:=BT3;
												WHEN "0100" => currentstate:=BT3;
												WHEN "0101" => currentstate:=BT3;
												WHEN "0110" => currentstate:=BT3;
												WHEN "0111" => currentstate:=BT3;
												WHEN OTHERS => currentstate:=CI;
											END CASE;
							ELSIF(dscore="0011")THEN
											CASE pcard3 IS
												WHEN "1000" => currentstate:=CI;
												WHEN OTHERS => currentstate:=BT3;
											END CASE;
							ELSE
								currentstate:=CI;
							END IF;
							
--**********************************************************************
--			WHEN BT2 => currentstate:=PT3;	
--			WHEN PT3 => currentstate:=BT3;	
--**********************************************************************
			WHEN BT3 => currentstate:=CI;		
			WHEN CI => currentstate:=GO;
			WHEN GO => currentstate := GO;
			WHEN others => currentstate:= PT1;
		END CASE;
	END IF;
state <= currentstate;
END PROCESS;

PROCESS(state)
variable d: unsigned(3 downto 0);
variable p: unsigned(3 downto 0);
BEGIN
	d:= unsigned(dscore);
	p:= unsigned(pscore);
	CASE state IS
			WHEN PT1 => ledG<="00";
							load_pcard1<='1';
							load_dcard1<='0';
							load_pcard2<='0';
							load_dcard2<='0';
							load_pcard3<='0';
							load_dcard3<='0';
			WHEN BT1 => ledG<="00";
							load_pcard1<='0';
							load_dcard1<='1';
							load_pcard2<='0';
							load_dcard2<='0';
							load_pcard3<='0';
							load_dcard3<='0';
			WHEN PT2 => ledG<="00";
							load_dcard1<='0';
							load_pcard2<='1';
							load_pcard1<='0';
							load_dcard2<='0';
							load_pcard3<='0';
							load_dcard3<='0';
			WHEN BT2 => ledG<="00";
							load_pcard2<='0';
							load_dcard2<='1';
							load_pcard1<='0';
							load_dcard1<='0';
							load_pcard3<='0';
							load_dcard3<='0';
			WHEN PT3 => ledG<="00";
							load_dcard2<='0';
							load_pcard3<='1';
							load_pcard1<='0';
							load_dcard1<='0';
							load_pcard2<='0';
							load_dcard3<='0';
			WHEN BT3 => ledG<="00";
							load_pcard3<='0';
							load_dcard3<='1';
							load_pcard1<='0';
							load_dcard1<='0';
							load_pcard2<='0';
							load_dcard2<='0';
							
			WHEN CI => 	load_pcard1<='0';
							load_dcard1<='0';
							load_pcard2<='0';
							load_dcard2<='0';
							load_pcard3<='0';
							load_dcard3<='0';
							IF (d < p)THEN
								ledG<="01";
							ELSIF (d > p)THEN
								ledG<="10";
							ELSE
								ledG<="11";
							END IF;
			WHEN GO =>	IF (d < p)THEN
								ledG<="01";
							ELSIF (d > p)THEN
								ledG<="10";
							ELSE
								ledG<="11";
							END IF;
	END CASE;
END PROCESS;
END;
