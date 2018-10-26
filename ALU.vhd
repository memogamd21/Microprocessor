library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_signed.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY ALU IS
    PORT ( ALU_IN_A   : IN   STD_LOGIC_VECTOR (15 downto 0);
           ALU_IN_B   : IN   STD_LOGIC_VECTOR (15 downto 0);
           ALU_SEL    : IN   STD_LOGIC_VECTOR (3 downto 0);
		   ALU_Shamat : IN   STD_LOGIC_VECTOR (3 DOWNTO 0);
		   CFlagOld   : IN   STD_LOGIC;
		   ZFlagOld   : IN   STD_LOGIC;
		   NFlagOld   : IN   STD_LOGIC;
		   OFlagOld   : IN   STD_LOGIC;
           ALU_OUT    : OUT  STD_LOGIC_VECTOR (15 downto 0);
		   CFlag,OFlag,ZFlag,NFlag : OUT STD_LOGIC 
			  );
END ALU;

ARCHITECTURE Behavioral OF ALU is

	COMPONENT my_nadder is
		-- generic (n : integer := 16);
		PORT   (     a, b 	 : IN STD_LOGIC_VECTOR(15  downto 0) ;
             cin     : IN  STD_LOGIC;  
             s       : OUT STD_LOGIC_VECTOR(15 downto 0);
             cout    : OUT STD_LOGIC;
			 of_flag : OUT STD_LOGIC);
	END  COMPONENT my_nadder;
	
	
	SIGNAL  ALU_OUT_Add,ALU_OUT_Sub,ALU_OUT_Neg : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL  ALU_OUT_Inc,ALU_OUT_Dec             : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL  TEMPA,TEMPB,ALU_OUTtemp : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL  CoA,FoA : STD_LOGIC;
	SIGNAL  CoS,FoS : STD_LOGIC;
	SIGNAL  CoN,FoN : STD_LOGIC;
	SIGNAL  CoI,FoI : STD_LOGIC;
	SIGNAL  CoD,FoD : STD_LOGIC;
		
