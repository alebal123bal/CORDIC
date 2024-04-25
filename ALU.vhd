library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity ALU is 
    generic (
        N : positive := 15  -- Needed to retreive k length
    );
port(
	x_in, y_in, z_in: 		in signed(15 downto 0);
	reset: 					in std_logic;
	clk: 					in std_logic;
	LOAD: 					in std_logic;
	k: 						in unsigned(integer(ceil(log2(real(N)))) downto 0);
	ak: 					in signed(15 downto 0);
	x_out, y_out, z_out: 	out signed(15 downto 0)
);
end ALU;

architecture BHV of ALU is
	--signal xi, yi, zi: signed(15 downto 0);		--Output of MUXes
	signal xk, yk, zk: signed(15 downto 0);		--Output of registers
	signal xo, yo, zo: signed(15 downto 0);		--Output signals
	
	begin
		--Assign output of REGs
		--Declare MUXes directly
		process(clk) begin
			if rising_edge(clk) then
				if LOAD = '1' then
					xk <= x_in;
					yk <= y_in;
					zk <= z_in;
				else
					xk <= xo;
					yk <= yo;
					zk <= zo;
				end if;
			end if;
		end process;
		
		--Assign output signals/MUX memory signals
		process(xk, yk, zk, ak) begin
			--Watch out that this can be wrong at first iteration, as zo is XXXX and so it adds, but it really should sub
			--Use zk instead
			if zk(zk'left) = '0' then 
				xo <= xk - shift_right(yk, to_integer(k));
				yo <= yk + shift_right(xk, to_integer(k));
				zo <= zk - ak;
			else
				xo <= xk + shift_right(yk, to_integer(k));
				yo <= yk - shift_right(xk, to_integer(k));
				zo <= zk + ak;
			end if;
		end process;
		
		--Assign outputs
		process(xo, yo, zo) begin
			x_out <= xo;
			y_out <= yo;
			z_out <= zo;
		end process;
	end BHV;