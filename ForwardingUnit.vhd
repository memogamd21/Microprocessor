LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY 	ForwardingUnit  IS
		PORT(
		EX_MEM_RegWrite,MEM_WB_RegWrite		  : IN STD_LOGIC;
		EX_MEM_WT_Adr,MEM_WB_WT_Adr,ID_EX_RdAd1,ID_EX_RdAd2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		FWDA_SEL,FWDB_SEL     : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
END ENTITY ForwardingUnit;

ARCHITECTURE ForwardingUnit_Arch of ForwardingUnit IS 
BEGIN

	-- Forward ALU Result In EX_MEM to Input of ALU If instruction EX_MEM instruction is ALU instruction
    -- Forward Mem/ALU/Imm to be written/IN Result to Input of ALU If the  Mem_WB instruction is LDD-LDM-ALU-IN 
    -- Forward 	
	FWDA_SEL <= "01" WHEN (EX_MEM_RegWrite='1') and (EX_MEM_WT_Adr = ID_EX_RdAd1) 
        ELSE "10"    WHEN (MEM_WB_RegWrite='1') and ( MEM_WB_WT_Adr = ID_EX_RdAd1)
		ELSE "00";


		
	FWDB_SEL <= "01" WHEN (EX_MEM_RegWrite='1') and (EX_MEM_WT_Adr = ID_EX_RdAd2) 
        ELSE "10"    WHEN (MEM_WB_RegWrite='1') and (MEM_WB_WT_Adr = ID_EX_RdAd2)
		ELSE "00";



		
END ARCHITECTURE ForwardingUnit_Arch;
