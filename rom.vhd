LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY rom IS
PORT(address:in std_logic_vector(4 downto 0);clk : IN std_logic;dataout : OUT std_logic_vector(13 DOWNTO 0));
END ENTITY rom;

ARCHITECTURE my_rom OF rom IS

  type rom_type is array ( 0 to 31) of std_logic_vector(13 downto 0);
  signal myRom : rom_type := (
    0  => "00101000000000",
    1  => "00111100000000",
    2  => "00101110010100",
    3  => "01100100000000",
    4  => "00101100001000",
    5  => "01100110010000",
    6  => "10001110010100",
    7  => "01110000000000",
    8  => "11111000000000",
    9  => "00101100001100",
    10 => "01100010010000",
    11 => "00000000000000",--empty
    12 => "11101000000000",
    13 => "01011000000000",
    14 => "11101100000000",
    15 => "00000000000000",--empty
    16 => "01100100000000",
    17 => "01111101000000",
    18 => "00011011000000",
    19 => "10001100001100",
    20 => "01110000000000",
    21 => "10101100001000",
    22 => "01110110000000",
    23 => "10011100100000",
    24 => "00010011000000",
    25 => "10101110000100",
    26 => "01110101000000",
    27 => "11110000000000",
    28 => "10001110010100",
    29 => "01110000000000",
    30 => "11100001000000",
    31 => "00000000000000"
	);
BEGIN
PROCESS(clk) IS
BEGIN
IF rising_edge(clk) THEN  
dataout <= myRom(to_integer(unsigned(address)));
END IF;
END PROCESS;
END my_rom;
