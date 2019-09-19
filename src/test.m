xyz = [23 34 45];
C = makecform('xyz2xyl');
xyl = applycform(xyz,C);
l = xyl(2);
