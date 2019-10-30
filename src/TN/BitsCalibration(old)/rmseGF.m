% rmseGF.m ver1.0
%
% Compute rms error between measured CRT intensity and a gamma function
%
% Argument:
% x:[j0 g](parameters for gamma function, objects for optimization)
% k:parameter for gamma function
% Lm:parameter for gamma function
% j:digital output
% gamma:measured CRT intensity against j
%
% Gamma function:
% L = k + (Lm - k) .* (max([j-j0; zeros(1,jleng)]) ./ (jm-j0)).^g;
% (L: CRT intensity)
%
% Created by Takehiro Nagai on July 2nd 2007

function z = rmseGF(x,k,Lm,j,gamma)

len = length(j);
leng = length(gamma);
if len~=leng
   disp('Error!The lengthes of j and gamma must be the same!');
   z = -1;
else
    sum = 0;
    para(1)=k;
    para(2)=Lm;
    para(3)=x(1);
    para(4)=x(2);
    
    for i=1:len
        sum = sum + (gammac(j(i), para) - gamma(i)).^2 ;
    end
    
    z = sum;  
end


