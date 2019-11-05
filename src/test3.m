inRgb = [0.01;0.01;0.01];
xyz1 = rgb2XYZ(inRgb,ccmatrix);
cx2u = makecform('xyz2upvpl');
cu2x = makecform('upvpl2xyz');
upvplLogScaledWhitePoint = applycform(xyz1',cx2u);

lumDivNumber = 200;
r2 = sqrt(2);
uUnitCircle = [1 1/r2 0 -1/r2 -1 -1/r2 0 1/r2];
vUnitCircle = [0 1/r2 1 1/r2 0 -1/r2 -1 -1/r2];
colorDistanceDiff = 0.005;

whiteRGB = [1;1;1];
whiteUpvpl = applycform(rgb2XYZ(whiteRGB,ccmatrix)',cx2u);
maxLuminance = whiteUpvpl(3);


monitorColorMax = zeros(lumDivNumber,3,8);
logScale = logspace(-3, 0, lumDivNumber);

for i = 1:lumDivNumber
    xyzLogScale = rgb2XYZ([logScale(i);logScale(i);logScale(i)],ccmatrix);
    upvplLogScaledWhitePoint = applycform(xyzLogScale',cx2u);
    for j = 1:8
        monitorColorMax(i,:,j) = upvplLogScaledWhitePoint;
        while 1
            monitorColorMax(i,1,j) = monitorColorMax(i,1,j) + uUnitCircle(j)*colorDistanceDiff;
            monitorColorMax(i,2,j) = monitorColorMax(i,2,j) + vUnitCircle(j)*colorDistanceDiff;
            disp(monitorColorMax(i,:,j));
            if (max(XYZ2rgb(applycform(monitorColorMax(i,:,j),cu2x)',ccmatrix)) > 1) || (min(XYZ2rgb(applycform(monitorColorMax(i,:,j),cu2x)',ccmatrix)) < 0)
                monitorColorMax(i,1,j) = monitorColorMax(i,1,j) - uUnitCircle(j)*colorDistanceDiff;
                monitorColorMax(i,2,j) = monitorColorMax(i,2,j) - vUnitCircle(j)*colorDistanceDiff;
                disp("a");
                break;
            end
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


xyz2 = applycform(upvplLogScaledWhitePoint,cu2x);
outrgb = XYZ2rgb(xyz2',ccmatrix);