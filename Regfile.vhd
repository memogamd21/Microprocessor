library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
ENTITY Regfile IS
    PORT ( WA  : IN  STD_LOGIC_VECTOR (2 downto 0);
           RA1 : IN  STD_LOGIC_VECTOR (2 downto 0);
           RA2 : IN  STD_LOGIC_VECTOR (2 downto 0);
           RI  : IN  STD_LOGIC_VECTOR (15 downto 0);
           R1  : IN  STD_LOGIC;
           R2  : IN  STD_LOGIC;
           W   : IN  STD_LOGIC;
           RUN_OUT : IN  STD_LOGIC;
           RD1 : OUT  STD_LOGIC_VECTOR (15 downto 0);
           RD2 : OUT  STD_LOGIC_VECTOR (15 downto 0);
           CLK : IN  STD_LOGIC;
		   -- SP 
		   SP_OUT   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);-- Always SP can be read 
		   SP_INC   : IN  STD_LOGIC; 
		   SP_DEC   : IN  STD_LOGIC; 
		   -- PC
		   PC_Out   : OUT STD_LOGIC_VECTOR (15 downto 0); -- Always PC can be read 
		   PC_In    : IN STD_LOGIC_VECTOR (15 downto 0);  -- Always PC can be written
		   PC_INC   : IN STD_LOGIC ;
		   PC_LD    : IN STD_LOGIC;
		   PC_STO   : IN STD_LOGIC;
		   PC_CLR   : IN STD_LOGIC);
		  		   
END Regfile;

ARCHITECTURE Regfile_Arch of Regfile is
	    COMPONENT  REGF16 IS
		PORT( Clk,Rst,Load     : IN std_logic;
			INC,DEC,CLR,STO  : IN STD_LOGIC;
			d : IN  std_logic_vector(15 DOWNTO 0);
			q : OUT std_logic_vector(15 DOWNTO 0));
		END COMPONENT REGF16;
		COMPONENT REGpc16 IS
		PORT( Clk,Rst,Load     : IN std_logic;
		  INC,DEC,CLR,STO  : IN STD_LOGIC;
		  d : IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
		END COMPONENT REGpc16;

--signal dataout1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
--signal dataout2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
		SIGNAL   Y0   :   STD_LOGIC_VECTOR (15 downto 0);
		SIGNAL   Y1   :   STD_LOGIC_VECTOR (15 downto 0);
		SIGNAL   Y2   :   STD_LOGIC_VECTOR (15 downto 0);
		SIGNAL   Y3   :   STD_LOGIC_VECTOR (15 downto 0);
		SIGNAL   Y4   :   STD_LOGIC_VECTOR (15 downto 0);
		SIGNAL   Y5   :   STD_LOGIC_VECTOR (15 downto 0);
		SIGNAL   Y6   :   STD_LOGIC_VECTOR (15 downto 0);
		SIGNAL   Y7   :   STD_LOGIC_VECTOR (15 downto 0);
                SIGNAL L0,L1,L2,L3,L4,L5,L6,L7 : STD_LOGIC;
 		SIGNAL   L7_EFF,SP_LD : STD_LOGIC;
		SIGNAL   PC_IN_EFF,SP_IN : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
     -- Write
	L0 <= '1' WHEN WA ="000" AND W='1'
	ELSE '0';
	L1 <= '1' WHEN WA ="001" AND W='1'
	ELSE '0';
	L2 <= '1' WHEN WA ="010" AND W='1'
	ELSE '0';
	L3 <= '1' WHEN WA ="011" AND W='1'
	ELSE '0';
	L4 <= '1' WHEN WA ="100" AND W='1'
	ELSE '0';
	L5 <= '1' WHEN WA ="101" AND W='1'
	ELSE '0';
	--Loading R6 or R7 [Not a normal behavior but we will support it 
	L6 <= '1' WHEN WA ="110" AND W='1'
	ELSE '0';
	L7 <= '1' WHEN WA ="111" AND W='1'
	ELSE '0';
	
	
	 -- Read Op1 
	 RD1 <= Y0 WHEN RA1="000"
	 ELSE   Y1 WHEN RA1="001"
	 ELSE   Y2 WHEN RA1="010"
	 ELSE   Y3 WHEN RA1="011"
	 ELSE   Y4 WHEN RA1="100"
	 ELSE   Y5 WHEN RA1="101"
	 ELSE   Y6 WHEN RA1="110"
	 ELSE   Y7 WHEN RA1="111";
	 -- Read Op2
	 RD2 <= Y0 WHEN RA2="000"
	 ELSE   Y1 WHEN RA2="001"
	 ELSE   Y2 WHEN RA2="010"
	 ELSE   Y3 WHEN RA2="011"
	 ELSE   Y4 WHEN RA2="100"
	 ELSE   Y5 WHEN RA2="101"
	 ELSE   Y6 WHEN RA2="110"
	 ELSE   Y7 WHEN RA2="111";
	 
	REG0  : REGF16 PORT MAP (CLK,RUN_OUT, L0 ,'0','0','0','0',RI,Y0);
	REG1  : REGF16 PORT MAP (CLK,RUN_OUT, L1 ,'0','0','0','0',RI,Y1);
	REG2  : REGF16 PORT MAP (CLK,RUN_OUT, L2 ,'0','0','0','0',RI,Y2);
	REG3  : REGF16 PORT MAP (CLK,RUN_OUT, L3 ,'0','0','0','0',RI,Y3);
	REG4  : REGF16 PORT MAP (CLK,RUN_OUT, L4 ,'0','0','0','0',RI,Y4);
	REG5  : REGF16 PORT MAP (CLK,RUN_OUT, L5 ,'0','0','0','0',RI,Y5);

	-------------------------	SP	-------------------
	-- SP initally 1023 
	SP_IN <= "1111111111111111" WHEN RUN_OUT ='1' 
		ELSE RI; 
	SP_LD <=  '1'   WHEN  RUN_OUT ='1'
          ELSE '1' WHEN WA="110"
		  ELSE '0';
		  
	REG6  : REGF16 PORT MAP (CLK,'0',SP_LD,SP_INC,SP_DEC,'0','0',SP_IN,Y6);
	SP_OUT <= Y6; 	
	---------------------------------------------


	-------------------------	PC	-------------------
	-- PC initally zero 
	L7_EFF <= L7 WHEN WA ="111"
	      ELSE PC_LD;
	PC_IN_EFF <= RI WHEN WA="111"
		  ELSE PC_In;
		  
	REG7  : REGpc16 PORT MAP (CLK,RUN_OUT, L7_EFF ,PC_INC,'0',PC_CLR,PC_STO,PC_IN_EFF,Y7);
	
	PC_Out <= Y7;
	---------------------------------------------
	

	
end Regfile_Arch;

