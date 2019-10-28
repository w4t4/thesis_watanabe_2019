inrgb = [0.2;0.2;0.2];
xyz1 = rgb2XYZ(inrgb,ccmatrix);
cx2u = makecform('xyz2upvpl');
upvpl = applycform(xyz1',cx2u);
upvpl(1,1) = upvpl(1,1) + 0.0;
cu2x = makecform('upvpl2xyz');
xyz2 = applycform(upvpl,cu2x);
outrgb = XYZ2rgb(xyz2',ccmatrix);

% white point 
% 1.0: [0.198177220500708,0.471516586788029,1.090258434269667e+02]
% 0.5: [0.198185304423675,0.471495692362864,55.188633918280960]
% 0.2: [0.198208406599242,0.471435980428387,22.886308213069494]