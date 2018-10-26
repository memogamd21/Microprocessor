Library ieee;
Use ieee.std_logic_1164.all;

Entity MUX_4By1_16bit is 
port ( a,b,c,d : in std_logic_vector(15 DOWNTO 0);
		s : in  std_logic_vector (1 downto 0 );
		x : out std_logic_vector(15 DOWNTO 0));
end MUX_4By1_16bit;

ARCHITECTURE MUX_4By1_16bit_Arch of MUX_4By1_16bit is
BEGIN
	 x <= a WHEN S="00"
	 ELSE b WHEN S="01"
	 ELSE c WHEN S="10"
	 ELSE d WHEN S="11";

END MUX_4By1_16bit_Arch;

  