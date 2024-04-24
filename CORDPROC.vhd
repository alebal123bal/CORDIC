library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity CORDIC_PROC is
	generic(
		N: positive := 15	--Number of iterations; precision is fixed by specs	
	);
	port(
		x_in, y_in, z_in	: 		in signed(15 downto 0);
		clk, reset, start	: 		in std_logic;
		x_out, y_out, z_out : 		out signed(15 downto 0)
	);
end CORDIC_PROC;

architecture BHV of CORDIC_PROC is
	
	component ROM is
		generic (
		    N : positive := 15  -- Default value for N clock cycles
		);
		port(
			k: in unsigned(integer(ceil(log2(real(N)))) downto 0);
			ak: out signed(15 downto 0)
		);
	end component;

	component ALU is 
		generic (
		    N : positive := 15  -- Needed to retreive k length
		);
		port(
			x_in, y_in, z_in: 		in signed(15 downto 0);
			reset: 					in std_logic;
			clk: 					in std_logic;
			LOAD: 					in std_logic;
			k: 						in unsigned(integer(ceil(log2(real(N)))) downto 0);
			dk_in : 				in std_logic;
			ak: 					in signed(15 downto 0);
			x_out, y_out, z_out: 	out signed(15 downto 0);
			sign_z: 				out std_logic
		);
	end component;

	component CU is
		generic (
		    N : positive := 15  -- Default value for N clock cycles
		);
		port (
		    clk   : in std_logic;
		    reset : in std_logic;
		    start : in std_logic;
			sign_z: in std_logic;
			k_out : out unsigned(integer(ceil(log2(real(N)))) downto 0);
			dk_out: out std_logic;
			LOAD  : out std_logic;
		    done  : out std_logic
		);
	end component;

	--Internal Signals declaration
	signal LOAD_i	: std_logic;
	signal k_i		: unsigned(integer(ceil(log2(real(N)))) downto 0);
	signal dk_i		: std_logic;
	signal sign_z_i : std_logic;
	signal ak_i		: signed(15 downto 0);
	signal clk_i	: std_logic;
	signal reset_i	: std_logic;
	signal start_i	: std_logic;
	signal done_i	: std_logic;

	begin
	--Component mapping
	my_CU: CU 
		generic map(N => N) 
		port map(
			clk		=>	clk_i, 
			reset	=>	reset_i, 
			start	=>	start_i, 
			sign_z	=>	sign_z_i, 
			k_out	=>	k_i, 
			dk_out 	=>	dk_i,
			LOAD	=>	LOAD_i,
			done	=>	done_i
			);

	my_ALU: ALU
		generic map(N => N)
		port map(
			x_in	=>	x_in,
			y_in	=>	y_in,
			z_in	=>	z_in,
			reset	=>	reset_i, 
			clk		=>	clk_i,
			LOAD	=>	LOAD_i,
			k		=>	k_i,
			dk_in	=>	dk_i,
			ak		=>	ak_i,
			x_out	=>	x_out,
			y_out	=>	y_out,
			z_out	=>	z_out,
			sign_z	=>	sign_z_i
		);

	my_ROM: ROM
		generic map(N => N)
		port map(
			k		=>	k_i,
			ak		=>	ak_i
		);


end BHV;