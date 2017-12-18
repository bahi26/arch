library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tri_state_buffer is
Generic ( n : integer := 32);
Port ( EN   : in  STD_LOGIC;
       inp  : in  STD_LOGIC_VECTOR (n-1 downto 0);
       outp : out STD_LOGIC_VECTOR (n-1 downto 0));
end tri_state_buffer;

architecture Arch of tri_state_buffer is
begin
    outp <= inp when (EN = '1') else (others=>'Z');
end Arch;
