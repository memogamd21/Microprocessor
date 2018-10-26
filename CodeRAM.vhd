LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY CodeRAM IS
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(15 DOWNTO 0); --Memory Size is 2^10= 1 K
		datain  : IN  std_logic_vector(15 DOWNTO 0);--Each Instruction is 16-bit wide
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY CodeRAM;

ARCHITECTURE CodeRAM_Arch OF CodeRAM IS

	TYPE ram_type IS ARRAY(0 TO 65535) OF std_logic_vector(15 DOWNTO 0);
        --Signals for the RAM data initialization (A sample program)
	SIGNAL ram:ram_type;

	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					IF we = '1' THEN
						ram(to_integer(unsigned(address))) <= datain;
					END IF;
				END IF;
		END PROCESS;
		dataout <= ram(to_integer(unsigned(address)));
END CodeRAM_Arch;
