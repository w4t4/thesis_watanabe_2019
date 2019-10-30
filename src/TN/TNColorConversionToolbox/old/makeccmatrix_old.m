% makeccmatrix (ver1.0)  
% 
% Calculate different kinds of color conversion matrix.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    ccmat = makeccmatrix(rgbsr, pname);
%   
% Input:  
%   rgbsr:    spectral radiance of each of RGB (raw:wavelength, column:RGBK)
%   pmname:   name of machine for photometry ('PR-650') or ('FieldSpec')
%
% Output:
%   ccmat:    Color conversion matricies
%    .rgb2lms
%    .lms2rgb
%    .rgb2xyzj
%    .xyzj2rgb
%    .rgb2xyz
%    .xyz2rgb
%
% Other explanation:
%     Path to 'CMFs' folder must be added before using this script.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 06/05/2009 (ver.1)
% 

function ccmat = makeccmatrix(rgbsr, pmname)

% load color matching functions
if strcmp(pmname, 'PR-650') % 380nm - 780nm, 4nm 
    nm = 4; % intervals
    cf = load('cfSP1975_PR650.txt');
    cf = cf(:,2:4); % remove wavelength information
    xyzjcmf = load('xyzjcmf_PR650.txt');
    xyzjcmf = xyzjcmf(:,2:4);
    xyzcmf = load('xyzcmf_PR650.txt');
    xyzcmf = xyzcmf(:,2:4);
elseif strcmp(pmname, 'FieldSpec') % 380nm - 780nm, 1nm
    nm = 1; % intervals
    cf = load('cfSP1975_1nm.txt');
    cf = cf(1:401, 2:4); % remove wavelength information
    xyzjcmf = load('xyzjcmf_1nm.txt');
    xyzjcmf = xyzjcmf(1:401, 2:4);
    xyzcmf = load('xyzcmf_1nm.txt');
    xyzcmf = xyzcmf(1:401, 2:4);
else
    printf('Must input valid photometry machine.');
    ccmat = -1;
end

% calculate increment of sr from black
rgbsrd = [rgbsr(:,1)-rgbsr(:,4) rgbsr(:,2)-rgbsr(:,4) rgbsr(:,3)-rgbsr(:,4)];

% make LMS matricies
ccmat.rgb2lms = zeros(3);   % matrix for conversion between rgb and lms
ccmat.lmsk = zeros(3,1);    % lms values for black (rgb=0)
for i=1:3
    for j=1:3
        ccmat.rgb2lms(j,i) = sum(rgbsrd(:,i).*cf(:,j)).*683.*nm;
    end
end
ccmat.lms2rgb = inv(ccmat.rgb2lms);
for i=1:3
    ccmat.lmsk(i) = sum(rgbsr(:,4).*cf(:,i)).*683.*nm;
end

% make XYZ (modified by Judd) matricies
ccmat.rgb2xyzj = zeros(3);
ccmat.xyzjk = zeros(3,1);
for i=1:3
    for j=1:3
        ccmat.rgb2xyzj(j,i) = sum(rgbsrd(:,i).*xyzjcmf(:,j)).*683.*nm;
    end
end
ccmat.xyzj2rgb = inv(ccmat.rgb2xyzj);
for i=1:3
    ccmat.xyzjk(i) = sum(rgbsr(:,4).*xyzjcmf(:,i)).*683.*nm;
end

% make XYZ matricies
ccmat.rgb2xyz = zeros(3);
ccmat.xyzk = zeros(3,1);
for i=1:3
    for j=1:3
        ccmat.rgb2xyz(j,i) = sum(rgbsrd(:,i).*xyzcmf(:,j)).*683.*nm;
    end
end
ccmat.xyz2rgb = inv(ccmat.rgb2xyz);
for i=1:3
    ccmat.xyzk(i) = sum(rgbsr(:,4).*xyzcmf(:,i)).*683.*nm;
end



