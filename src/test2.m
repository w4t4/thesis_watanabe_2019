inrgb = [0.001;0.001;0.001];
xyz1 = rgb2XYZ(inrgb,ccmatrix);
cx2u = makecform('xyz2upvpl');
upvpl = applycform(xyz1',cx2u);
upvpl(1,1) = upvpl(1,1) + 0.05;
cu2x = makecform('upvpl2xyz');
xyz2 = applycform(upvpl,cu2x);
outrgb = XYZ2rgb(xyz2',ccmatrix);