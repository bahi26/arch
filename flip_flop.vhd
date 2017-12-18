Library ieee;
Use ieee.std_logic_1164.all;

Entity flip_flop is
port( clk,rst,en: in std_logic;
q : out std_logic);
end flip_flop;


Architecture arch1 of flip_flop is
begin
Process (clk,rst,en)
begin
if rst = '1' then
q <='0';
elsif rising_edge(clk)  and en = '1' then
q <= not q;
end if;
end process;
end arch1;
