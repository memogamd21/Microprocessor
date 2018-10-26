LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE     IEEE.std_logic_unsigned.ALL;

-- REG_EX_MEM(15 DOWNTO 0)   ALURES
-- REG_EX_MEM(31 DOWNTO 16)  R2_FWD
-- REG_EX_MEM(34 DOWNTO 32)  WT_ADR
-- REG_EX_MEM(50 DOWNTO 35)  IR1 [Offset]
 
-- REG_EX_MEM(51)  MemR
-- REG_EX_MEM(52)  MemW
-- REG_EX_MEM(53)  SMemR
-- REG_EX_MEM(54)  SMemW
-- REG_EX_MEM(55)  MDR_SEL0
-- REG_EX_MEM(56)  RegWrite
-- REG_EX_MEM(57)  WB_SEL0
-- REG_EX_MEM(58)  WB_SEL1
-- REG_EX_MEM(59)  SP_DEC





ENTITY REG_EX_MEM IS
	PORT( Clk,Rst,Load : IN std_logic;
		  d : IN  std_logic_vector(59 DOWNTO 0);
		  q : OUT std_logic_vector(59 DOWNTO 0)
		  );
END REG_EX_MEM;

ARCHITECTURE REG_EX_MEM_Arch OF REG_EX_MEM IS
SIGNAL data : STD_LOGIC_VECTOR (59 DOWNTO 0);

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
END REG_EX_MEM_Arch;
