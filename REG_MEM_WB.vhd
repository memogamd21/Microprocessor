LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE     IEEE.std_logic_unsigned.ALL;

-- REG_MEM_WB(15 DOWNTO 0)   ALURES
-- REG_MEM_WB(31 DOWNTO 16)  mdr
-- REG_MEM_WB(34 DOWNTO 32)  WT_ADR
-- REG_MEM_WB(50 DOWNTO 35)  IR1 [Offset]
 
-- REG_EX_MEM(51)  RegWrite
-- REG_EX_MEM(52)  WB_SEL0
-- REG_EX_MEM(53)  WB_SEL1
-- REG_EX_MEM(54)  SP_DEC





ENTITY REG_MEM_WB IS
	PORT( Clk,Rst,Load : IN std_logic;
		  d : IN  std_logic_vector(54 DOWNTO 0);
		  q : OUT std_logic_vector(54 DOWNTO 0)
		  );
END REG_MEM_WB;

ARCHITECTURE REG_MEM_WB_Arch OF REG_MEM_WB IS
SIGNAL data : STD_LOGIC_VECTOR (54 DOWNTO 0);

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
END REG_MEM_WB_Arch;
