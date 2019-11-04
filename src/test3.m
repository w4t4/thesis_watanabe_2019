inRgb = [0.01;0.01;0.01];
xyz1 = rgb2XYZ(inRgb,ccmatrix);
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
logScale = logspace(0, log10(2), lumDivNumber) - 1;
for i = 1:lumDivNumber
    xyzLogScale = rgb2XYZ([logScale(i);logScale(i);logScale(i)],ccmatrix);
    upvplLogScaledWhitePoint = applycform(xyzLogScale',cx2u)
end
colorDistanceDiff = 0.005;

for i = 1:lumDivNumber
    for j = 1:8
        while 1
            upvpl(1) = upvpl(1) + uUnitCircle(j)*colorDistanceDiff;
            upvpl(2) = upvpl(2) + vUnitCircle(j)*colorDistanceDiff;
            break;
        end
    end
end
            

% 
% for i = 1:8
%     while isInMonitorColorSpace
%         upvpl(:,:,1) = upvpl(:,:,1) + uUnitCircle(j)/colorDistanceRate;
%         upvpl(:,:,2) = upvpl(:,:,2) + vUnitCircle(j)/colorDistanceRate;
%     end
% end


xyz2 = applycform(upvpl,cu2x);
outrgb = XYZ2rgb(xyz2',ccmatrix);