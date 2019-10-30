% rmseGF2.m ver1.0
%
% Compute rms error between measured CRT intensity and a gamma function
%
% Argument:
% x:[k Lm j0 g](parameters for gamma function, objects for optimization)
% j:digital output
% gamma:measured CRT intensity against j
%
% Gamma function:
% L = k + (Lm - k) .* (max([j-j0; zeros(1,jleng)]) ./ (jm-j0)).^g;
% (L: CRT intensity)
%
% Created by Takehiro Nagai on July 2nd 2007

function z = rmseGF2(x,j,gamma)

len = length(j);
leng = length(gamma);
if len~=leng
   disp('Error!The lengths of j and gamma must be the same!');
   z = -1;
else
    sum = 0;
    para = x;
    
    for i=1:len
        sum = sum + (gammac(j(i), para) - gamma(i)).^2 ;
    end
    
    z = sum;
end


