function remappedXYZ = wRemapDiff(sameXyz,diffXyz,ccmat)


cx2u = makecform('xyz2upvpl');
cu2x = makecform('upvpl2xyz');
monitorMaxUpvpl = applycform(transpose(rgb2XYZ([1 1 1]',ccmat)),cx2u);
monitorMaxLum = monitorMaxUpvpl(3);
monitorMinUpvpl = applycform(transpose(rgb2XYZ([0 0 0]',ccmat)),cx2u);
monitorMinLum = monitorMinUpvpl(3);

upvpl = applycform(diffXyz,cx2u);
minUpvpl = min(min(applycform(sameXyz,cx2u)));
upvpl(3) = upvpl(3) - minUpvpl(3);
upvpl(3) = upvpl(3)*(monitorMaxLum-monitorMinLum)/(monitorMaxLum-minUpvpl(3));
upvpl(3) = upvpl(3) + monitorMinLum;

remappedXYZ = applycform(upvpl,cu2x);

end