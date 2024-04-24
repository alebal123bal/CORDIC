------------------------------------------------
--    DIGITAL CIRCUITS FOR NEURAL NETWORKS    --
--               Daniele Vogrig               --
------------------------------------------------
-- CORDIC processor
-- Lab05 Material
------------------------------------------------
-- Package containing constants, data types and 
-- functions to be used in CORDIC processor RTL 
-- model
------------------------------------------------
-- Package Name : CORDPACK
------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

package CORDPACK is
  -- fixed point format
  constant S  : integer := 1;         -- 1: signed;  0: unsigned
  constant P  : integer := 0;         -- number of bits for integer part
  constant F  : integer := 15;        -- number of bits of fractional part
  constant N  : integer := S+P+F;     -- data number of bits
  constant SA : real    := 1.0/256.0; -- scale factor for angle FP representation

  -- number of iterations
  constant NIT  : integer := 15;
  constant NBIT : integer := integer(ceil(log2(real(NIT))));
--  constant NBIT : integer :=  4;
  
  -- data type for CORDIC angles array
  type T_CORDANGLE is array (natural range <>) of signed(N-1 downto 0);

  -- declaration of function to initialize CORDIC angles array
  function F_CORDANGLE (SCALE : real) return T_CORDANGLE;

end CORDPACK;

package body CORDPACK is
  -- body of function to initialize CORDIC angles array
  function F_CORDANGLE (SCALE: real) return T_CORDANGLE is
    variable ALPHA : T_CORDANGLE(0 to NIT-1);
    variable BETA : real;
  begin  -- F_CORDANGLE
    for K in 0 to NIT-1 loop
      -- compute arctan(2**(-k)),
      -- convert from radians to degrees (180.0/math_pi)
      BETA := arctan(2.0**(-K))*180.0/math_pi;
      -- convert to SP.F format
      ALPHA(K) := to_signed(integer(BETA*SCALE*2.0**F), N); 
    end loop;  -- K

    return ALPHA;
    
  end F_CORDANGLE;

end CORDPACK;