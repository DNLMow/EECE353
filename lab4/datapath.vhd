library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
 port (
			 initx                                      : in  std_logic;
          clock                                        : in  std_logic;
          inity                                       : in  std_logic;
          x                                            : out  std_logic_vector(7 downto 0);
          y                                            : out std_logic_vector(6 downto 0);
          xdone													 : out  std_logic;
			    ydone													 : out  std_logic);
end datapath;

architecture path of datapath is
begin

process ( clock )
	
	variable x_out : unsigned( 7 downto 0 );
	variable y_out : unsigned( 6 downto 0 );
	
	begin 
	
		if ( rising_edge(clock) ) then
	if	(inity = '1') then
	y_out := "0000000";
	else
	y_out := y_out+1;
	end if;
	if (initx='1')then
	x_out:= "00000000";
	else
	x_out := x_out+1;
	end if;
	ydone <= '0';
	xdone <= '0';
	if (y_out = 119) then
		ydone <= '1';
	end if;
	if (x_out = 159) then 
		xdone <= '1';
	end if;
	end if;
	
	x<= std_logic_vector(x_out);
	y<= std_logic_vector(y_out);
						
	end process;
	
	
	
end path;