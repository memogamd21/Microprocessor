Library ieee;
Use ieee.std_logic_1164.all;

ENTITY my_adder IS
PORT (a,b,cin  : IN std_logic;
      s , cout : OUT std_logic );
END my_adder;

ARCHITECTURE a_my_adder OF my_adder IS
BEGIN 

	PROCESS ( a ,b , cin)
	BEGIN  

		s <= a xor b xor cin;
		cout <= (a and b) or (cin and (a xor b));
	END PROCESS ;
	
END a_my_adder;