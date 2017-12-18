LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;


-- magic is missing


ENTITY ir_decoder IS
	PORT(
		IR : IN std_logic_vector(15 DOWNTO 0);
		Mpci : IN std_logic_vector(4 DOWNTO 0);
		Flag : IN std_logic_vector(1 DOWNTO 0);
		clk:IN std_logic;
		Mpco : OUT std_logic_vector(4 DOWNTO 0));
END ENTITY ir_decoder;


ARCHITECTURE arch1 OF ir_decoder IS
component flip_flop is
port( clk,rst,en: in std_logic;
q : out std_logic);
end component;
signal magico,f_rst,f_in:std_logic;
	BEGIN
	magic: flip_flop port map(clk,f_rst,f_in,magico);
	Process (IR,Mpci,Flag,clk)
	begin
	f_in<='0';f_rst<='0';
	if Mpci = "00000" or Mpci = "01100" then     -- fetch src
		Mpco <= "00000" OR "00"&IR(4 downto 3)& (IR(4 downto 4) NAND IR(3 downto 3));			-- go to dst
		f_in<='1';
		f_rst<='0';
	elsif Mpci = "00001" then     -- fetch src
		Mpco <= "01101";			-- go to dst
	
	
	elsif Mpci = "00011" or Mpci = "00101" or  Mpci = "01010" then  --src or des
		Mpco <= "01100" OR "0000"& (magico OR IR(14)) ;  					-- finish src or dst

	
	elsif Mpci = "01110" then              -- finish operation
		Mpco <= "10000" OR "0000" & (IR(4 downto 4) NAND IR(3 downto 3));       -- return data
	
	
	elsif Mpci(4 downto 1) = "1000" or Mpci = "10100" or Mpci = "11000" or Mpci = "11011" or Mpci = "01011" then --end instruction
		Mpco <= "11100";   																							 -- fetch new inst
	
	elsif Mpci = "11111" then
		f_in<='0';
		f_rst<='1';
		if IR(15 downto 14) = "00" then
			Mpco <= "00000" OR "00"&IR(9 downto 8)&"0";
		elsif IR(15 downto 14) = "01" then
			Mpco <= "00000" OR "00"&IR(4 downto 3)&(IR(4 downto 4) NAND IR(3 downto 3));
		elsif IR(15 downto 14) = "10" then
			if ((IR(13 downto 11) = "000") OR ( Flag(1) = '1' AND (IR(13 downto 11) = "001" OR IR(13 downto 11) = "100" OR IR(13 downto 11) = "110")) 
						OR ( flag(1) = '0'  AND (IR(13 downto 11) = "010")) 
						OR ( Flag(0) = '0' AND (IR(13 downto 11) = "011" OR IR(13 downto 11) = "100"))
						OR ( Flag(0) = '1' AND (IR(13 downto 11) = "101" OR IR(13 downto 11) = "110")) ) 
			then
				Mpco <= "10010";
			else
				Mpco <= "11100";
			end if;
		else
			if (IR(13 downto 11) = "000") then
				Mpco <= "01111";
			elsif (IR(13 downto 11) = "001") then
				Mpco <= "11100";
			elsif (IR(13 downto 11) = "010") then
				Mpco <= "01001";
			elsif (IR(13 downto 11) = "011") then
				Mpco <= "10101";
			elsif (IR(13 downto 11) = "100") then
				Mpco <= "11001";
			end if;
			
			
			-- OR (IR(13 downto 11) = "001" AND Flag(1) = '1' ) OR (IR(13 downto 11) = "010" AND Flag(1) = '0' )
			-- OR (IR(13 downto 11) = "011" AND Flag(0) = '0' ) OR (IR(13 downto 11) = "100" AND Flag(0) = '0' )
			
			-- Mpco <= "00000" OR "00IRD0";
		
		
		
		end if;
    	
	else
		Mpco <= std_logic_vector(to_unsigned(to_integer(unsigned(Mpci))+1,5)) ;

	-- elsif Mpci = "10100" then
	-- Mpco <= "11100";
	
	-- elsif Mpci = "11000" then
	-- Mpco <= "11100";
	
	end if;
	end process;
	
		
		
		
END arch1;
