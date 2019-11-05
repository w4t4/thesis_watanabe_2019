% sslms2rgb (ver1.0)  
% 
% Calculate rgb values (0-1) from Stockman-Sharpe lms values.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    rgb = lmsj2rgb(lmsj, ccmat);
%   
% Input:  
%   lms:    lms vector or matrices ([20;26;15] or [24,27;34,18;29 42])
%   ccmat:  color conversion matrix created by makeccmatrix.m
%
% Output:
%   rgb:    rgb vector or matrices
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 06/09/2009 (ver.1)
% 

function rgb = sslms2rgb(lms, ccmat)

[m,n]=size(lms);

lmsk = repmat(ccmat.sslmsk, 1, n);
lmsd = lms-lmsk;

rgb = ccmat.sslms2rgb * lmsd;





