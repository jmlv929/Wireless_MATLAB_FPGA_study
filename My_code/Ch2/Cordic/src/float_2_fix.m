clear; clc;

Phase_in(-pi/4)
Phase_in(pi/2)

function x_fix = Phase_in(x)
x_quan = quantizer([10 7]);
x_fix = num2bin(x_quan,x);
end



