LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

--One Hazards can't be solved by forwarding if prev instruction is LD or IN 
-- and the next instruction needs its data while executing 
-- so insert stall [Flush] 

ENTITY 	HazardDetectioUnit  IS
		PORT(
		ID_EX_MemR,ID_EX_SMemR,ID_EX_InputInstr : IN STD_LOGIC ;
		ID_EX_WT_Adr,IF_ID_RdAd1,IF_ID_RdAd2: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 
		Stall_Pipeline                  : OUT STD_LOGIC
		);
END ENTITY HazardDetectioUnit;

ARCHITECTURE HazardDetectioUnit_Arch of HazardDetectioUnit IS 
BEGIN
 Stall_Pipeline<=    '1' WHEN ID_EX_MemR='1' AND (ID_EX_WT_Adr = IF_ID_RdAd1)
   ELSE              '1' WHEN ID_EX_MemR='1' AND (ID_EX_WT_Adr = IF_ID_RdAd2)
   ELSE			     '1' WHEN ID_EX_SMemR='1' AND (ID_EX_WT_Adr = IF_ID_RdAd1)
   ELSE              '1' WHEN ID_EX_SMemR='1' AND (ID_EX_WT_Adr = IF_ID_RdAd2)   
   ELSE              '1' WHEN ID_EX_InputInstr='1' AND (ID_EX_WT_Adr = IF_ID_RdAd1)
   ELSE              '1' WHEN ID_EX_InputInstr='1' AND (ID_EX_WT_Adr = IF_ID_RdAd2)  
   ELSE              '0';
  	
END ARCHITECTURE HazardDetectioUnit_Arch;
