LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE     IEEE.std_logic_unsigned.ALL;

ENTITY REG4 IS
	PORT( Clk,Rst,Load : IN std_logic;
 		  d : IN  std_logic_vector(3 DOWNTO 0);
 		  q : OUT std_logic_vector(3 DOWNTO 0) 
		   );
END REG4;

ARCHITECTURE REG4_Arch OF REG4 IS
SIGNAL data : STD_LOGIC_VECTOR (3 DOWNTO 0);

	BEGIN
		PROCESS (Clk,Rst)

			BEGIN
		 

				IF Rst = '1' THEN
					data <= (OTHERS=>'0');
				ELSIF rising_edge(Clk) AND Load='1' THEN
					data <= d;
				 
				END IF;


		END PROCESS;
	q<=data;
END REG4_Arch;
