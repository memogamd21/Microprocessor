LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE     IEEE.std_logic_unsigned.ALL;

-- REG_ID_EX(15 DOWNTO 0)  ALUA
-- REG_ID_EX(31 DOWNTO 16) ALUB
-- REG_ID_EX(35 DOWNTO 32) Shamat
-- REG_ID_EX(51 DOWNTO 36) IR1
-- REG_ID_EX(54 DOWNTO 52) WT_ADR
-- REG_ID_EX(58 DOWNTO 55) ALU_SEL
-- REG_ID_EX(59) SP_INC
-- REG_ID_EX(60) MemR
-- REG_ID_EX(61) MemW
-- REG_ID_EX(62) SMemR
-- REG_ID_EX(63) SMemW
-- REG_ID_EX(64) MDR_SEL0
-- REG_ID_EX(65) RegWrite
-- REG_ID_EX(66) WB_SEL0
-- REG_ID_EX(67) WB_SEL1
-- REG_ID_EX(68) SP_Dec
-- REG_ID_EX(71 DOWNTO 69) RegAd1
-- REG_ID_EX(74 DOWNTO 72) RegAd2









ENTITY REG_ID_EX IS
	PORT( Clk,Rst,Load : IN std_logic;
 		  d : IN  std_logic_vector(74 DOWNTO 0);
 		  q : OUT std_logic_vector(74 DOWNTO 0)
		  );
END REG_ID_EX;

ARCHITECTURE REG_ID_EX_Arch OF REG_ID_EX IS
SIGNAL data : STD_LOGIC_VECTOR (74 DOWNTO 0);

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
END REG_ID_EX_Arch;
