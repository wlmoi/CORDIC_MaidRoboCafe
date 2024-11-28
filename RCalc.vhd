
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.MATH_REAL.ALL;

entity RCalc is 
    port (
        X0 : in real;
        Y0 : in real;
        X1 : in real;
        Y1 : in real;
        length : out real);
end RCalc;

architecture Behavioral of Rcalc is

begin

    process(X0,X1,Y0,Y1)
    variable delta_x : real;
    variable delta_y : real;
    variable sum_sq : real;

begin

    delta_x := X1 - X0;
    delta_y := Y1 - Y0;
    sum_sq := delta_x * delta_x * delta_y * delta_y;
    length <= sqrt(sum_sq);

    end process;
end Behavioral;




