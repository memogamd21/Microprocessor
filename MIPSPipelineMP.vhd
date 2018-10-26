LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE     IEEE.std_logic_unsigned.ALL;




ENTITY MIPSPipelineMP IS
	PORT( 
		Clk,Rst : IN  STD_LOGIC;
		InPort  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		NMI     : IN  STD_LOGIC ;
		OutPort : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)		
	);
END MIPSPipelineMP;


ARCHITECTURE MIPSPipelineMP_Arch OF MIPSPipelineMP IS 
	----------------------- MUXs ---------------------------
	COMPONENT MUX_2By1_4bit IS 
		PORT ( a,b  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
			s	: IN  STD_LOGIC  ;
			x   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
	END COMPONENT MUX_2By1_4bit;

	COMPONENT MUX_2By1_16bit is 
	PORT ( a,b  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			s	: IN  STD_LOGIC  ;
			x   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT MUX_2By1_16bit;
	
	COMPONENT MUX_4By1_16bit is 
	port ( a,b,c,d : in std_logic_vector(15 DOWNTO 0);
		s : in  std_logic_vector (1 downto 0 );
		x : out std_logic_vector(15 DOWNTO 0));
	END COMPONENT MUX_4By1_16bit;
	--------------------------------------------------------
		
		
	------------ Adders  and ALU ---------------------------	
	COMPONENT my_adder IS
	PORT (a,b,cin  : IN std_logic;
		  s , cout : OUT std_logic );
    END COMPONENT my_adder;

	COMPONENT my_nadder is
      -- generic (n : integer := 16);
	PORT   ( a, b 	 : IN STD_LOGIC_VECTOR(15  downto 0) ;
             cin     : IN  STD_LOGIC;  
             s       : OUT STD_LOGIC_VECTOR(15 downto 0);
             cout    : OUT STD_LOGIC;
			 of_flag : OUT STD_LOGIC);
	END COMPONENT my_nadder;

	COMPONENT ALU IS
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
	END COMPONENT ALU;
	---------------------------------------------------------

	--------------------- Registers --------------------------	
	--CCR
	COMPONENT REG4 IS
		PORT( Clk,Rst,Load : IN std_logic;
			d : IN  std_logic_vector(3 DOWNTO 0);
			q : OUT std_logic_vector(3 DOWNTO 0) 
		   );
	END COMPONENT REG4;	
	
	COMPONENT REG16 IS
		PORT( Clk,Rst,Load : IN std_logic;
		  d : IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT REG16;

	
	COMPONENT REG_ID_EX IS
		PORT( Clk,Rst,Load : IN std_logic;
			d : IN  std_logic_vector(74 DOWNTO 0);
			q : OUT std_logic_vector(74 DOWNTO 0)
		  );
	END COMPONENT REG_ID_EX;

	COMPONENT REG_EX_MEM IS
	PORT( Clk,Rst,Load : IN std_logic;
		  d : IN  std_logic_vector(59 DOWNTO 0);
		  q : OUT std_logic_vector(59 DOWNTO 0)
		  );
	END COMPONENT REG_EX_MEM;

	COMPONENT REG_MEM_WB IS
		PORT( Clk,Rst,Load : IN std_logic;
			d : IN  std_logic_vector(54 DOWNTO 0);
			q : OUT std_logic_vector(54 DOWNTO 0)
		  );
	END COMPONENT REG_MEM_WB;

	COMPONENT Regfile IS
		PORT ( 
		   WA  : IN  STD_LOGIC_VECTOR (2 downto 0);
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
		  		   
	END COMPONENT Regfile;
	---------------------------------------------------------

	--------------------- RAMs [Data and Code]  -------------				
	COMPONENT DataRAM IS
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(15 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT DataRAM;
	
	
	COMPONENT CodeRAM IS
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(15 DOWNTO 0); --Memory Size is 2^10= 1 K
		datain  : IN  std_logic_vector(15 DOWNTO 0);--Each Instruction is 16-bit wide
		dataout : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT CodeRAM;
	---------------------------------------------------------
	COMPONENT ControlUnit IS 
	PORT (  CCR           : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	        OP    		  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			FUNCT 		  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			NMI,Rst,Clk   : IN STD_LOGIC;
			-- Control Signals of IF,ID
			PC_LD,PC_SEL,Flush,IR1_LD,RegRd1En,RegRd2En : OUT STD_LOGIC;
			-- Control Signals of EX
			ALU_SEL       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			SP_INC		  : OUT STD_LOGIC;
			-- Control Signals of Mem
			MemR,MemW,SMemR,SMemW,MDR_SEL0 : OUT STD_LOGIC;
			-- Control Signals of WB
			RegWriteEn,SP_DEC    : OUT STD_LOGIC;
			WB_SEL               : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			-- General Control Signals 
			PC_CLR,PC_STO,PC_INC,CCR_TMP_LD,CCR_SEL,LD_OUTR: OUT STD_LOGIC
			);
	END COMPONENT ControlUnit;		
	
	COMPONENT ForwardingUnit IS 
		PORT(
		EX_MEM_RegWrite,MEM_WB_RegWrite		  : IN STD_LOGIC;
		EX_MEM_WT_Adr,MEM_WB_WT_Adr,ID_EX_RdAd1,ID_EX_RdAd2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		FWDA_SEL,FWDB_SEL     : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
	END COMPONENT ForwardingUnit;
	
	
	COMPONENT 	HazardDetectioUnit  IS
	PORT(
		ID_EX_MemR,ID_EX_SMemR,ID_EX_InputInstr : IN STD_LOGIC ;
		ID_EX_WT_Adr,IF_ID_RdAd1,IF_ID_RdAd2: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Stall_Pipeline                  : OUT STD_LOGIC
		);
	END COMPONENT HazardDetectioUnit;
	----------------------------------------------------------------
	--Control Unit Signals :
	SIGNAL Flush,IR1_LD : STD_LOGIC;
	SIGNAL 	ALU_SEL: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL  MemR,MemW,SMemR,SMemW,MDR_SEL0 : STD_LOGIC;
	SIGNAL  WB_SEL : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL  CCR_TMP_LD,CCR_SEL,LD_OUTR : STD_LOGIC ;
	SIGNAL EX_MEM_MemR,EX_MEM_SMemR,ID_EX_InputInstr : STD_LOGIC;
    SIGNAL ID_EX_WT_Adr							 : STD_LOGIC_VECTOR( 2 DOWNTO 0);
  	SIGNAL Stall_Pipeline_IF_ID,InsertNOP : STD_LOGIC;
	SIGNAL IR_LD_EFF,PC_INC_EFF : STD_LOGIC;

	
	SIGNAL   StackData,RegFileR1Data  :  STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL   PC_SEL : STD_LOGIC;
	SIGNAL   WtAd,RdAd1,RdAd2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL   WtDt: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL   RegRd1En,RegRd2En,RegWriteEn : STD_LOGIC;
	SIGNAL   RdDt1,RdDt2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL   SP_OUT,PC_OUT,PC_In : STD_LOGIC_VECTOR( 15 DOWNTO 0);
	SIGNAL   SP_INC,SP_DEC,PC_INC,PC_LD,PC_STO,PC_CLR : STD_LOGIC;
	SIGNAL   IR_IN,IR,IR_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

	SIGNAL RegWriteEn_Eff,SP_DEC_EFF,SP_INC_EFF : STD_LOGIC;
	SIGNAL Shamat   : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL RdstnA   : STD_LOGIC_VECTOR(2 DOWNTO 0);
	
	SIGNAL ID_EX_IN ,ID_EX_OUT  : STD_LOGIC_VECTOR(74 DOWNTO 0);
	SIGNAL EX_MEM_IN,EX_MEM_OUT : STD_LOGIC_VECTOR(59 DOWNTO 0);
	SIGNAL OutPortSIG : STD_LOGIC_VECTOR(15 DOWNTO 0);

	-- EX Part 
	SIGNAL ALUA_MUX0_EX,ALUA_MUX1_EX,ALUA_MUX2_EX : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ALUB_MUX0_EX,ALUB_MUX1_EX,ALUB_MUX2_EX : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ALUA_EFF,ALUB_EFF,ALU_OUT_EX : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL FWDA_SEL,FWDB_SEL : STD_LOGIC_VECTOR(1 DOWNTO 0);

	SIGNAL ALU_SEL_EX : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL ALU_Shamat_Ex  : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL CCR_IN,CCR_MUX_OUT,CCR_OUT,CCR_TMP_OUT : STD_LOGIC_VECTOR(3 DOWNTO 0);
	 --Mem
	SIGNAL MemW_Mem : STD_LOGIC;
	SIGNAL MemA_Mem,R2D_FWD_Mem,MemDataOut : STD_LOGIC_VECTOR(15 DOWNTO 0);

	
	-- WB Part
	SIGNAL MEM_WB_IN,MEM_WB_OUT 			  : STD_LOGIC_VECTOR(54 DOWNTO 0);
	SIGNAL ALURES_WB,MDR_WB,IR1_WB,WB_MUX_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL WB_SEL_WB 					      : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL Stall_On_POP_After_Push : STD_LOGIC;
	
BEGIN 
--///////////*****************************
-- Program Counter
--****************************///////////

 


PC_MUX   : MUX_2By1_16bit PORT MAP(RegFileR1Data,StackData,PC_SEL,PC_IN);

--//////////////////////////////////////////////////////
--//////////////  Fetch [Code RAM]   //////////////
--//////////////////////////////////////////////////////
--Code Memory won't be written  during the execution of the program 
-- It's assumed that the program is burn [written] before use of the MP
Code_Mem1 : CodeRAM PORT MAP(clk,'0',PC_OUT,"0000000000000000",IR);

--///////////*****************************
-- Pipelining Register IF_ID [Instruction Register]
--****************************///////////
IR_IN <= "0000000000000000" WHEN Flush='1'  
         ELSE IR;
IR_LD_EFF  <= '0' WHEN Stall_Pipeline_IF_ID='1' AND (IR_OUT /="0000000000000000" AND  Flush='0') -- Stall and make sure that it is not NOP
		   ELSE '0' WHEN Stall_Pipeline_IF_ID='1' AND (IR_OUT  ="0000000000000000" AND  Flush='1') -- Stall condition but flush due to 32-bit operand instruction 
  		   ELSE '0' WHEN Stall_On_POP_After_Push='1'
		   ELSE '1';
		
IR_U1     : REG16	PORT MAP(clk,Rst,IR_LD_EFF,IR_IN,IR_OUT);

--//////////////////////////////////////////////////////
--//////////////  Decode [Control Unit]   //////////////
--//////////////////////////////////////////////////////
EX_MEM_MemR <= EX_MEM_OUT(51); --Not ID_EX as memory instructions here are 32 bits
EX_MEM_SMemR<= EX_MEM_OUT(53);--Not ID_EX as memory instructions here are 32 bits
ID_EX_InputInstr<= ID_EX_OUT(66) AND  ID_EX_OUT(67);--WHEN BOTH ARE 1 IN Instruction
ID_EX_WT_Adr   <= ID_EX_OUT(54 DOWNTO 52);
RdAd1 <= IR_OUT(11 DOWNTO 9);
RdAd2 <= IR_OUT(8  DOWNTO 6);
  
HazrdDtcUnit1: HazardDetectioUnit PORT MAP(EX_MEM_MemR,EX_MEM_SMemR,ID_EX_InputInstr,
										   ID_EX_WT_Adr,
										   RdAd1,RdAd2,
										   Stall_Pipeline_IF_ID);
										  
ControlUnit1 : ControlUnit PORT MAP(CCR_IN,IR_OUT(15 DOWNTO 12),IR_OUT(2 DOWNTO 0),NMI,Rst,CLK,
									PC_LD,PC_SEL,Flush,IR1_LD,RegRd1En,RegRd2En,
									ALU_SEL,SP_INC,MemR,MemW,SMemR,SMemW,MDR_SEL0,
									RegWriteEn,SP_DEC,WB_SEL,
									PC_CLR,PC_STO,PC_INC,CCR_TMP_LD,CCR_SEL,
									LD_OUTR);
							
-- Outputs of Control Unit goes to the pipeline register 
-- Only PC_LD,PC_SEL,
--      Flush, IR1_LD , 
--      RegRd1En,RegRd2En 
--      PC_STO,PC_CLR  are consumed here 							

WtAd  <= MEM_WB_OUT(34 DOWNTO 32);
WtDt  <= WB_MUX_OUT;
RegWriteEn_Eff <= MEM_WB_OUT(51);
SP_DEC_EFF     <= MEM_WB_OUT(54);
SP_INC_EFF     <= ID_EX_OUT (59);

	Stall_On_POP_After_Push<='1' WHEN IR_OUT(15 DOWNTO 12) ="0011" AND IR_OUT(2 DOWNTO 0)="001" AND ID_EX_out(68)='1'  -- IF POP Come when SP DEC is 1 then make stall
				ELSE '1'  WHEN IR_OUT(15 DOWNTO 12) ="0011" AND IR_OUT(2 DOWNTO 0)="001" AND EX_MEM_OUT(59)='1'  -- IF POP Come when SP DEC is 1 then make stall
				ELSE '1' WHEN IR_OUT(15 DOWNTO 12) ="0011" AND IR_OUT(2 DOWNTO 0)="001" AND MEM_WB_OUT(54)='1'
	ELSE '0';
	
	
PC_INC_EFF <= '0' WHEN Stall_Pipeline_IF_ID='1' AND (IR_OUT /="0000000000000000" AND  Flush='0') -- Stall and make sure that it is not NOP
		     ELSE'0' WHEN Stall_Pipeline_IF_ID='1' AND (IR_OUT  ="0000000000000000" AND  Flush='1') -- Stall condition but flush due to 32-bit operand instruction 
			 ELSE '0' WHEN Stall_On_POP_After_Push='1'
			 ELSE PC_INC ; -- TO stall the pipeline
			 
RegFile1     : Regfile     PORT MAP(WtAd,RdAd1,RdAd2,WtDt,RegRd1En,RegRd2En,RegWriteEn_Eff,Rst,RdDt1,RdDt2,Clk,SP_OUT,SP_INC_EFF,SP_DEC_EFF,PC_OUT,PC_In,PC_INC_EFF,PC_LD,PC_STO,PC_CLR);
RegFileR1Data <= RdDt1;
OUT_REG1     : REG16       PORT MAP (CLK,Rst,LD_OUTR,RdDt1,OutPortSIG);
OutPort <= OutPortSIG;

--///////////*****************************
-- Pipelining Register ID_EX
--****************************///////////
Shamat    <=  IR_OUT(6) & IR_OUT(2 DOWNTO 0);
RdstnA    <=  IR_OUT(5 DOWNTO 3);

		 
ID_EX_IN   	  <=   (OTHERS=>'0') WHEN Stall_Pipeline_IF_ID='1' AND (IR_OUT /="0000000000000000" AND  Flush='0') -- Stall and make sure that it is not NOP
		      ELSE (OTHERS=>'0') WHEN Stall_Pipeline_IF_ID='1' AND (IR_OUT  ="0000000000000000" AND  Flush='1') -- Stall condition but flush due to 32-bit operand instruction 
			  ELSE (OTHERS=>'0') WHEN NMI='1'
			  ELSE (OTHERS=>'0') WHEN  Stall_On_POP_After_Push='1'
			  ELSE    RdAd2 & RdAd1 & SP_DEC&WB_SEL&RegWriteEn&MDR_SEL0&SMemW& SMemR& MemW& MemR& SP_INC & ALU_SEL  & RdstnA  & IR & Shamat & RdDt2 & RdDt1;
			  -- To insert the NOP
 

ID_EX_U1  : REG_ID_EX   PORT MAP(Clk,Rst,'1',ID_EX_IN,ID_EX_OUT);

--////////////////////////////////////////
--//////////////  Execute   //////////////
--////////////////////////////////////////

--Hazard_Detect1 : HazardDetection PORT MAP();
FWD_UNIT1 : ForwardingUnit   PORT MAP(
		EX_MEM_OUT(56),MEM_WB_OUT(51),
		EX_MEM_OUT(34 DOWNTO 32),MEM_WB_OUT(34 DOWNTO 32),
		ID_EX_OUT (71 DOWNTO 69),ID_EX_OUT (74 DOWNTO 72),
		FWDA_SEL,FWDB_SEL);
		-- REG_ID_EX(71 DOWNTO 69) RegAd1
		-- REG_ID_EX(74 DOWNTO 72) RegAd2
		
ALUA_MUX0_EX <=  ID_EX_OUT(15 DOWNTO 0) ;
ALUA_MUX1_EX <=  EX_MEM_OUT(15 DOWNTO 0);
ALUA_MUX2_EX <=  WB_MUX_OUT;

ALUA_MUX : MUX_4By1_16bit PORT MAP(ALUA_MUX0_EX,ALUA_MUX1_EX,ALUA_MUX2_EX,"0000000000000000",FWDA_SEL,ALUA_EFF);

ALUB_MUX0_EX <=  ID_EX_OUT (31 DOWNTO 16) ;
ALUB_MUX1_EX <=  EX_MEM_OUT(15 DOWNTO 0);
ALUB_MUX2_EX <=  WB_MUX_OUT;

ALUB_MUX : MUX_4By1_16bit PORT MAP(ALUB_MUX0_EX,ALUB_MUX1_EX,ALUB_MUX2_EX,"0000000000000000",FWDB_SEL,ALUB_EFF);

ALU_SEL_EX    <= ID_EX_OUT(58 DOWNTO 55);
ALU_Shamat_Ex <= ID_EX_OUT(35 DOWNTO 32);
ALU1     : ALU  PORT MAP (ALUA_EFF,ALUB_EFF,ALU_SEL_EX,ALU_Shamat_Ex,CCR_OUT(2),CCR_OUT(0),CCR_OUT(1),CCR_OUT(3),ALU_OUT_EX,CCR_IN(2),CCR_IN(3),CCR_IN(0),CCR_IN(1));
CCR_MUX  : MUX_2By1_4bit PORT MAP(CCR_IN,CCR_TMP_OUT,CCR_SEL,CCR_MUX_OUT);

CCR1     : REG4 PORT MAP(Clk,Rst,'1',CCR_MUX_OUT,CCR_OUT);
CCRTMP   : REG4 PORT MAP(CLK,Rst,'1',CCR_OUT,CCR_TMP_OUT);

--///////////*****************************
-- Pipelining Register EX_MEM
--****************************///////////
EX_MEM_IN <=   (OTHERS=>'0') WHEN NMI='1'
			  ELSE ID_EX_OUT(68)&ID_EX_OUT(67)&ID_EX_OUT(66)&ID_EX_OUT(65)&ID_EX_OUT(64)&ID_EX_OUT(63)&ID_EX_OUT(62)&ID_EX_OUT(61)&ID_EX_OUT(60) & ID_EX_OUT(51 DOWNTO 36)& ID_EX_OUT (54 DOWNTO 52) & ALUB_EFF & ALU_OUT_EX;
  
EX_MEM_U1 : REG_EX_MEM  PORT MAP(clk,Rst,'1',EX_MEM_IN,EX_MEM_OUT);


--////////////////////////////////////////
--//////////////  Memory   //////////////
--////////////////////////////////////////

MemW_Mem    <= '1' WHEN EX_MEM_OUT(52)='1' OR EX_MEM_OUT(54)='1'
            ELSE '0';
			
R2D_FWD_Mem <=  EX_MEM_OUT(31 DOWNTO 16);
MemA_Mem    <=  SP_OUT WHEN  EX_MEM_OUT(53)='1' OR EX_MEM_OUT(54)='1'
		ELSE    EX_MEM_OUT(50 DOWNTO 35) WHEN EX_MEM_OUT(51)='1' OR EX_MEM_OUT(52)='1';

Data_Memory1 : DataRAM     PORT MAP(clk,MemW_Mem,MemA_Mem,R2D_FWD_Mem,MemDataOut);

StackData <= MemDataOut ;


--No need for DR Mux in case of 1 Memory 
--DR_MUX    : MUX_2By1_16bit PORT MAP();
MEM_WB_IN <= (OTHERS=>'0') WHEN NMI='1'
		     ELSE EX_MEM_OUT(59) & EX_MEM_OUT(58) & EX_MEM_OUT(57) & EX_MEM_OUT(56) & EX_MEM_OUT(50 DOWNTO 35)& EX_MEM_OUT(34 DOWNTO 32)& MemDataOut &  EX_MEM_OUT(15 DOWNTO 0);
 
 --///////////*****************************
-- Pipelining Register MEM_WB
--****************************///////////

MEM_WB_U1    : REG_MEM_WB  PORT MAP(Clk,Rst,'1',MEM_WB_IN,MEM_WB_OUT);

--////////////////////////////////////////
--//////////////  Write Back   //////////////
--////////////////////////////////////////
ALURES_WB <= MEM_WB_OUT(15 DOWNTO 0) ;
MDR_WB    <= MEM_WB_OUT(31 DOWNTO 16);
IR1_WB    <= MEM_WB_OUT(50 DOWNTO 35);
WB_SEL_WB <= MEM_WB_OUT(53 DOWNTO 52);

WB_MUX     : MUX_4By1_16bit PORT MAP(ALURES_WB,MDR_WB,IR1_WB,InPort,WB_SEL_WB,WB_MUX_OUT);



END MIPSPipelineMP_Arch;