BEGIN

	Adder1       : my_nadder PORT MAP ( ALU_IN_A,ALU_IN_B,'0',ALU_OUT_Add,CoA,FoA);
	TEMPB <= NOT ALU_IN_B;
	TEMPA <= NOT ALU_IN_A;
	Subtractor1  : my_nadder PORT MAP ( ALU_IN_A,TEMPB,'1',ALU_OUT_Sub,CoS,FoS);
	Negator1     : my_nadder PORT MAP ( TEMPA, "0000000000000000",'1',ALU_OUT_Neg,CoN,FoN);
	Incrementer1 : my_nadder PORT MAP ( ALU_IN_A, "0000000000000000",'1',ALU_OUT_Inc,CoI,FoI);
	Decrementer1 : my_nadder PORT MAP ( ALU_IN_A, "1111111111111111",'0',ALU_OUT_Dec,CoD,FoD);
	
	ALU_OUTtemp <= ALU_OUT_Add                       WHEN  ALU_SEL="0000"
	      ELSE ALU_OUT_Sub                       WHEN  ALU_SEL="0001"
	      ELSE ALU_IN_A AND ALU_IN_B             WHEN  ALU_SEL="0010"
	      ELSE ALU_IN_A OR ALU_IN_B              WHEN  ALU_SEL="0011"
	      ELSE ALU_IN_A(14 DOWNTO 0) & CFlagOld  WHEN  ALU_SEL="0100"
		  ELSE CFlagOld & ALU_IN_A(15 DOWNTO 1)  WHEN  ALU_SEL="0101"
		  ELSE NOT ALU_IN_A  					 WHEN  ALU_SEL="0110"
		  ELSE ALU_OUT_Neg						 WHEN  ALU_SEL="0111"
		  ELSE ALU_IN_A						     WHEN  ALU_SEL="1000"
		  ELSE ALU_OUT_Inc 						 WHEN  ALU_SEL="1001"
		  ELSE ALU_OUT_Dec  					 WHEN  ALU_SEL="1010"

		  ELSE ALU_IN_A(15 DOWNTO 0)     	           WHEN  ALU_SEL="1011" AND ALU_Shamat="0000"		  
		  ELSE ALU_IN_A(14 DOWNTO 0) & '0' 	           WHEN  ALU_SEL="1011" AND ALU_Shamat="0001"
		  ELSE ALU_IN_A(13 DOWNTO 0) & "00" 	           WHEN  ALU_SEL="1011" AND ALU_Shamat="0010"
		  ELSE ALU_IN_A(12 DOWNTO 0) & "000"              WHEN  ALU_SEL="1011" AND ALU_Shamat="0011"
		  ELSE ALU_IN_A(11 DOWNTO 0) & "0000"             WHEN  ALU_SEL="1011" AND ALU_Shamat="0100"
		  ELSE ALU_IN_A(10 DOWNTO 0) & "00000"            WHEN  ALU_SEL="1011" AND ALU_Shamat="0101"
		  ELSE ALU_IN_A(9 DOWNTO 0)  & "000000"           WHEN  ALU_SEL="1011" AND ALU_Shamat="0110"
		  ELSE ALU_IN_A(8 DOWNTO 0)  & "0000000"          WHEN  ALU_SEL="1011" AND ALU_Shamat="0111"
		  ELSE ALU_IN_A(7 DOWNTO 0)  & "00000000"         WHEN  ALU_SEL="1011" AND ALU_Shamat="1000"
		  ELSE ALU_IN_A(6 DOWNTO 0)  & "000000000"        WHEN  ALU_SEL="1011" AND ALU_Shamat="1001"
		  ELSE ALU_IN_A(5 DOWNTO 0)  & "0000000000"       WHEN  ALU_SEL="1011" AND ALU_Shamat="1010"
		  ELSE ALU_IN_A(4 DOWNTO 0)  & "00000000000"      WHEN  ALU_SEL="1011" AND ALU_Shamat="1011"
		  ELSE ALU_IN_A(3 DOWNTO 0)  & "000000000000"     WHEN  ALU_SEL="1011" AND ALU_Shamat="1100"
		  ELSE ALU_IN_A(2 DOWNTO 0)  & "0000000000000"    WHEN  ALU_SEL="1011" AND ALU_Shamat="1101"
		  ELSE ALU_IN_A(1 DOWNTO 0)  & "00000000000000"   WHEN  ALU_SEL="1011" AND ALU_Shamat="1110"
		  ELSE ALU_IN_A(0)           & "000000000000000"  WHEN  ALU_SEL="1011" AND ALU_Shamat="1111"

		  ELSE                      ALU_IN_A(15 DOWNTO 0) WHEN  ALU_SEL="1100" AND ALU_Shamat="0000" 		  
		  ELSE '0'                & ALU_IN_A(15 DOWNTO 1) WHEN  ALU_SEL="1100" AND ALU_Shamat="0001"
		  ELSE "00"               & ALU_IN_A(15 DOWNTO 2) WHEN  ALU_SEL="1100" AND ALU_Shamat="0010"
		  ELSE "000"              & ALU_IN_A(15 DOWNTO 3) WHEN  ALU_SEL="1100" AND ALU_Shamat="0011"
		  ELSE "0000"             & ALU_IN_A(15 DOWNTO 4) WHEN  ALU_SEL="1100" AND ALU_Shamat="0100"
		  ELSE "00000"            & ALU_IN_A(15 DOWNTO 5) WHEN  ALU_SEL="1100" AND ALU_Shamat="0101"
		  ELSE "000000"           & ALU_IN_A(15 DOWNTO 6) WHEN  ALU_SEL="1100" AND ALU_Shamat="0110"
		  ELSE "0000000"          & ALU_IN_A(15 DOWNTO 7) WHEN  ALU_SEL="1100" AND ALU_Shamat="0111"
		  ELSE "00000000"         & ALU_IN_A(15 DOWNTO 8) WHEN  ALU_SEL="1100" AND ALU_Shamat="1000"
		  ELSE "000000000"        & ALU_IN_A(15 DOWNTO 9) WHEN  ALU_SEL="1100" AND ALU_Shamat="1001"
		  ELSE "0000000000"       & ALU_IN_A(15 DOWNTO 10)WHEN  ALU_SEL="1100" AND ALU_Shamat="1010"
		  ELSE "00000000000"      & ALU_IN_A(15 DOWNTO 11)WHEN  ALU_SEL="1100" AND ALU_Shamat="1011"
		  ELSE "000000000000"     & ALU_IN_A(15 DOWNTO 12)WHEN  ALU_SEL="1100" AND ALU_Shamat="1100"
		  ELSE "0000000000000"    & ALU_IN_A(15 DOWNTO 13)WHEN  ALU_SEL="1100" AND ALU_Shamat="1101"
		  ELSE "00000000000000"   & ALU_IN_A(15 DOWNTO 14)WHEN  ALU_SEL="1100" AND ALU_Shamat="1110"
		  ELSE "000000000000000"  & ALU_IN_A(15)          WHEN  ALU_SEL="1100" AND ALU_Shamat="1111"

		  ELSE "0000000000000000"  				 WHEN  ALU_SEL="1101"
		  ELSE "0000000000000000"  				 WHEN  ALU_SEL="1110"
		  ELSE "0000000000000000"  				 WHEN  ALU_SEL="1111";
		  
		  
	CFlag <= CoA               WHEN  ALU_SEL="0000"
	      ELSE NOT CoS         WHEN  ALU_SEL="0001"
	      ELSE '0'             WHEN  ALU_SEL="0010"
	      ELSE '0'             WHEN  ALU_SEL="0011"
	      ELSE ALU_IN_A(15)    WHEN  ALU_SEL="0100"
		  ELSE ALU_IN_A(0)     WHEN  ALU_SEL="0101"
		  ELSE '0'   		   WHEN  ALU_SEL="0110"
		  --Neg sets CF always except if operand is zero 		  
		  ELSE '0'	  		   WHEN  ALU_SEL="0111" AND ALU_IN_A =  "0000000000000000"
		  ELSE '1'	  		   WHEN  ALU_SEL="0111" AND ALU_IN_A /= "0000000000000000"
		  ELSE CFlagOld		       WHEN  ALU_SEL="1000"
		  ELSE CFlagOld		   WHEN  ALU_SEL="1001" --INC doesn't affect the carry flag
		  ELSE CFlagOld		   WHEN  ALU_SEL="1010" --DEC doesn't affect the carry flag
		  
		  ELSE CFlagOld     WHEN  ALU_SEL="1011" AND ALU_Shamat="0000"
		  ELSE ALU_IN_A(15) WHEN  ALU_SEL="1011" AND ALU_Shamat="0001"
		  ELSE ALU_IN_A(14) WHEN  ALU_SEL="1011" AND ALU_Shamat="0010"
		  ELSE ALU_IN_A(13) WHEN  ALU_SEL="1011" AND ALU_Shamat="0011"
		  ELSE ALU_IN_A(12) WHEN  ALU_SEL="1011" AND ALU_Shamat="0100"
		  ELSE ALU_IN_A(11) WHEN  ALU_SEL="1011" AND ALU_Shamat="0101"
		  ELSE ALU_IN_A(10) WHEN  ALU_SEL="1011" AND ALU_Shamat="0110"
		  ELSE ALU_IN_A(9)  WHEN  ALU_SEL="1011" AND ALU_Shamat="0111"
		  ELSE ALU_IN_A(8)  WHEN  ALU_SEL="1011" AND ALU_Shamat="1000"
		  ELSE ALU_IN_A(7)  WHEN  ALU_SEL="1011" AND ALU_Shamat="1001"
		  ELSE ALU_IN_A(6)  WHEN  ALU_SEL="1011" AND ALU_Shamat="1010"
		  ELSE ALU_IN_A(5)  WHEN  ALU_SEL="1011" AND ALU_Shamat="1011"
		  ELSE ALU_IN_A(4)  WHEN  ALU_SEL="1011" AND ALU_Shamat="1100"
		  ELSE ALU_IN_A(3)  WHEN  ALU_SEL="1011" AND ALU_Shamat="1101"
		  ELSE ALU_IN_A(2)  WHEN  ALU_SEL="1011" AND ALU_Shamat="1110"
		  ELSE ALU_IN_A(1)  WHEN  ALU_SEL="1011" AND ALU_Shamat="1111"
 
		  ELSE CFlagOld      WHEN  ALU_SEL="1100" AND ALU_Shamat="0000" 
		  ELSE ALU_IN_A(0)   WHEN  ALU_SEL="1100" AND ALU_Shamat="0001"
		  ELSE ALU_IN_A(1)   WHEN  ALU_SEL="1100" AND ALU_Shamat="0010"
		  ELSE ALU_IN_A(2)   WHEN  ALU_SEL="1100" AND ALU_Shamat="0011"
		  ELSE ALU_IN_A(3)   WHEN  ALU_SEL="1100" AND ALU_Shamat="0100"
		  ELSE ALU_IN_A(4)   WHEN  ALU_SEL="1100" AND ALU_Shamat="0101"
		  ELSE ALU_IN_A(5)   WHEN  ALU_SEL="1100" AND ALU_Shamat="0110"
		  ELSE ALU_IN_A(6)   WHEN  ALU_SEL="1100" AND ALU_Shamat="0111"
		  ELSE ALU_IN_A(7)   WHEN  ALU_SEL="1100" AND ALU_Shamat="1000"
		  ELSE ALU_IN_A(8)   WHEN  ALU_SEL="1100" AND ALU_Shamat="1001"
		  ELSE ALU_IN_A(9)   WHEN  ALU_SEL="1100" AND ALU_Shamat="1010"
		  ELSE ALU_IN_A(10)  WHEN  ALU_SEL="1100" AND ALU_Shamat="1011"
		  ELSE ALU_IN_A(11)  WHEN  ALU_SEL="1100" AND ALU_Shamat="1100"
		  ELSE ALU_IN_A(12)  WHEN  ALU_SEL="1100" AND ALU_Shamat="1101"
		  ELSE ALU_IN_A(13)  WHEN  ALU_SEL="1100" AND ALU_Shamat="1110"
		  ELSE ALU_IN_A(14)  WHEN  ALU_SEL="1100" AND ALU_Shamat="1111"

 		  ELSE CFlagOld  		   WHEN  ALU_SEL="1101"
		  ELSE CFlagOld  		   WHEN  ALU_SEL="1110"
		  ELSE CFlagOld  		   WHEN  ALU_SEL="1111";
		  
	ZFlag <= 
	'1' WHEN ALU_OUTtemp = "0000000000000000" AND ALU_SEL="0000"
	ELSE '0' WHEN ALU_OUTtemp /= "0000000000000000" AND ALU_SEL="0000"
	
	ELSE '1' WHEN ALU_OUTtemp = "0000000000000000" AND ALU_SEL="0001"
	ELSE '0' WHEN ALU_OUTtemp /= "0000000000000000" AND ALU_SEL="0001"

	ELSE '1' WHEN ALU_OUTtemp = "0000000000000000" AND ALU_SEL="0010"
	ELSE '0' WHEN ALU_OUTtemp /= "0000000000000000" AND ALU_SEL="0010"

	ELSE '1' WHEN ALU_OUTtemp = "0000000000000000" AND ALU_SEL="0011"
	ELSE '0' WHEN ALU_OUTtemp /= "0000000000000000" AND ALU_SEL="0011"

	ELSE '1' WHEN ALU_OUTtemp = "0000000000000000" AND ALU_SEL="0100"
	ELSE '0' WHEN ALU_OUTtemp /= "0000000000000000" AND ALU_SEL="0100"

	ELSE '1' WHEN ALU_OUTtemp = "0000000000000000" AND ALU_SEL="0101"
	ELSE '0' WHEN ALU_OUTtemp /= "0000000000000000" AND ALU_SEL="0101"

	ELSE '1' WHEN ALU_OUTtemp = "0000000000000000" AND ALU_SEL="0110"
	ELSE '0' WHEN ALU_OUTtemp /= "0000000000000000" AND ALU_SEL="0110"

	ELSE '1' WHEN ALU_OUTtemp = "0000000000000000" AND ALU_SEL="0111"
	ELSE '0' WHEN ALU_OUTtemp /= "0000000000000000" AND ALU_SEL="0111"

	ELSE '1' WHEN ALU_OUTtemp = "0000000000000000" AND ALU_SEL="1011"
	ELSE '0' WHEN ALU_OUTtemp /= "0000000000000000" AND ALU_SEL="1011"
	ELSE '1' WHEN ALU_OUTtemp = "0000000000000000" AND ALU_SEL="1100"
	ELSE '0' WHEN ALU_OUTtemp /= "0000000000000000" AND ALU_SEL="1100"
	ELSE  ZFlagOld;
	
	NFlag <= 
	     '1' WHEN ALU_OUTtemp(15) ='1' AND ALU_SEL="0000"
	ELSE '0' WHEN ALU_OUTtemp(15) /='1' AND ALU_SEL="0000"
	ELSE '1' WHEN ALU_OUTtemp(15) ='1' AND ALU_SEL="0001"
	ELSE '0' WHEN ALU_OUTtemp(15) /='1' AND ALU_SEL="0001"
	ELSE '1' WHEN ALU_OUTtemp(15) ='1' AND ALU_SEL="0010"
	ELSE '0' WHEN ALU_OUTtemp(15) /='1' AND ALU_SEL="0010"
	ELSE '1' WHEN ALU_OUTtemp(15) ='1' AND ALU_SEL="0011"
	ELSE '0' WHEN ALU_OUTtemp(15) /='1' AND ALU_SEL="0011"
	ELSE '1' WHEN ALU_OUTtemp(15) ='1' AND ALU_SEL="0100"
	ELSE '0' WHEN ALU_OUTtemp(15) /='1' AND ALU_SEL="0100"
	ELSE '1' WHEN ALU_OUTtemp(15) ='1' AND ALU_SEL="0101"
	ELSE '0' WHEN ALU_OUTtemp(15) /='1' AND ALU_SEL="0101"
	ELSE '1' WHEN ALU_OUTtemp(15) ='1' AND ALU_SEL="0110"
	ELSE '0' WHEN ALU_OUTtemp(15) /='1' AND ALU_SEL="0110"
	ELSE '1' WHEN ALU_OUTtemp(15) ='1' AND ALU_SEL="0111"
	ELSE '0' WHEN ALU_OUTtemp(15) /='1' AND ALU_SEL="0111"	
	ELSE '1' WHEN ALU_OUTtemp(15) ='1' AND ALU_SEL="1001"
	ELSE '0' WHEN ALU_OUTtemp(15) /='1' AND ALU_SEL="1001"
	ELSE '1' WHEN ALU_OUTtemp(15) ='1' AND ALU_SEL="1010"
	ELSE '0' WHEN ALU_OUTtemp(15) /='1' AND ALU_SEL="1010"
	ELSE '1' WHEN ALU_OUTtemp(15) ='1' AND ALU_SEL="1011"
	ELSE '0' WHEN ALU_OUTtemp(15) /='1' AND ALU_SEL="1011"
    ELSE '1' WHEN ALU_OUTtemp(15) ='1' AND ALU_SEL="1100"
	ELSE '0' WHEN ALU_OUTtemp(15) /='1' AND ALU_SEL="1100"
	ELSE NFlagOld;
	
	OFlag <=   FoA		       WHEN  ALU_SEL="0000"
	      ELSE FoS             WHEN  ALU_SEL="0001"
		  ELSE OFlagOld;
	
	ALU_OUT <= ALU_OUTtemp;
  
END Behavioral;
