Library ieee;
Use ieee.std_logic_1164.all;

Entity MpcRegister is
Generic ( n : integer := 5);
port( clk,rst,en : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end MpcRegister;


Architecture arch1 of MpcRegister is
begin
Process (clk,rst,en)
begin
if rst = '1' then
q <= "11100";
elsif rising_edge(clk)  and en = '1' then
q <= d;
end if;
end process;
end arch1;
