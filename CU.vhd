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
        k_out : out unsigned(integer(ceil(log2(real(N)))) downto 0);
        LOAD  : out std_logic;
        done  : out std_logic
    );
end entity CU;

architecture BHV of CU is
    type state_type is (IDLE, ITERATE, FINISHED);
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
                    else 
                        state <= IDLE;
                    end if;

                    k <= 0;
                    done <= '0';
		            LOAD <= '0';
                    
                when ITERATE =>
                    if k < N-1 then
                        k <= k + 1;
                        state <= ITERATE;
                    else
                        k <= 0;
                        state <= FINISHED;
                    end if;
                    
                    done <= '0';	
		            LOAD <= '0';
                    
                when FINISHED =>
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

	

end architecture BHV;

