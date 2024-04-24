library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity my_tb is
end entity my_tb;

architecture BHV of my_tb is

	component  CORDIC_PROC is
		generic(
			N: positive := 15	--Number of iterations; precision is fixed by specs	
		);
		port(
			x_in, y_in, z_in	: 		in signed(15 downto 0);
			clk, reset, start	: 		in std_logic;
			x_out, y_out, z_out : 		out signed(15 downto 0)
		);
	end component;

	constant test_angle: real := 37.0 / 256.0;

	--Test signals 
	signal x_i, y_i, z_i	:	signed(15 downto 0);
	signal reset_i			:	std_logic;
	signal start_i			:	std_logic;
	signal clk_i			:	std_logic;

	begin

		process begin
		x_i	<=	to_signed(integer(1.0 * 2.0**15), 16);
		y_i	<=	(others => '0');
		z_i	<=	to_signed(integer(test_angle * 2.0**15), 16);
		
		reset_i	<= '1';
		--Reset
        wait for 5ns;
        reset_i	<= '0';
        start_i <= '1';
        wait for 5ns;
        start_i <= '0';
        wait for 100ns;
        std.env.stop(0);
		
		end process;

		
		CLOCK_GEN: process begin
			while true loop
			clk_i	<=	'1';
			wait for 5ns;
			clk_i	<=	'0';
			wait for 5ns;
			end loop;
			
		end process;

        my_TOP: CORDIC_PROC
            generic map(N => 15)
            port map(
                x_in    =>  x_i,
                y_in    =>  y_i,
                z_in    =>  z_i,
                clk     =>  clk_i,
                reset   =>  reset_i,
                start   =>  start_i

            );


end architecture BHV;