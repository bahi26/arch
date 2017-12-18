LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



ENTITY RegisterFile IS
	Generic (n : integer :=32);
	port ( 		Clk: in std_logic;
			InternalBus : inout std_logic_vector (n-1 downto 0));
END RegisterFile;

ARCHITECTURE StructuralModel OF RegisterFile IS

component ndecoder is
Generic ( n : integer := 2);
port( 	sel	: in  std_logic_vector(n-1 downto 0);
	en	: in  std_logic;
	F 	: out std_logic_vector((2**n)-1 downto 0));
end component;

component tri_state_buffer is
Generic ( n : integer := 32);
Port ( en   : in  STD_LOGIC;
       inp  : in  STD_LOGIC_VECTOR (n-1 downto 0);
       outp : out STD_LOGIC_VECTOR (n-1 downto 0));
end component;

component n_bit_register is
Generic ( n : integer := 32);
port( clk,rst,en : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end component;

component ram IS
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(10 DOWNTO 0);
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
end component;

component rom IS
	PORT(address:in std_logic_vector(4 downto 0);
		clk : IN std_logic;
		dataout : OUT std_logic_vector(13 DOWNTO 0));
END component;


component ir_decoder IS
	PORT(
		IR : IN std_logic_vector(15 DOWNTO 0);
		Mpci : IN std_logic_vector(4 DOWNTO 0);
		Flag : IN std_logic_vector(1 DOWNTO 0);
		Mpco : OUT std_logic_vector(4 DOWNTO 0));
END component;

component ALU1 IS
generic (n:integer:=32);
PORT( A,B: IN std_logic_vector(n-1 DOWNTO 0);
fregi: IN std_logic_vector(1 DOWNTO 0);
frego: OUT std_logic_vector(1 DOWNTO 0);
sel: IN std_logic_vector (4 DOWNTO 0);
F: OUT std_logic_vector(n-1 DOWNTO 0));
END component;


signal ro0,ro1,ro2,ro3,zo,yo,tempo,ALUo,mdro,mdri,ramo : std_logic_vector(31 downto 0);
signal IRo : std_logic_vector(15 downto 0);
signal Mpci,Mpco,alus : std_logic_vector(4 downto 0);
signal romo : std_logic_vector(13 downto 0);
signal maro,pco,spo : std_logic_vector(10 downto 0);

signal dec_dest,dec_src,f0,f1 : std_logic_vector(7 downto 0);
signal f2 : std_logic_vector(3 downto 0);
signal ram_dec : std_logic_vector(1 downto 0);
signal flago,flagi      : std_logic_vector(1 downto 0);
signal mdr_enable,inv_clk,rst : std_logic;


begin


inv_clk <= not Clk;






IRD0: ndecoder generic map(3) port map(romo(13 downto 11),'1',f0);
IRD1: ndecoder generic map(3) port map(romo(10 downto 8),'1',f1);
IRD2: ndecoder generic map(2) port map(romo(7 downto 6),'1',f2);

-- IRD3: ndecoder generic map(2) port map(romo(5 downto 4),'1',f3);

-- IRD4: ndecoder generic map(2) port map(romo(3 downto 2),'1',f4);


-- IRD5: ndecoder generic map(2) port map(romo(1 downto 0),'1',f5);

rd0: ndecoder generic map(3) port map(IRo(2 downto 0),f1(1),dec_dest);
rd1: ndecoder generic map(3) port map(IRo(7 downto 5),f0(1),dec_src);

-- ramd: ndecoder generic map(2) port map(IR(2 downto 0),f3(1),dec_dest);






mdri <= ramo when romo(5)='1'
else InternalBus;
alus <= "10000" when romo(3 downto 2) = "01"
	else "10001" when romo(3 downto 2) = "10"
	else "00001" when romo(3 downto 2) = "11"
	else IRo(14 downto 10);

-- mdr_enable <= dec_dest(5) or ram_dec(0);


r0: n_bit_register port map(Clk,rst,dec_dest(0),InternalBus,ro0);
r1: n_bit_register port map(Clk,rst,dec_dest(1),InternalBus,ro1);
r2: n_bit_register port map(Clk,rst,dec_dest(2),InternalBus,ro2);
r3: n_bit_register port map(Clk,rst,dec_dest(3),InternalBus,ro3);
pc: n_bit_register generic map(11) port map(Clk,rst,dec_dest(4) or f1(4),InternalBus(10 downto 0),pco);
sp: n_bit_register generic map(11) port map(Clk,rst,dec_dest(5) or f1(5),InternalBus(10 downto 0),spo);
mar: n_bit_register generic map(11) port map(Clk,rst,f2(2),InternalBus(10 downto 0),mdro);
mdr: n_bit_register generic map(16) port map(Clk,rst,f1(7) or romo(5),mdri,mdro);
Y: n_bit_register port map(Clk,rst,f1(6),InternalBus,yo);
Z: n_bit_register port map(Clk,rst,f1(3),ALUo,zo);
temp: n_bit_register port map(Clk,rst,f1(2),InternalBus,tempo);
IR: n_bit_register generic map(16) port map(Clk,rst,f2(1),InternalBus(15 downto 0),IRo);
ir_dec: ir_decoder port map(IRo,Mpco,flago,Mpci);
Mpc: n_bit_register port map(Clk,rst,'1',Mpci,Mpco);


flag: n_bit_register generic map(2) port map(Clk,rst,'1',flagi,flago);


myalu: ALU1 port map(yo,InternalBus,flago,flagi,alus,ALUo);


ram2k: ram port map(inv_clk,romo(4),maro,mdro,ramo);
rom14: rom port map(Mpco,clk,romo);


tr0: tri_state_buffer port map(dec_src(0),ro0,InternalBus);
tr1: tri_state_buffer port map(dec_src(1),ro1,InternalBus);
tr2: tri_state_buffer port map(dec_src(2),ro2,InternalBus);
tr3: tri_state_buffer port map(dec_src(3),ro3,InternalBus);
tpc: tri_state_buffer port map(dec_src(4) or f0(4), X"00000"&'0'&pco,InternalBus);
tsp: tri_state_buffer port map(dec_src(5) or f0(5),X"00000"&'0'&spo,InternalBus);
tmdr: tri_state_buffer port map(f0(7),mdro,InternalBus);
tz: tri_state_buffer port map(f0(3),zo,InternalBus);
ttemp: tri_state_buffer port map(f0(2),tempo,InternalBus);
tIR: tri_state_buffer port map(f0(6),X"00000"&'0'&IRo(10 downto 0),InternalBus);


END StructuralModel;




