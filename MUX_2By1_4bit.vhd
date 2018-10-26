Library ieee;
Use ieee.std_logic_1164.all;

ENTITY MUX_2By1_4bit IS 
PORT ( a,b  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		s	: IN  STD_LOGIC  ;
		x   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END MUX_2By1_4bit;

ARCHITECTURE MUX_2By1_4bit_Arch of MUX_2By1_4bit is
BEGIN
	 
	 x <= a WHEN S='0'
	   ELSE b;
	 
END MUX_2By1_4bit_Arch;