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
		port(
			x_in, y_in, z_in	: 		in signed(15 downto 0);
			clk, reset, start	: 		in std_logic;
			x_out, y_out, z_out : 		out signed(15 downto 0);
			done				:		out std_logic
		);
	end component;

	constant test_angle: real := 22.0 / 256.0;
	constant NORM: real := 2.0;		--Dont forget to change ROM content too

	--Test signals 
	signal x_i, y_i, z_i	:	signed(15 downto 0);
	signal reset_i			:	std_logic;
	signal start_i			:	std_logic;
	signal clk_i			:	std_logic;
	signal done_i			:	std_logic;
	signal y_out_i			:	signed(15 downto 0);

	begin

		process begin
		--Predivide the input by a division of 2 otherwise 1.0 is not reppable by S0.15
		x_i	<=	to_signed(integer((1.0 / NORM) * 2.0**15), 16);
		y_i	<=	(others => '0');
		z_i	<=	to_signed(integer((test_angle / NORM) * 2.0**15), 16);
		
		reset_i	<= '1';
		--Reset
        wait for 5ns;
        reset_i	<= '0';
        start_i <= '1';
        wait for 5ns;
        start_i <= '0';
		
		wait for 180ns;
		std.env.stop(0);

		end process;

		
		CLOCK_GEN: process begin
			while true loop
			clk_i	<=	'0';
			wait for 5ns;
			clk_i	<=	'1';
			wait for 5ns;
			end loop;
		end process;

		
		correct_checker: process(done_i) 
		variable normalized_result	:	real;
		variable correct_result		:	real;
		variable abso_error			:	real;
		begin
			if done_i'event and done_i = '0' then
				--Check that y_out_i converted to integer and normalized by a constant, minus sin(z_in) is less that 0.001
				normalized_result	:=	real(to_integer(y_out_i)) / 32768.0 / 1.6468;
				correct_result		:=	sin(22.0 * MATH_PI / 180.0);
				abso_error			:=	abs(normalized_result - correct_result);
				report "Your numba is " & real'image(normalized_result);
				report "Correct numba is " & real'image(correct_result);
				report "Absolute error of " & real'image(abso_error);

				if abso_error < 0.001 then
					report "PASS";
				end if;
			end if;
		end process;


        my_CORDIC: CORDIC_PROC
            port map(
                x_in    =>  x_i,
                y_in    =>  y_i,
                z_in    =>  z_i,
                clk     =>  clk_i,
                reset   =>  reset_i,
                start   =>  start_i,
				done	=> 	done_i,

				y_out	=> 	y_out_i

            );


end architecture BHV;