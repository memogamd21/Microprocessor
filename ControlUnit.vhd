LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;


ENTITY ControlUnit IS 
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

END ENTITY ControlUnit;

ARCHITECTURE ControlUnit_Arch OF ControlUnit IS 

BEGIN 

	PROCESS(CCR,OP,FUNCT,NMI,Rst,Clk)
	BEGIN 
	
	
	IF (Rst = '1') THEN --ret Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='0';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='0';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='1';
	PC_STO<='0';
	PC_INC<='0';
	CCR_TMP_LD<='0';
	CCR_SEL   <='0';
	
	ELSIF (NMI = '1') THEN --ret Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='1';
	IR1_LD<='0';
	RegRd1En<='0';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='1';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='0';
	WB_SEL<="00";
	SP_DEC<='1';
	--General
	PC_CLR <='0';
	PC_STO<='1';
	PC_INC<='0';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';

	
	ELSIF(OP="0000" AND FUNCT="000") THEN--NOP
	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='0';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='0';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';
	
	ELSIF (OP="1111" AND FUNCT="000") THEN --MOV Rsrc1,Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1000";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';
	
	ELSIF (OP="0001" AND FUNCT="000") THEN --ADD Rsrc1,Rdst,Rdst
	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='1';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="0000";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';
	
	ELSIF (OP="0001" AND FUNCT="001") THEN --SUB Rsrc1,Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='1';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="0001";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';
		
	
	ELSIF (OP="0001" AND FUNCT="010") THEN --AND Rsrc1,Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='1';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="0010";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';
	
	ELSIF (OP="0001" AND FUNCT="011") THEN --OR Rsrc1,Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='1';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="0011";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';
	
	ELSIF (OP="0001" AND FUNCT="100") THEN --RLC Rsrc1,Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="0100";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';

	ELSIF (OP="0001" AND FUNCT="101") THEN --RRC Rsrc1,Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="0101";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';
	
	ELSIF (OP="0001" AND FUNCT="110") THEN --NOT Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="0110";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';
	
	ELSIF (OP="0001" AND FUNCT="111") THEN --NEG Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="0111";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';

	
	ELSIF (OP="0010" AND FUNCT="000") THEN --INC Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1001";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';

	ELSIF (OP="0010" AND FUNCT="001") THEN --NOT Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1010";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';

	ELSIF (OP="0011" AND FUNCT="000") THEN --PUSH Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='0';
	RegRd2En<='1';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='1';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='0';
	WB_SEL<="00";
	SP_DEC<='1';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';

	ELSIF (OP="0011" AND FUNCT="001") THEN --POP Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='0';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='1';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='1';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="01";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';

	ELSIF (OP="0100" AND FUNCT="000") THEN --OUT Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='0';
	LD_OUTR   <='1';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='0';
	WB_SEL<="01";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';
	ELSIF (OP="0100" AND FUNCT="001") THEN --IN Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='0';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="11";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';
		

	ELSIF (OP="0101" AND FUNCT="000") THEN --JZ Rdst

	-- Fetch  and Decode
	-- Static Branch Prediction 
	-- Predict Not Taken
		IF(CCR(0)='1') then--Resolved while decoding
			PC_SEL<='0'; --Target address 
			PC_LD <='1';
			Flush <='1';
			PC_INC<='0';
		ELSE 
			PC_SEL<='0';  
			PC_LD <='0';
			Flush <='0';
			PC_INC<='1';
		END  IF;
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='0';
	LD_OUTR   <='1';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='0';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';
	
	ELSIF (OP="0101" AND FUNCT="001") THEN --JN Rdst

	-- Fetch  and Decode
	-- Static Branch Prediction 
	-- Predict Not Taken
		IF(CCR(1)='1') then-- NF Resolved while decoding
			PC_SEL<='0'; --Target address 
			PC_LD <='1';
			Flush <='1';
			PC_INC<='0';
		ELSE 
			PC_SEL<='0';  
			PC_LD <='0';
			Flush <='0';
			PC_INC<='1';
		END IF; 
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='0';
	LD_OUTR   <='1';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='0';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';


	ELSIF (OP="0101" AND FUNCT="010") THEN --JC Rdst

	-- Fetch  and Decode
	-- Static Branch Prediction 
	-- Predict Not Taken
		IF(CCR(2)='1') then-- NF Resolved while decoding
			PC_SEL<='0'; --Target address 
			PC_LD <='1';
			Flush <='1';
			PC_INC<='0';
		ELSE 
			PC_SEL<='0';  
			PC_LD <='0';
			Flush <='0';
			PC_INC<='1';
		END  IF;
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='0';
	LD_OUTR   <='1';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='0';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';

	ELSIF (OP="0101" AND FUNCT="011") THEN --JV Rdst

	-- Fetch  and Decode
	-- Static Branch Prediction 
	-- Predict Not Taken
		IF(CCR(3)='1') then-- NF Resolved while decoding
			PC_SEL<='0'; --Target address 
			PC_LD <='1';
			Flush <='1';
			PC_INC<='0';
		ELSE 
			PC_SEL<='0';  
			PC_LD <='0';
			Flush <='0';
			PC_INC<='1';
		END  IF;
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='0';
	LD_OUTR   <='1';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='0';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';
	
	ELSIF (OP="0110" AND FUNCT="000") THEN --JMP Rdst

	-- Fetch  and Decode
	-- Static Branch Prediction 
	-- Predict Not Taken
			PC_SEL<='0'; --Target address 
			PC_LD <='1';
			Flush <='1';
			PC_INC<='0';
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='0';
	LD_OUTR   <='1';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='0';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';

	ELSIF (OP="0111" AND FUNCT="000") THEN --CALL Rdst

	-- Fetch  and Decode
	-- Static Branch Prediction 
	-- Predict Not Taken
			PC_SEL<='0'; --Target address 
			PC_LD <='1';
			Flush <='1';
			PC_INC<='0';
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='1'; -- Read Current PC [it encoded 111 in the RBA field]
	LD_OUTR   <='1';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='1';--Second operand R7 is written to memory 
	-- and first operand is read and be the new PC [PC_SEL]
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='0';
	WB_SEL<="00";
	SP_DEC<='1';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';

	ELSIF (OP="1000"  ) THEN --SHL Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1011";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';

	ELSIF (OP="1011"  ) THEN --SHR Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='0';
	IR1_LD<='0';
	RegRd1En<='1';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1100";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';

	ELSIF (OP="1001" AND FUNCT="000") THEN --LDM Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='1';
	IR1_LD<='0';
	RegRd1En<='0';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="10";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';
	
	ELSIF (OP="1001" AND FUNCT="000") THEN --LDM Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='1';
	IR1_LD<='1';
	RegRd1En<='0';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="10";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';
	
	ELSIF (OP="1001" AND FUNCT="001") THEN --LDD Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='1';
	IR1_LD<='1';
	RegRd1En<='0';
	RegRd2En<='0';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='0';
	-- Memory
	MemR<='1';
	MemW<='0';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='1';
	WB_SEL<="01";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';

	ELSIF (OP="1001" AND FUNCT="010") THEN --LDD Rdst

	-- Fetch  and Decode
	PC_LD <='0';
	PC_SEL<='0';
	Flush<='1';
	IR1_LD<='1';
	RegRd1En<='0';
	RegRd2En<='1';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='0';
	-- Memory
	MemR<='0';
	MemW<='1';
	SMemR<='0';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='0';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';

	ELSIF (OP="1010" AND FUNCT="000") THEN --ret Rdst

	-- Fetch  and Decode
	PC_LD <='1';
	PC_SEL<='1';
	Flush<='1';
	IR1_LD<='0';
	RegRd1En<='0';
	RegRd2En<='1';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='1';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='1';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='0';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='1';
	CCR_TMP_LD<='1';
	CCR_SEL   <='0';

	ELSIF (OP="1010" AND FUNCT="001") THEN --reti Rdst

	-- Fetch  and Decode
	PC_LD <='1';
	PC_SEL<='1';
	Flush<='1';
	IR1_LD<='0';
	RegRd1En<='0';
	RegRd2En<='1';
	LD_OUTR   <='0';
	-- Execute
	ALU_SEL<="1111";
	SP_INC<='1';
	-- Memory
	MemR<='0';
	MemW<='0';
	SMemR<='1';
	SMemW<='0';
	MDR_SEL0<='0';
	-- WB
	RegWriteEn<='0';
	WB_SEL<="00";
	SP_DEC<='0';
	--General
	PC_CLR <='0';
	PC_STO<='0';
	PC_INC<='0';
	CCR_TMP_LD<='1';
	CCR_SEL   <='1';

	END IF;
	
	
	END PROCESS;









END ARCHITECTURE  ControlUnit_Arch;






									