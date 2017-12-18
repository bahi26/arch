library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity ndecoder is
Generic ( n : integer := 2);
port( 	sel	: in  std_logic_vector(n-1 downto 0);
	en	: in  std_logic;
	F 	: out std_logic_vector((2**n)-1 downto 0));
end ndecoder;
Architecture arch1 of ndecoder is
begin
	F <= (to_integer(unsigned(sel))=>'1', OTHERS=>'0') when en ='1'
	else (OTHERS=>'0');

	--F(to_integer(signed(sel))) <= '1' when en = '1'
	--else '0';
	
	
end arch1;
