Library ieee;
Use ieee.std_logic_1164.all;
-- n-bit adder

ENTITY my_nadder is
      -- generic (n : integer := 16);
PORT   (     a, b 	 : IN STD_LOGIC_VECTOR(15  downto 0) ;
             cin     : IN  STD_LOGIC;  
             s       : OUT STD_LOGIC_VECTOR(15 downto 0);
             cout    : OUT STD_LOGIC;
			 of_flag : OUT STD_LOGIC);
END my_nadder;

ARCHITECTURE a_my_nadder OF my_nadder IS
      COMPONENT my_adder is
              PORT( a,b,cin : in std_logic;
			  s,cout : out std_logic);
      END COMPONENT;
SIGNAL temp : std_logic_vector(15 downto 0);
BEGIN
    
	f0 : my_adder port map(a(0),b(0),cin,s(0),temp(0));
    
	loop1: for i in 1 to 15 generate
          fx: my_adder port map  (a(i),b(i),temp(i-1),s(i),temp(i));
    end generate;
	
	of_flag <= temp(15) XOR temp(14);
    cout    <= temp(15);
END a_my_nadder;