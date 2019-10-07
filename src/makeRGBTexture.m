
for i = 6:9
    a = wtXYZ2rgb(wtTonemap(SDdifferent(:,:,:,i),90,600),ccmatrix);
    wtColorCheck(a);
    figure;
    imshow(a);
end