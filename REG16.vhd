LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE     IEEE.std_logic_unsigned.ALL;

ENTITY REG16 IS
	PORT( Clk,Rst,Load : IN std_logic;
		  d : IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
END REG16;

ARCHITECTURE REG16_Arch OF REG16 IS
SIGNAL data : STD_LOGIC_VECTOR (15 DOWNTO 0);

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
END REG16_Arch;
