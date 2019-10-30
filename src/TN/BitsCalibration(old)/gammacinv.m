% gammacinv.m ver1.0
%
% Inverse gamma function for CRT intensity characteristic
%
% Argument:
% x:[k Lm j0 g](parameters for gamma function, objects for optimization)
% L:CRT intensity
%
% Gamma function:
% j = j0 + (((L-k)./(Lm-k)).^(1./g)) .* (jm-j0);
% (j: digital output)
%
% Created by Takehiro Nagai on July 2nd 2007

function j = gammacinv(L,x)

k=x(1);
Lm=x(2);
j0=x(3);
g=x(4);
jm=1;

j = j0 + (((L-k)./(Lm-k)).^(1./g)) .* (jm-j0);
