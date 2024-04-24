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
	begin
		process(k) begin
			ak <= content(to_integer(k));
		end process;
end BHV;



