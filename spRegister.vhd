Library ieee;
Use ieee.std_logic_1164.all;

Entity spRegister is
Generic ( n : integer := 11);
port( clk,rst,en : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end spRegister;


Architecture arch1 of spRegister is
begin
Process (clk,rst,en)
begin
if rst = '1' then
q <= (others=>'1');
elsif rising_edge(clk)  and en = '1' then
q <= d;
end if;
end process;
end arch1;