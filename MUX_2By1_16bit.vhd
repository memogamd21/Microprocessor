Library ieee;
Use ieee.std_logic_1164.all;

Entity MUX_2By1_16bit is 
port ( a,b  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		s	: IN  STD_LOGIC  ;
		x   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
end MUX_2By1_16bit;

Architecture MUX_2By1_16bit_Arch of MUX_2By1_16bit is
begin
	 x <= a WHEN S='0'
	   ELSE b;

end MUX_2By1_16bit_Arch;