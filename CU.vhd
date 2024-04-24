library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity CU is
    generic (
        N : positive := 15  -- Default value for N clock cycles
    );
    port (
        clk   : in std_logic;
        reset : in std_logic;
        start : in std_logic;
        sign_z: in std_logic;
        k_out : out unsigned(integer(ceil(log2(real(N)))) downto 0);
        dk_out: out std_logic;	--Signal that decides whether to add or subract
        LOAD  : out std_logic;
        done  : out std_logic
    );
end entity CU;

architecture BHV of CU is
    type state_type is (IDLE, ITERATE, FINISH);
    signal state : state_type;
    signal k : integer range 0 to N-1;
begin
    process (clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            k <= 0;
            done  <= '0';
            LOAD <= '1';
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    if start = '1' then
                        state <= ITERATE;
                        k <= 0;
                    end if;
                    done <= '0';
		            LOAD <= '0';
                    
                when ITERATE =>
                    if k < N-1 then
                        k <= k + 1;
                    else
                        state <= FINISH;
                    end if;
                    done <= '0';	
		            LOAD <= '0';
                    
                when FINISH =>
                    state <= IDLE;
                    done  <= '1';		
            		LOAD <= '0';

				when others =>
					state <= IDLE;
					k <= 0;
					done  <= '0';
		            LOAD <= '1';
			end case;
    end if;
    end process;

	process(k) begin
		k_out <= to_unsigned(k, k_out'length);
	end process;	
	
	process(sign_z) begin
		if sign_z = '0' then
			dk_out <= '0';
		elsif sign_z = '1' then 
			dk_out <= '1';
		else
			dk_out <= '0';
		end if;
	end process;

	

end architecture BHV;

