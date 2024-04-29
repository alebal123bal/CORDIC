library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity CU is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        start : in std_logic;
        k_out : out unsigned(4 downto 0);
        LOAD  : out std_logic;
        done  : out std_logic
    );
end entity CU;

architecture BHV of CU is
    type state_type is (IDLE, ITERATE, FINISHED);
    signal state : state_type;
    signal k : integer range 0 to 16-1;
begin
    process (clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            LOAD <= '1';
            k <= 0;
            done  <= '0';
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    if start = '1' then
                        state <= ITERATE;
                        LOAD <= '0';
                    else 
                        state <= IDLE;
                        LOAD <=  '1';
                    end if;

                    k       <=      0;
                    done    <=      '0';
                    
                when ITERATE =>
                    if k < 16-1 then
                        if k = 14 then
                            done    <=  '1';		
                        else
                            done    <=  '0';	
                        end if;
                        k       <=    k + 1;
                        state   <=    ITERATE;
                    else
                        k       <=  0;
                        state   <=  FINISHED;
                        done    <=  '0';
                    end if;
                    
                when FINISHED =>
                    k       <=    0;
                    state   <=    IDLE;
                    done    <=    '0';
			end case;
    end if;
    end process;

	process(k) begin
		k_out <= to_unsigned(k, k_out'length);
	end process;

	

end architecture BHV;

