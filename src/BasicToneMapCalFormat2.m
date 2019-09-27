function outputXYZCalFormat=BasicToneMapCalFormat2(i,inputXYZCalFormat, maxLum)
% outputXYZCalFormat = BasicToneMapCalFormat(inputXYZCalFormat, maxLum)
%
% Simple tone mapping.  Leaves any pixel with luminance below maxLum alone.
% For pixels whose luminance exceeds maxLum, scale XYZ down multiplicatively so
% that luminance is maxLum.
%
% 10/1/09 bjh, dhb     Created it.
% 10/4/09 dhb          Debug and make it work right.

% Find offending pixels
index = find(inputXYZCalFormat(i,:,2) > maxLum);
%disp(index);
% If any pixel exceeds maxLum, scale it by 1/Y.  Uses
% MATLAB's indexing trick of repeating an index to replicate 
% values.
outputXYZCalFormat(i,:,:) = inputXYZCalFormat(i,:,:);
if (~isempty(index))
  %  disp(inputXYZCalFormat(i,index,[2 2 2]'));
   outputXYZCalFormat(i,index,:) = maxLum*(inputXYZCalFormat(i,index,:)./inputXYZCalFormat(i,index,[2 2 2]')); 
end
end


%for i = 1:240
%    B = BasicToneMapCalFormat2(i,inputXYZCalFormat,maxLum)
%end