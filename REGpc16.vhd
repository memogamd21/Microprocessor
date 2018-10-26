LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE     IEEE.std_logic_unsigned.ALL;

ENTITY REGpc16 IS
	PORT( Clk,Rst,Load     : IN std_logic;
		  INC,DEC,CLR,STO  : IN STD_LOGIC;
		  d : IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
END REGpc16;

ARCHITECTURE REGpc16_Arch OF REGpc16 IS
SIGNAL data : STD_LOGIC_VECTOR (15 DOWNTO 0);

	BEGIN
		PROCESS (Clk,Rst)

			BEGIN

				IF Rst = '1' THEN
					data <= (OTHERS=>'0');
				ELSIF rising_edge(Clk) AND Load='1' THEN
					data <= d;
				ELSIF rising_edge(Clk) AND Load='0' AND INC='1' THEN
					data <= data +'1';
				ELSIF rising_edge(Clk) AND Load='0' AND DEC='1' THEN
					data <= data -'1';
				ELSIF rising_edge(Clk) AND Load='0' AND CLR='1' THEN
					data <= (OTHERS=>'0');
				ELSIF rising_edge(Clk) AND Load='0' AND STO='1' THEN
					data <= "0000000000000001";
				END IF;

		END PROCESS;
	q<=data;
END REGpc16_Arch;
