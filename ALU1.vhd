LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

ENTITY ALU1 IS
generic (n:integer:=32);
PORT( A,B: IN std_logic_vector(n-1 DOWNTO 0);
fregi: IN std_logic_vector(1 DOWNTO 0);
frego: OUT std_logic_vector(1 DOWNTO 0);
sel: IN std_logic_vector (4 DOWNTO 0);
F: OUT std_logic_vector(n-1 DOWNTO 0));
END ALU1;

ARCHITECTURE struct1 OF ALU1 IS
Begin

process(sel,A,B,fregi)
variable temp : std_logic_vector(n DOWNTO 0);	
variable tempflag : std_logic_vector(1 DOWNTO 0);
begin
tempflag := fregi;
IF (tempflag(1) = 'U' or tempflag(1) = 'X' or tempflag(1) = 'Z' or tempflag(1) = 'L' or tempflag(1) = '-') THEN tempflag(1) := '0';
ELSE tempflag(1) := tempflag(1);
END IF;

IF (tempflag(0) = 'U' or tempflag(0) = 'X' or tempflag(0) = 'Z' or tempflag(0) = 'L' or tempflag(0) = '-') THEN tempflag(0) := '0';
ELSE tempflag(0) := tempflag(0);
END IF;

	IF (sel = "00000") THEN -- mov a,b
	F <= A; 

	ELSIF (sel = "00001") THEN -- add a,b
	temp := ('0' & A) + B; 
	F <= temp(n-1 downto 0); 
	IF(temp(n-1 downto 0) = (temp(n-1 downto 0)'range => '0')) THEN tempflag := ('1' & temp(n)); 
	ELSE tempflag := ('0' & temp(n));
	END IF;
	
	ELSIF (sel = "00010") THEN  -- adc a,b,c
	temp := ('0' & A) + B + 1; 
	F <= temp (n-1 downto 0); 
	IF(temp(n-1 downto 0) = (temp(n-1 downto 0)'range => '0')) THEN tempflag := ('1' & temp(n)); 
	ELSE tempflag := ('0' & temp(n));
	END IF;
	
	ELSIF (sel = "00011") THEN  -- sub a,b
	temp := ('0' & A) - B; 
	F <= temp (n-1 downto 0); 
	IF(A = B) THEN tempflag := ("10");
	ELSE tempflag := ('0' & temp(n)); 
	END IF;

	ELSIF (sel = "00100") THEN -- sbc a,b,c
	temp := ('0' & A) - B - tempflag(0); 
	F <= temp (n-1 downto 0); 
	IF(A = (B + tempflag(0))) THEN tempflag := ("10");
	ELSE tempflag := ('0' & temp(n)); 
	END IF;

	ELSIF(sel = "00101") THEN -- and a,b
	F <= A and B; 
	IF(A = (A'range => '0') OR B = (B'range => '0')) THEN tempflag := ("10");
	ELSE tempflag := "00"; 
	END IF;
	
	ELSIF(sel = "00110") THEN -- or a,b
	F <= A or B;
	IF(A = (A'range => '0') AND B = (B'range => '0')) THEN tempflag := ("10");
	ELSE tempflag := "00"; 
	END IF;
	
	ELSIF(sel = "00111") THEN -- xor a,b
	F <= A xor B;
	IF(A = B) THEN tempflag := ("10");
	ELSE tempflag := "00"; 
	END IF;

	ELSIF(sel = "01000") THEN -- bis a,b
	F <= A or B;
	IF(A = (A'range => '0') AND B = (B'range => '0')) THEN tempflag := ("10");
	ELSE tempflag := "00"; 
	END IF;

	ELSIF(sel = "01001") THEN -- bic a,b ///
	F <= A and (not B);
	IF(A = (A'range => '0') AND B = (B'range => '1')) THEN tempflag := ("10");
	ELSE tempflag := "00"; 
	END IF;
	
	ELSIF (sel = "01010") THEN -- cmp a,b (output = a) 
	temp := ('0' & A) - B; 
	F <= A; 
	IF(A = B) THEN tempflag := ("10");
	ELSE tempflag := ('0' & temp(n)); 
	END IF;
--------------------------------------------------------------------------------------
	ELSIF (sel = "10000") THEN -- inc a
	temp := ('0' & A) + 1; 
	F <= temp(n-1 downto 0); 
	IF(temp(n-1 downto 0) = (temp(n-1 downto 0)'range => '0')) THEN tempflag := ('1' & temp(n)); 
	ELSE tempflag := ('0' & temp(n));
	END IF;

	ELSIF (sel = "10001") THEN -- dec a
	temp := ('0' & A) - 1; 
	F <= temp (n-1 downto 0); 
	IF(temp(n-1 downto 0) = (temp(n-1 downto 0)'range => '0')) THEN tempflag := ("10");
	ELSE tempflag := ('0' & temp(n)); 
	END IF;
	
	ELSIF(sel = "10010") THEN -- clr a
	F <= (others=>'0'); tempflag := ("10");

	ELSIF(sel = "10011") THEN -- inv a
	F <= not A; tempflag := tempflag;

	ELSIF (sel = "10100") THEN -- lsr a
	F <= ('0' & A(n-1 DOWNTO 1));
	IF(A = (A'range => '0')) THEN tempflag := ("10");
	ELSE tempflag := (tempflag(1) & A(0));
	END IF;
	
	ELSIF(sel = "10101") THEN -- ror a
	F <= (A(0) & A(n-1 DOWNTO 1)); 
	tempflag := (tempflag(1) & A(0));
	
	ELSIF(sel = "10110") THEN -- rrc a
	F <= (tempflag(0) & A(n-1 DOWNTO 1)); 
	tempflag := (tempflag(1) & A(0)); 
	
	ELSIF(sel = "10111") THEN -- asr a
	F <= (A(n-1) & A(n-1 DOWNTO 1));
	IF(A = (A'range => '0')) THEN tempflag := ("10");
	ELSE tempflag := (tempflag(1) & A(0));
	END IF;

	ELSIF(sel = "11000") THEN -- lsl a
	F <= (A(n-2 DOWNTO 0) & '0');
	IF(A = (A'range => '0')) THEN tempflag := ("10");
	ELSE tempflag := (tempflag(1) & A(n-1));
	END IF;
	
	ELSIF(sel = "11001") THEN -- rol a
	F <= (A(n-2 DOWNTO 0) & A(n-1)); 
	tempflag := (tempflag(1) & A(n-1));
	
	ELSIF(sel = "11010") THEN -- rlc a
	F <= (A(n-2 DOWNTO 0) & tempflag(0));
	tempflag := (tempflag(1) & A(n-1));

	END IF;

frego <= tempflag;
end process;

END struct1;