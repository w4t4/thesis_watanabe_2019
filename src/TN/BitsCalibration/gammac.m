% gammac.m ver1.0
%
% Gamma function for CRT intensity characteristic
%
% Argument:
% x:[k Lm j0 g](parameters for gamma function, objects for optimization)
% j:digital output
%
% Gamma function:
% L = k + (Lm - k) .* (max([j-j0; zeros(1,jleng)]) ./ (jm-j0)).^g;
% (L: CRT intensity)
%
% Created by Takehiro Nagai on July 2nd 2007

function L = gammac(j,x)

k=x(1);
Lm=x(2);
j0=x(3);
g=x(4);
jm=1;

jleng = length(j);

L = k + (Lm - k) .* (max([j-j0; zeros(jleng,1)]) ./ (jm-j0)).^g;
% L = k + (Lm - k) .* (max([j-j0; zeros(1, jleng)]) ./ (jm-j0)).^g;
