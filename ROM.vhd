library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

use WORK.cordpack.all;

entity ROM is
	generic (
        N : positive := 15  -- Default value for N clock cycles
    );
	port(
	k: in unsigned(integer(ceil(log2(real(N)))) downto 0);
	ak: out signed(15 downto 0)
	);
end ROM;

architecture BHV of ROM is
    --TODO: mismatch on the size; sad naming of same variable N
	--signal content: WORK.cordpack.T_CORDANGLE(N downto 0) := WORK.cordpack.F_CORDANGLE(WORK.cordpack.SA);

    --arctan(2^-n) are 45 deg, 26.6 deg, 14 deg etc
    --Angles are normalized by a division of 256
    
    type array_type is array (0 to 15) of signed(15 downto 0);
    signal content: array_type := 
    (
        x"1680",
        x"0D48",
        x"0704",
        x"0390",
        x"01CA",
        x"00E5",
        x"0073",
        x"0039",
        x"001D",
        x"000E",
        x"0007",
        x"0004",
        x"0002",
        x"0001",
        x"0000",
        x"0000"
    );


	begin
		process(k) begin
			ak <= content(to_integer(k));
		end process;
end BHV;



