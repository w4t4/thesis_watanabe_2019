inrgb = [0.001;0.001;0.001];
xyz1 = rgb2XYZ(inrgb,ccmatrix);
cx2u = makecform('xyz2upvpl');
cu2x = makecform('upvpl2xyz');
upvpl = applycform(xyz1',cx2u);

lumDivNumber = 200;
r2 = sqrt(2);
uUnitCircle = [0 1 1/r2 0 -1/r2 -1 -1/r2 0 1/r2];
vUnitCircle = [0 0 1/r2 1 1/r2 0 -1/r2 -1 -1/r2];

whiteRGB = [1;1;1];
whiteUpvpl = applycform(rgb2XYZ(whiteRGB,ccmatrix)',cx2u);
maxLuminance = whiteUpvpl(3);

monitorColorMax = zeros(8,lumDivNumber);
diviedScale = 

% 
% for i = 1:8
%     while isInMonitorColorSpace
%         upvpl(:,:,1) = upvpl(:,:,1) + uUnitCircle(j)/colorDistanceRate;
%         upvpl(:,:,2) = upvpl(:,:,2) + vUnitCircle(j)/colorDistanceRate;
%     end
% end


xyz2 = applycform(upvpl,cu2x);
outrgb = XYZ2rgb(xyz2',ccmatrix);